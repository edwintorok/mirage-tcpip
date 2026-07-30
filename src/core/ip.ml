type error = [
  | `No_route of string (** can't send a message to that destination *)
  | `Would_fragment
]
let pp_error ppf = function
  | `No_route s -> Fmt.pf ppf "no route to destination: %s" s
  | `Would_fragment -> Fmt.string ppf "would fragment"

type proto = [ `TCP | `UDP | `ICMP ]
let pp_proto ppf = function
  | `TCP -> Fmt.string ppf "TCP"
  | `UDP -> Fmt.string ppf "UDP"
  | `ICMP -> Fmt.string ppf "ICMP"

module type S = sig
  type nonrec error = private [> error]
  val pp_error: error Fmt.t
  type ipaddr
  val pp_ipaddr : ipaddr Fmt.t
  type prefix
  val pp_prefix : prefix Fmt.t
  type t
  val disconnect : t -> unit Lwt.t
  type callback = src:ipaddr -> dst:ipaddr -> Cstruct.t -> unit Lwt.t
  val input:
    t ->
    tcp:callback -> udp:callback -> default:(proto:int -> callback) ->
    Cstruct.t -> unit Lwt.t
  val write: t -> ?fragment:bool -> ?ttl:int ->
    ?src:ipaddr -> ipaddr -> proto -> ?size:int -> (Cstruct.t -> int) ->
    Cstruct.t list -> (unit, error) result Lwt.t
  val pseudoheader : t -> ?src:ipaddr -> ipaddr -> proto -> int -> Cstruct.t
  val src: t -> dst:ipaddr -> ipaddr
  val get_ip: t -> ipaddr list
  [@@ocaml.deprecated "this function will be removed soon, use [configured_ips] instead."]
  val configured_ips: t -> prefix list
  val mtu: t -> dst:ipaddr -> int
end

module Memory = struct
  type ('a, 'b) flow_fn = src:'a -> src_port:int -> dst:'a -> dst_port:int -> 'b

  (* We change the seed periodically.
    The finalisers that track memory usage will retain the original hash value,
    so the correct bucket's memory usage will get updated, so rehashing is a no-op.
    When the seed changes we might return the available memory based on the previous seed,
    and the packet will get allocated to another, but that is fine, the available memory
    could've changed anyway between sending the receive window and receiving the packet.
  *)
  let hash_flow_seed =
    let seed = Atomic.make 0 in
    fun () ->
    (Atomic.fetch_and_add seed 1) lsr 16

  let bucket_count = 1 lsl 8

  let bucket_of_flow ~src ~src_port ~dst ~dst_port =
    let flow = src, src_port, dst, dst_port
    and seed = hash_flow_seed () in
    (* assumes power of 2 for bucket_count *)
    (Hashtbl.seeded_hash seed flow) land (bucket_count - 1)

  let buckets = Array.init bucket_count (fun _ -> Atomic.make 0)
  let buckets_sum = Atomic.make 0

  let[@inline] atomic_incr a =
    let (_ : int) = Atomic.fetch_and_add a 1 in ()

  let[@inline] atomic_decr a =
    let (_ : int) = Atomic.fetch_and_add a (-1) in ()

  let buckets_incr bucket =
    atomic_incr bucket;
    atomic_incr buckets_sum

  let buckets_decr bucket () =
    atomic_decr bucket;
    atomic_decr buckets_sum

  let total_memory = Atomic.make Int.max_int

  let available ~src ~src_port ~dst ~dst_port =
    let bucket = buckets.(bucket_of_flow ~src ~src_port ~dst ~dst_port) in
    let total_memory = Atomic.get total_memory in
    let bucket_mem = total_memory lsr 1 - Atomic.get bucket
    and total_mem = total_memory - Atomic.get buckets_sum in
    Int.min bucket_mem total_mem

  let track ~src ~src_port ~dst ~dst_port t =
    let bucket = buckets.(bucket_of_flow ~src ~src_port ~dst ~dst_port) in
    let ba = Cstruct.to_bigarray t in
    let size = Bigarray.Array1.size_in_bytes ba in
    Gc.finalise_last (buckets_decr bucket size) ba;
    (* This relies on [Cstruct.of_bigarray ba] storing [ba] directly as its buffer,
      and no other code storing long-term references to [Cstruct.to_bigarray t],
      or [ba]'s parent elsewhere.
      Under those conditions the finalizer on [ba] is run when the underlying memory is freed.
    *)
    buckets_incr bucket size;
    Cstruct.of_bigarray ba
end

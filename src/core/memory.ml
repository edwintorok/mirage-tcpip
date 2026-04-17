open Mirage_net

(** for both a Set and Lwt_dllist we need ~5 words/element *)
let element_overhead = 5 * Sys.word_size

module Lwt_dllist = struct
  module T = Lwt_dllist

  type 'a t =
  { t: 'a T.t
  ; size: 'a -> int
  }

  type 'a node = 'a T.node
  
  let create size = { t = Lwt_dllist.create (); size }

  let size t elt =
    (* a large list of empty elements still uses memory, account for it *)
    t.size elt + element_overhead

  let clear t =
    let delta = T.fold_l (fun e acc -> acc + size t e) t.t 0 in
    Mem.(region.bytes <- region.bytes - delta);
    T.clear t.t

  let add delta = Mem.(region.bytes <- region.bytes + delta)
  let sub delta = Mem.(region.bytes <- region.bytes - delta)

  let set t elt v =
    let delta = size t v - size t (T.get elt) in
    add delta;
    T.set elt v

  let remove t elt =
    elt |> T.get |> size t |> sub;
    T.remove elt

  let add_l elt t =
    add (size t elt);
    T.add_l elt t.t

  let add_r elt t =
    add (size t elt);
    T.add_r elt t.t

  exception Empty

  let take_l t =
    let r = T.take_l t.t in
    sub (size t r);
    r

  let take_r t =
    let r = T.take_r t.t in
    sub (size t r);
    r

  let take_opt_l t =
    match T.take_opt_l t.t with
    | None -> None
    | Some elt as r ->
        sub (size t elt);
        r

  let take_opt_r t =
    match T.take_opt_r t.t with
    | None -> None
    | Some elt as r ->
        sub (size t elt);
        r

  (* memory usage isn't changed in the functions below *)
  let get = T.get
  let is_empty t = T.is_empty t.t
  let length t = T.length t.t
  let transfer_l a b = T.transfer_l a.t b.t
  let transfer_r a b = T.transfer_r a.t b.t
  let iter_l f t = T.iter_l f t.t
  let iter_r f t = T.iter_r f t.t
  let iter_node_l f t = T.iter_node_l f t.t
  let iter_node_r f t = T.iter_node_r f t.t
  let fold_l f t init = T.fold_l f t.t init
  let fold_r f t init = T.fold_r f t.t init
  let find_node_l f t = T.find_node_l f t.t
  let find_node_r f t = T.find_node_r f t.t
  let find_node_opt_l f t = T.find_node_opt_l f t.t
  let find_node_opt_r f t = T.find_node_opt_r f t.t
end

let update_lru (type a) (module L : Lru.F.S with type t = a) ~old next =
  let delta = L.weight next - L.weight old + element_overhead * (L.size next - L.size old) in
  Mirage_net.Mem.(region.bytes <- region.bytes + delta);
  next

let update_set (type a b) (module S: Set.S with type elt = a and type t = b) size_of ~old next =
  (* a large set of empty elements still uses memory, account for it *)
  let fold_size elt acc = acc + size_of elt + element_overhead in
  let size set =
    S.fold fold_size set 0
  in
  let delta = (S.diff next old |> size) - (S.diff old next |> size) in
  Mirage_net.Mem.(region.bytes <- region.bytes + delta);
  next

let size_lwt_u = 9 * Sys.word_size
let size_of_lwt_u (_ : _  Lwt.u) = size_lwt_u

open Mirage_net

let memory_pressure () =
  Mem.(free_bytes heap <= 0)
  || Mem.(free_bytes region <= 0)

let collect () =
  let collectable = max 512 Mem.(free_bytes heap - free_bytes region) in
  let collectable = (collectable / Sys.(word_size / 8)) in
  let (_ : int) = Gc.major_slice collectable in
  collectable

(*let should_drop ~addr_to_octets:_ ~src:_ ~dst:_ ~proto:_ ~ts:_ =
  let open Mirage_net in
  (* for now decide based just on memory pressure *)
  Mem.(free_bytes region <= 0)*)

module Track = struct
  open Gc.Memprof

  let custom_words = Atomic.make 0
  let other_words = Atomic.make 0
  let total_words = Atomic.make 0

  let last_total_words = Atomic.make 0

  let update t delta=
    if delta <> 0 then
    let (_ : int) = Atomic.fetch_and_add t delta in
    ()

  let delta sample last =
    let current = Atomic.get sample in
    let prev = Atomic.exchange last current in
    current - prev

  let max_words = Atomic.make 8192000
  (* TODO: propagate and set *)

  let packets = Atomic.make 0
  let drop_modulo = Atomic.make max_int
  
  let should_drop () =
    Atomic.set max_words (Mirage_net.Mem.heap.limit_bytes / 8);

    let index = Atomic.fetch_and_add packets 1 + 1 in
    if index mod 64 = 0 || index mod Atomic.get drop_modulo = 0 then (
      let allocation_rate = delta total_words last_total_words in
      if allocation_rate < 0 then
        Printf.eprintf "allocation rate: %d\n" allocation_rate;
      if allocation_rate <= 0 then (
        Atomic.set drop_modulo max_int;
      )
      else
        (* we are allocating faster than we are deallocating, if this keeps up,
          we'll eventually run out of memory
        *)
        (let free_words = (Atomic.get max_words - Atomic.get total_words) / 2 in
        Atomic.set drop_modulo
          (if allocation_rate >= free_words then 1
          else (free_words / allocation_rate));
        Printf.eprintf "allocation_rate: %d, free_words: %d, %d mod %d, %d, %d, %d\n"
          allocation_rate free_words index (free_words / allocation_rate)
          (Atomic.get max_words - Gc.(quick_stat ()).heap_words)
          Mirage_net.Mem.region.bytes (Atomic.get drop_modulo)
          ;
        flush stderr;
        Gc.major_slice (max allocation_rate ~-free_words)|> ignore)
    );
    if index mod Atomic.get drop_modulo = 0 then begin
       Atomic.set packets 0;
       true
    end else
      false

  let sampling_rate_words = 10_000

  let update_info source words n_samples =
    (* we don't sample all allocations, so we know there were more,
       but we don't know what kind.
       Only track this for the major heap, because for the minor heap we don't track all deallocations
    *)
    update total_words (n_samples * sampling_rate_words);
    match source with
    | Custom -> update custom_words words
    | _ -> update other_words words

  let alloc info =
    update_info info.source info.size info.n_samples;
    Some info

  let alloc_minor info =
    (* only track Custom allocations here, because they use memory from the C heap *)
    if info.source = Custom then alloc info
    else None

  let alloc_major = alloc

  let dealloc info =
    update_info info.source (-info.size) (-info.n_samples)

  let dealloc_minor = dealloc

  let dealloc_major = dealloc

  let promote info =
    Some info

  let tracker =
    { alloc_minor
    ; alloc_major
    ; promote
    ; dealloc_minor
    ; dealloc_major
    }

  let start () =
    Gc.Memprof.start ~sampling_rate:(1. /. float_of_int sampling_rate_words) ~callstack_size:0 tracker

  let stop t =
    Gc.Memprof.stop ();
    Gc.Memprof.discard t

end

let should_drop ~addr_to_octets:_ ~src:_ ~dst:_ ~proto:_ ~ts:_ =
  Track.should_drop ()

let _ =
  Track.start ()

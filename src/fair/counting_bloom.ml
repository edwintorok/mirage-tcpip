(*
  (* [int Atomic.t] produces inefficient code,
     with polling points where none are needed.
     {mutable contents: int[@atomic]} is better,
     but there is still one extra level of indirection.
     [int Atomic.Array.t] would be ideal, but needs trunk.

     For now use a regular [int array] for Mirage.
  *)
module Level = struct
  type t = int Atomic.Array.t

  let n = 1 lsl 6

  let mask = n - 1 (* assumes n is a power of 2 *)

  let init _ = Atomic.Array.make n 0

  let[@inline] get i (t : t)=
    (* no bounds check, the [mask] ensures that we are always within bounds,
       even when [i] would not be *)
    Atomic.Array.unsafe_get t (i land mask)

  let[@inline] update t i delta =
    let i = i land mask in
    let (_: int) =
      Atomic.Array.unsafe_fetch_and_add t (i land mask) delta
    in
    ()
end
*)

module Level = struct
  type t = int array

  (** OCaml {!val:Hashtbl.hash} values are always 30 bits,
    we split into 3 levels, with [2**10] bins each.

    Choices here would be:
      1 * 2**30 words = 8 GiB (too much)
      2 * 2**15 words = 512 KiB (too much)

      3 * 2**10 words = 24 KiB (acceptable)
      5 * 2**6  words = 2.5 KiB

      6 * 2**5  words = 1.5 KiB
     10 * 2**3  words = 640
     15 * 2**2  words = 480
     30 * 2**1  words = 480

    If more than 1 hash function is needed then multiple
    Counting bloom filters can be created and chained.
  *)
  let bits = 10
  let hash_bits = 30

  (** changing this also requires changing the unrolled loop in
      {!val:fold_min} and {!val:update}
  *)
  let levels = 3

  let () = assert (levels * bits = hash_bits)

  let n = 1 lsl bits

  let mask = n - 1 (* assumes n is a power of 2 *)

  let init _ = Array.make n 0

  let[@inline] get (t: t) i =
    (* no bounds check, the [mask] ensures that we are always within bounds,
       even when [i] would not be *)
    Array.unsafe_get t (i land mask)

  let[@inline] update (t: t) i delta =
    let i = i land mask in
    Array.unsafe_set t i (Array.unsafe_get t i + delta)

  let[@inline] clear t =
    Array.fill t 0 (Array.length t - 1) 0

  let[@inline] of_hash ~hash level =
    (* mask will be applied by {!val:get} and {!val:update} *)
    hash lsr (bits * level)
end

type t = Level.t array

let make () = Array.init Level.levels Level.init

let[@inline] get (t : t) level =
  assert (level >= 0 && level < Level.levels);
  Array.unsafe_get t level

let[@inline] get_bin t ~hash level =
  let bin = Level.of_hash ~hash level in
  Level.get (get t level) bin

let[@inline] fold_min t ~hash ~acc =
  (* to determine the minimum we always need to read them all *)
  let v0 = get_bin t ~hash 0
  and v1 = get_bin t ~hash 1
  and v2 = get_bin t ~hash 2 in
  (* compare as a tree to minimize dependencies *)
  Int.(min (min v1 v2) (min acc v0))

let[@inline] update_bin t ~hash ~delta level =
  let bin = Level.of_hash ~hash level in
  Level.update (get t level) bin delta

let[@inline] update t ~hash delta =
  update_bin t ~hash ~delta 0; 
  update_bin t ~hash ~delta 1;
  update_bin t ~hash ~delta 2

let[@inline] clear_bin t level =
  Level.clear (get t level)

let clear t =
  clear_bin t 0;
  clear_bin t 1;
  clear_bin t 2

module Stats = struct
  module Level = struct
    type t =
    { count: int
    ; min_nonzero: int
    ; max: int
    ; bins: int
    }

    let fold acc e =
      if e = 0 then acc
      else
      { count = acc.count + 1
      ; min_nonzero = Int.min acc.min_nonzero e
      ; max = Int.max acc.max e
      ; bins = acc.bins
      }
    
    let make (t: Level.t) =
      Array.fold_left fold { count = 0; min_nonzero = Int.max_int; max = 0; bins = Array.length t } t

    let pp =
      Fmt.(Dump.(record [
        field "count" (fun t -> t.count) int
      ; field "min_nonzero" (fun t -> t.min_nonzero) int
      ; field "max" (fun t -> t.max) int
      ; field "bins" (fun t -> t.bins) int
      ]))
  end

  type t = Level.t array

  let pp = Fmt.Dump.array Level.pp
end

let to_stats (t : t) =
  Array.map Stats.Level.make t

(* OCaml {!val:Hashtbl.hash} values are always 30 bits,
   we split into 5 levels, with 2^6 bins each.

   If more than 1 hash function is needed then multiple
   Counting bloom filters can be created and chained.
 *)

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

  let bits = 6

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

let levels = 5
let hash_bits = 30

let () = assert (levels * Level.bits = hash_bits)

let make () = Array.init levels Level.init

let[@inline] get (t : t) level =
  assert (level >= 0 && level < levels);
  Array.unsafe_get t level

let[@inline] get_bin t ~hash level =
  let bin = Level.of_hash ~hash level in
  Level.get (get t level) bin

let[@inline] fold_min t ~hash ~acc =
  (* to determine the minimum we always need to read them all *)
  let v0 = get_bin t ~hash 0
  and v1 = get_bin t ~hash 1
  and v2 = get_bin t ~hash 2
  and v3 = get_bin t ~hash 3
  and v4 = get_bin t ~hash 4 in
  (* compare as a tree to minimize dependencies *)
  let va0 = Int.min acc v0
  and v12 = Int.min v1 v2
  and v34 = Int.min v3 v4 in
  let v1234 = Int.min v12 v34 in
  Int.min va0 v1234

let[@inline] update_bin t ~hash ~delta level =
  let bin = Level.of_hash ~hash level in
  Level.update (get t level) bin delta

let[@inline] update t ~hash delta =
  update_bin t ~hash ~delta 0; 
  update_bin t ~hash ~delta 1;
  update_bin t ~hash ~delta 2;
  update_bin t ~hash ~delta 3;
  update_bin t ~hash ~delta 4

let[@inline] clear_bin t level =
  Level.clear (get t level)

let clear t =
  clear_bin t 0;
  clear_bin t 1;
  clear_bin t 2;
  clear_bin t 3;
  clear_bin t 4

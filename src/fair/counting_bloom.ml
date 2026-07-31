(* OCaml {!val:Hashtbl.hash} values are always 30 bits,
   we use 3 hash functions, 
   for a total of 15 levels, with 2^6 bins each

   Maybe lets not complicate it and use just 1 hash function
 *)

type 'a t = private {mutable x: int[@atomic]}

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

  let n = 1 lsl 6

  let mask = n - 1 (* assumes n is a power of 2 *)

  let init _ = Array.make n 0

  let[@inline] get i (t : t)=
    (* no bounds check, the [mask] ensures that we are always within bounds,
       even when [i] would not be *)
    Array.unsafe_get t (i land mask)

  let[@inline] update t i delta =
    let i = i land mask in
    Array.unsafe_set t i (Array.unsafe_get t i + delta)
end

module Levels = struct
  type t = Level.t array

  let n = 1 lsl 4
  let mask = n - 1 (* assumes n is a power of 2 *)

  (* we waste one level to avoid a bounds check *)

  let make () = Array.init n Level.init

  let[@inline] get t level bin =
    Level.get bin (Array.unsafe_get t (level land mask))

  let[@inline] fold_min t level hash offset acc =
    get t (level + offset) (hash lsr (6*offset))
    |> Int.min acc

  let[@inline] fold_min level hash t acc =
    acc
    |> fold_min t level hash 0
    |> fold_min t level hash 1
    |> fold_min t level hash 2
    |> fold_min t level hash 3
    |> fold_min t level hash 4

  let[@inline] fold_min h1 h2 h3 t =
    Int.max_int
    |> fold_min 0 h1 t
    |> fold_min 5 h2 t
    |> fold_min 10 h3 t

  let[@inline] update t level hash offset delta=
    let level = level + offset
    and bin = hash lsr (6*offset) in
    Level.update (Array.unsafe_get t (level land mask)) bin delta

  let[@inline] update t level hash delta =
    update t level hash 0 delta;
    update t level hash 1 delta;
    update t level hash 2 delta;
    update t level hash 3 delta;
    update t level hash 4 delta

  let[@poll error] update h1 h2 h3 delta t =
    update t 0 h1 delta;
    update t 5 h2 delta;
    update t 10 h3 delta
end


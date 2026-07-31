(* [int Atomic.t] produces more inefficient code
   (polling points inserted into functions that don't need one,
    probably because the compiler can't see past the 'a t in the mli?)
 *)

(* TODO: for OCaml 4.14 just use a regular [int array] *)

type el = { mutable contents: int [@atomic] }
let init _ = { contents = 0 }

type t = el Iarray.t

let[@inline] make n = Iarray.init n init

let[@inline] fetch_and_add t index v =
  Atomic.Loc.fetch_and_add [%atomic.loc t.(index).contents] v

let[@inline] get t index =
  Atomic.Loc.get [%atomic.loc t.(index).contents]



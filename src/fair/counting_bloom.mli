type t

val make: unit -> t

val fold_min: t -> hash:int -> acc:int -> int

val update: t -> hash:int -> int -> unit

val clear: t -> unit

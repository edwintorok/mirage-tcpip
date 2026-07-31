type t

val make: unit -> t

val fold_min: t -> hash:int -> acc:int -> int

val update: t -> hash:int -> int -> unit

val clear: t -> unit

module Stats: sig
    module Level: sig
        type t =
        { count: int
        ; min_nonzero: int
        ; max: int
        ; bins: int
        }
    end

    type t = Level.t array

    val pp: Format.formatter -> t -> unit
end

val to_stats: t -> Stats.t

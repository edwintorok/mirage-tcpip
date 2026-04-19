open Interface

module MakeAllocator(B: BasicAllocator)
    : Allocator with type t = B.t and type block = B.block

module GcAllocator : Allocator
module CstructAllocator : Allocator

module Interface: module type of Interface

val pp: Format.formatter -> info -> unit

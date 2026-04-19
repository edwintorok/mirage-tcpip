module ValueAlloc: S.Allocator
module BigarrayAlloc : S.Allocator
module S: module type of S

(** Create an allocation pattern that results in the largest fragmentation.

    {b References.}
    {ul
      {- Hasan, Yusuf, Wei-Mei Chen, J. Morris Chang, and Bashar M. Gharaibeh.
      {{:https://doi.org/10.1109/TC.2009.154.}
      {e Upper Bounds for Dynamic Memory Allocation}}. IEEE Trans. Comput. 59, no. 4 (2010): 468–77.}

      {- SQLite. {{:https://www.sqlite.org/malloc.html#_mathematical_guarantees_against_memory_allocation_failures}{e Mathematical Guarantees Against Memory Allocation Failures}}}
    }
 *)
module Fragment(A: S.Allocator) : sig
    val with_contiguous : alloc_min:int -> bytes:int -> (unit -> 'a) -> 'a

    val with_fragmented : alloc_min:int -> alloc_max:int -> bytes:int -> (unit -> 'a) -> 'a
end

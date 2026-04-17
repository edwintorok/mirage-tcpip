module type BasicAllocator = sig
  (** {2 Allocator connection} *)

  (** a connection to the allocator under test *)
  type t

  val connect: unit -> t
  (** [connect ()] connects to the allocator under test *)

  val disconnect: t -> unit
  (** [disconnect t] disconnects from the allocator [t] *)

  (** {2 Allocator functions} *)

  type block
  (** an allocated block *)

  val alloc: t-> int -> block
  (** [alloc t n] allocates a block of [n] bytes on the allocator [t] *)

  val free: t -> block -> block
  (** [free t block] frees the previously allocated [block] on the allocator [t],
      and returns a dummy [block].
   *)

  val size_min_bytes: t -> int
  (** [size_min_bytes t] is the minimum allocation size.

      All allocation requests will be a power of 2 multiple of this size.
   *)

  val probe_min_bytes: t -> int
  (** [probe_min_bytes t] is the minimum size used when probing for allocator maximums.

      [size_min_bytes] may not always be suitable for this (e.g. it can cause the minor heap to run out of space, and then we the program crashes with a fatal error)
      This should only be set for local allocators, not for remote ones (where ensuring that it doesn't crash is the goal)
  *)
end

(** An allocator under test.
    Can be a local or remote system.
 *)
module type Allocator = sig
  include BasicAllocator

  (** {2 Allocator properties} *)

  val overhead_bytes: t -> int
  (** [overhead_bytes t] is the overhead for keeping an entry allocated, independent of its size.
      When the allocator is local this is the size the entry in an array.
   *)

  val size_max_bytes: t -> int
  (** [size_max_bytes t] is the largest allocation size that can succeed.

      This can be less than {!val:total_bytes}.
   *)

  val total_bytes: t -> int
  (** [total_bytes t] the total amount of space available to the allocator.
      [total_bytes t >= size_max_bytes t >= size_min_bytes t]
   *)
end

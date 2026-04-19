type info =
{ min_bytes: int (** the minimum allocation size *)
; max_bytes: int (** the maximum allocation size *)
; total_bytes: int (** the total amount of bytes that can be successfully allocated *)
; overhead_bytes: int (** overhead associated with an allocation, independent of its size, when there is no fragmentation *)
}

module type BasicAllocator = sig
  (** {2 Allocator connection} *)

  (** a connection to the allocator under test *)
  type t

  val connect: unit -> t
  (** [connect ()] connects to the allocator under test *)

  val disconnect: t -> unit
  (** [disconnect t] disconnects from the allocator [t] *)

  val name: string
  (** [name] the name of this allocator *)

  (** {2 Allocator functions} *)

  type block
  (** an allocated block *)

  val alloc: t-> int -> block
  (** [alloc t n] allocates a block of [n] bytes on the allocator [t] *)

  val free: t -> block -> block
  (** [free t block] frees the previously allocated [block] on the allocator [t],
      and returns a dummy [block].
   *)
end

(** An allocator under test.
    Can be a local or remote system.
 *)
module type Allocator = sig
  include BasicAllocator

  (** {2 Allocator properties/information} *)
  val info: t -> info
end

(** An allocator under test *)
module type Allocator = sig
  (** {2 Allocator functions} *)

  type t
  (** an allocated block *)

  val empty: t
  (** [empty] is used as a placeholder after freeing an allocated block.
      Should be an allocation of size 0, or the smallest allowed by the allocator.
   *)

  val alloc: int -> t
  (** [alloc n] allocates a block of [n] bytes. *)

  val free: t -> unit
  (** [free block] frees the previously allocated [block]. *)
end

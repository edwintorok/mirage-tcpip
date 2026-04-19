let word_size_bytes = Sys.word_size / 8

module ValueAlloc = struct
  type t = string

  let empty = ""

  let string_overhead =
    (* GC header + string padding *)
    2 * word_size_bytes 

  let alloc = function
    | 0 -> empty
    | n ->
        String.make (max 0 @@ n - string_overhead) 'x'

  let free _ = ()
end

module BigarrayAlloc = struct
  open Bigarray

  (* like [Cstruct.t], but without depending on it *)
  type buffer = (char, int8_unsigned_elt, c_layout) Array1.t
  type t = {
    buffer: buffer;
    off   : int;
    len   : int;
  }

  let alloc n =
    (* the overhead here is on the C side and is implementation dependent *)
    { buffer = Array1.create char c_layout n
    ; off = 0
    ; len = 0 }

  let empty = alloc 0

  let free _ = ()
end

module Fragment(A: S.Allocator) = struct
  let alloc_blocks ~count size =
    Array.init count (fun _ -> A.alloc size)

  let free block =
    (* avoid double-free *)
    if not (block == A.empty) then
      A.free block

  let dealloc_block block =
    free block;
    A.empty

  let with_contiguous ~alloc_min ~bytes f =
    (* account for array overhead *)
    let count = bytes / (alloc_min + word_size_bytes) in
    let blocks = alloc_blocks ~count alloc_min in
    let finally () =
      Array.iteri (fun i e -> blocks.(i) <- dealloc_block e) blocks
    in
    Fun.protect ~finally f

  let free_blocks blocks =
    Array.iter free blocks

  let free_blocks2 blocks2 =
    Array.iter free_blocks blocks2

  (** [with_fragmented_pow2 ~bytes ~alloc_min ~l f] allocates [bytes >= alloc_min * 2**l] bytes, and calls [f].
      The allocated block sizes are [alloc_min * 2**i], with [0 <= i < l].
  *)
  let with_fragmented_pow2 ~bytes ~alloc_min ~l f =
    (* blocks_size_pow2.(x) are allocated blocks of size alloc_min * 2**x]*)
    let blocks_size_pow2 = Array.make l [||] in

    (* [alloc_cycle ~count i] allocates [count] blocks of size [alloc_min * 2**i].

        [i] is the cycle 1-based cycle index
     *)
    let alloc_cycle ~count i =
        blocks_size_pow2.(i-1) <- alloc_blocks ~count (alloc_min lsl (i-1))

     (* [dealloc_cycle i] deallocates blocks from cycles [[1, i]],
       in total half the allocated bytes are freed.
       The largest gap is smaller than the next cycle's allocation size,
       such that in the next cycle it cannot reuse any of the gaps,
       maximizing fragmentation.
     *)
    and dealloc_cycle i =
        for j = 1 to i do
          let blocks = blocks_size_pow2.(j-1) in
          blocks |> Array.iteri @@ fun k e ->
            if (k + 1) mod (1 lsl (i - j + 1)) <> 0 then
              blocks.(k) <- dealloc_block e
          done
    in
    (* First cycle: allocate [m] bytes.
      Free [m/2] bytes, such that gaps are exactly of [alloc_min] bytes.
      The gaps cannot be used for larger allocations in the next cycles (unless the allocator can move memory, like a GC).
    *)
    let () =
      let count = bytes / alloc_min in
      alloc_cycle ~count 1;
      let blocks = blocks_size_pow2.(0) in
      blocks |> Array.iteri (fun k e ->
        if (k+1) mod 2 <> 0 then
          blocks.(k) <- dealloc_block e
      )
    in

    (* Cycle [i]: allocate [m] bytes, using allocations of size [alloc_min * 2**i].
      Then free in total [m/2] bytes from previous cycles, such that the largest gap is [alloc_min * 2**(i-1)]. The gaps cannot be used for allocations in the next cycle for a non-moving allocator.

      the paper seems to have an off-by-one error on [i], it should go up to [l-1] when using 1-based indexes, otherwise we never allocate blocks of size [l-2]
    *)
    for i = 2 to l - 1 do
      let count = bytes / (alloc_min lsl i) in
      (* allocates [bytes/2] bytes
         [(bytes / (alloc_min lsl i)) * alloc_min lsl (i-1)]
       *)
      alloc_cycle ~count i;

      (* frees [bytes/2] bytes from previous cycles *)
      dealloc_cycle i;
    done;
    blocks_size_pow2.(l-1) <- [|A.alloc (alloc_min lsl (l-1))|];
    let finally () = free_blocks2 blocks_size_pow2 in
    Fun.protect ~finally f

  (** [with_fragmented' ~bytes ~alloc_min f] allocates [bytes] using multiples of [alloc_min] blocks,
      and then calls [f ()].
      The largest single allocation size is [bytes/2].
   *)
  let with_fragmented  ~alloc_min ~alloc_max ~bytes f =
    (* [bytes] may not be a power of [2], so use multiple allocations, each a power of 2. *)
    let rec loop ~remaining ~l =
      if remaining <= 0 then f ()
      else
      if 1 land ((remaining / alloc_min) lsr l) = 0 &&
         alloc_min lsl l <= alloc_max
      then
        (loop[@tailcall]) ~remaining ~l:(succ l)
      else
      let bytes = remaining - remaining land (1 lsl l - 1) in
      let remaining = remaining - bytes in
      if remaining < 0 then f ()
      else
        with_fragmented_pow2 ~bytes ~alloc_min ~l @@ fun () ->
        (loop[@tailcall]) ~remaining ~l:(succ l)
    in
    loop ~remaining:bytes ~l:1
end

module S = S

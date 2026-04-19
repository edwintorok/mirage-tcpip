open Memstress

module ValueFragment = Fragment(ValueAlloc)
module BigarrayFragment = Fragment(BigarrayAlloc)

let balloc n =
  Bigarray.(Array1.create char c_layout n)

let calloc n =
  try balloc n
  with Out_of_memory ->
    Gc.full_major ();
    balloc n

let rec probe_free_mem ~ok n =
  match calloc n with
  | exception Out_of_memory -> ok
  | _ ->
      probe_free_mem ~ok:n (n lsl 1)

let () =
  let word_size_bytes = Sys.word_size / 8 in
  let minor_heap_size_bytes = Gc.(get ()).minor_heap_size * word_size_bytes in
  let alloc_min = 2 * word_size_bytes
  and alloc_max = 256 * word_size_bytes (* Max_young_wosize *)

  (* According to
     https://sqlite.org/malloc.html#_mathematical_guarantees_against_memory_allocation_failures

     n = alloc_max / alloc_min = 128
     M = 2MiB (minor heap size)
     N = M*4.5 - 127 = 9437057

     Testing shows that on OCaml ~8.4MiB are required for the major heap
     to avoid OOM errors.
     (OCaml moves values in the minor heap, so the fragmentation is less
     than for a non-moving allocator).
     So about 4.2x the minor heap size (with 1 domain).
     For safety we can use the 4.5 multiplier.
     
     There is a similar ratio for Cstructs:
     n = alloc_max / alloc_min = 1514 / 16 (* 2 fragmented IP packets *) = 94.625
     A 4.5 multiplier works here too
   *)
  in

  Printf.eprintf "Checking allocations in the minor heap\n";
  (* Check that allocation in the minor heap works *)
  Gc.compact ();
  let verify () =
    (* Check that the GC still has enough room to work *)
    Gc.full_major ();
    let stat = Gc.quick_stat () in
    Printf.eprintf "Heap size required: %d bytes (minor heap: %d bytes)\n"
      (stat.top_heap_words * word_size_bytes) minor_heap_size_bytes;
    flush stderr
  in
  ValueFragment.with_contiguous ~bytes:minor_heap_size_bytes ~alloc_min verify;
  Gc.compact ();
  ValueFragment.with_fragmented ~bytes:minor_heap_size_bytes ~alloc_min ~alloc_max verify;
  Gc.compact ();

  let alloc_min = 16 + 3 * word_size_bytes
  and alloc_max = (*1514 + 3 * word_size_bytes rounded up *) 64 * alloc_min in
  Printf.eprintf "Checking bigarray allocations\n";
  Gc.compact ();
  BigarrayFragment.with_contiguous ~bytes:minor_heap_size_bytes ~alloc_min verify;
  Gc.compact ();
  BigarrayFragment.with_fragmented ~bytes:minor_heap_size_bytes ~alloc_min ~alloc_max verify;
  Gc.compact ();

  let mem = probe_free_mem ~ok:0 4096 in
  Printf.eprintf "Probed mem:  %16d\n" mem;

  (* /8 is much worse than anticipated, but /7 fails with heap sizes between 640MiB and above *)
  let bytes = (mem - minor_heap_size_bytes * 9/2) / 8 in
  Printf.eprintf "Network mem: %16d\n" bytes;

  Gc.compact ();
  let () =
    BigarrayFragment.with_contiguous ~bytes ~alloc_min @@ fun () ->
      BigarrayFragment.with_contiguous ~bytes:minor_heap_size_bytes ~alloc_min:(2*word_size_bytes) verify
  in
  Gc.compact ();
  let () =
    BigarrayFragment.with_fragmented ~bytes ~alloc_min ~alloc_max @@ fun () ->
      ValueFragment.with_fragmented ~bytes:minor_heap_size_bytes
        ~alloc_min:(2*word_size_bytes)
        ~alloc_max:(256*word_size_bytes)
        verify
  in
  Gc.compact ()



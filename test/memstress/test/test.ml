open Memstress

module IntMap = Map.Make(Int)

module TestAlloc = struct
  type t = int

  let bytes = ref 0
  let rindex = ref 0
  let allocated = ref IntMap.empty
  let empty = -1

  let alloc size =
    bytes := !bytes + size;
    let index = !rindex in
    incr rindex;

    let largest_gap, _ = IntMap.fold (fun _ v (largest_gap, gap) ->
      if v < 0 then largest_gap, gap - v
      else
        (* found an allocation, reset gap *)
        max largest_gap gap, 0
    ) !allocated (0, 0) in
    if largest_gap >= size then
      Alcotest.failf "[%d] = Allocation of size %d can be fulfilled by a previous gap of %d" index size largest_gap;

    allocated := IntMap.add index size !allocated;
    Printf.printf "[%d] = Alloc %d; total = %d; largest gap = %d\n" index size !bytes largest_gap;
    index

  let free index =
    match IntMap.find_opt index !allocated with
    | None ->
        Alcotest.failf "[%d] = Not yet allocated" index;
    | Some size ->
        if size < 0 then
          Alcotest.failf "[%d] = Double free, size = %d" index ~-size;
        bytes := !bytes - size;
        Printf.printf "[%d] = Free %d; total = %d\n" index size !bytes;
        allocated := 
          if fst (IntMap.max_binding !allocated) = index then
            IntMap.remove index !allocated
          else
            IntMap.add index (-size) !allocated
end

module Test = Fragment(TestAlloc)

let () =
  let () = Test.with_fragmented ~bytes:16 ~alloc_min:1 ~alloc_max:16 @@ fun () ->
    Alcotest.(check' int ~expected:16 ~actual:!TestAlloc.bytes ~msg:"allocated bytes")
  in
  Alcotest.(check' int ~expected:0 ~actual:!TestAlloc.bytes ~msg:"remaining bytes after freeing all")



open Interface

module LocalAlloc = struct
  type t = unit
  let connect = ignore
  let disconnect = ignore
end

module GcAlloc = struct
  include LocalAlloc

  type block = string

  let string_overhead =
    (* GC header + string padding *)
    2 * Sys.word_size / 8

  let alloc () n =
    String.make (n - string_overhead) 'x'

  let free () _ = ""
  
  let name = "gc"
end

module GcMajorAlloc = struct
  include GcAlloc

  let alloc () n =
    (* Max_young_wosize is 256 * 8 = 2048,
       but account for possible future growth and use 4KiB
     *)
    if n < 1 lsl 12 then invalid_arg "only major allocations";
    alloc () n
end

module CstructAlloc = struct
  include LocalAlloc

  type block = Cstruct.t

  let alloc () n =
    if n < 1 lsl 12 then invalid_arg "only major allocations";
    Cstruct.create n

  let free () _ = Cstruct.empty

  let name = "cstruct"
end

module MakeAllocator(B: BasicAllocator) = struct
  include B

  let alloc' ?min_bytes ?max_bytes t n =
    let () = match min_bytes with
    | None -> ()
    | Some v -> if n < v then invalid_arg "min_bytes"
    in
    let () = match max_bytes with
    | None -> ()
    | Some v -> if n > v then invalid_arg "max_bytes"
    in
    try B.alloc t n
    with Out_of_memory ->
      Gc.compact ();
      B.alloc t n

  let rec probe t ~count ~sum ~items ?alloc_max_bytes ?total_count ?total_bytes ?min_bytes ?max_bytes n =
    if n < (Option.value ~default:1 min_bytes) then
      match min_bytes, max_bytes, total_count, total_bytes with
      | Some min_bytes, Some max_bytes, Some total_count, Some total_bytes ->
          (* mem = total_bytes + total_count * overhead = sum + count * overhead *)
          let overhead_bytes = Int.max 0 ((total_bytes - sum) / (count - total_count)) in
          { overhead_bytes
          ; min_bytes
          ; max_bytes
          ; total_bytes
          }
      | _ ->
      match min_bytes, max_bytes with
      | Some min_bytes, Some max_bytes ->
        (* We allocated [total_bytes] using different sizes, now try filling it using minimum size only.
           We can calculate the overhead from the different number of counts and sums when using different sizes (assuming a constant overhead)
         *)
        (probe[@tailcall]) t ~count:0 ~sum:0 ~items:[] ~alloc_max_bytes:min_bytes ~total_count:count ~total_bytes:sum ~min_bytes ~max_bytes min_bytes
      | _ -> invalid_arg "n < 0"
    else
    match
    alloc' ?min_bytes ?max_bytes:alloc_max_bytes t n :: items with
    | exception Invalid_argument _ when min_bytes = None ->
        (* we haven't yet found the minimum accepted size, keep increasing *)
        (probe[@tailcall]) t ~count ~sum ~items ?total_count ?total_bytes ?alloc_max_bytes ?min_bytes ?max_bytes (n lsl 1)
    | exception (Out_of_memory | Invalid_argument _) ->
        (* allocation failed, decrease size *)
        (probe[@tailcall]) t ~count ~sum ~items ?total_count ?total_bytes ?alloc_max_bytes ?min_bytes ?max_bytes (n lsr 1)
    | items ->
        (* allocation succeeded, store last succesful size, increase next size *)
        let min_bytes = Int.min (Option.value ~default:n min_bytes) n
        and max_bytes = Int.max (Option.value ~default:n max_bytes) n in
        (probe[@tailcall]) t ~count:(count + 1) ~sum:(sum + n) ?total_count ?alloc_max_bytes ?total_bytes ~items ~min_bytes ~max_bytes (n lsl 1)

    let info t =
      let t = probe t ~count:0 ~sum:0 ~items:[] 1 in
      Gc.compact ();
      t
end

module GcMajorAllocator = MakeAllocator(GcMajorAlloc)

module GcAllocator = struct
  include GcMajorAllocator
  let info t =
    { (info t) with min_bytes = 2 * Sys.word_size / 8}
end

module CstructAllocator = struct
  include MakeAllocator(CstructAlloc)
  let info t =
    { (info t) with min_bytes = 2 * Sys.word_size / 8}
end

module Interface = Interface

let pp ppf info =
  Format.fprintf ppf "@[min_bytes = %d;@,max_bytes = %d;@,total_bytes = %d;@,overhead_bytes = %d@]"
    info.min_bytes info.max_bytes info.total_bytes info.overhead_bytes

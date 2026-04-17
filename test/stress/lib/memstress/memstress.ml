open Interface

(** [find_last pred ~lo ~hi] finds the highest [x] in [[lo, hi]], such that [pred x] holds.
    if [pred x] is [false], then all [pred y] in [[x, hi]] is also [false].
  *)
let find_last pred  ~lo ~hi =
  let rec loop ~ok ~lo ~hi =
    if (lo > hi) then ok
    else
      let mid = lo + (hi - lo) lsr 1 in
      if pred mid then
        (loop[@tailcall]) ~ok:mid ~lo:(mid+1) ~hi
      else
        (* we know that [mid] failed, so the max size has to be
          [[lo, mid)]
        *)
        (loop[@tailcall]) ~ok ~lo ~hi:(mid-1)
    in
    assert (pred lo);
    loop ~ok:lo ~lo ~hi

module MakeAllocator(B: BasicAllocator) = struct
  include B

  let maybe_alloc t aux n =
    try B.alloc t n :: aux
    with Out_of_memory | Invalid_argument _ -> aux

  let can_alloc t n =
    maybe_alloc t [] n |> List.is_empty |> not

  let size_max_bytes t =
    find_last (can_alloc t) ~lo:(size_min_bytes t) ~hi:Sys.max_string_length

  let rec probe_loop t ~count ~sum ~items ~ok ~n =
    let items' = maybe_alloc t items n in
    (* physical equality, avoids extra allocations from an option *)
    if items' == items then
      probe_loop t ~count ~sum ~items (n lsr 1)
    else
      probe_loop t ~count ~sum ~items (n lsl 1)

    match maybe_alloc t items n with
    | 
    let count' = count + 1
    and sum' = sum + n in
    match B.alloc t n with
    | block ->
      probe_loop t ~count:count' ~sum:sum' ~items:(block :: items) ~n:(n lsl 1)
    | exception (Out_of_memory | Invalid_argument _) ->
      Gc.compact ();
      match B.alloc t n with
      | block ->
        probe_loop t ~count:count' ~sum:sum' ~items:(block :: items) ~n:(n lsl 1)
      | exception (Out_of_memory | Invalid_argument _) ->
        probe_loop t ~count ~sum ~items ~n:(n lsr 1)

  let probe t =
    loop ~count:0 ~sum:0 ~items:[] ~n:(B.probe_min_bytes t)



end


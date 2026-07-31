open Tcpip_fair

open Counting_bloom

let levels = make () |> to_stats |> Array.length

let entries =
  let t = make () |> to_stats in
  Array.fold_left (fun acc l -> acc + l.Stats.Level.bins) 0 t

let bins = entries / levels

let test_empty () =
  let stats = make () |> to_stats in
  assert (Array.for_all (fun t -> t.Stats.Level.count = 0) stats)

let make_fill n =
  let t = make () in
  for i = 1 to n do
    let hash = Hashtbl.hash i in
    update t ~hash 1
  done;
  t

let test_one () =
  for i = 1 to (1 lsl 16) do
    let t = make () in
    let hash = Hashtbl.hash i in
    update t ~hash 1;
    let v = fold_min t ~hash ~acc:Int.max_int in
    assert (v = 1)
  done


let test_half () =
  let count = bins lsr 2 in
  let t = make_fill count in
  let stats = to_stats t in
  Format.printf "%a@." Stats.pp stats;
  let collisions = ref 0 in
  for i = 1 to count do
    let hash = Hashtbl.hash i in
    let v = fold_min t ~hash ~acc:Int.max_int in
    if v <> 1 then incr collisions
  done;
  let collisions = !collisions in
  Format.printf "count: %d, collisions: %d@." count collisions;
  assert (collisions < 2 * count / 100)

let test_full () =
  (* insert more entries than the bloom filter's size *)
  let count = entries lsl 2 in
  let t = make_fill count |> to_stats in
  Format.printf "%a@." Stats.pp t;
  Array.iter (fun t -> assert (t.Stats.Level.count = bins)) t

let test_all () =
  let count = 1 lsl 30 in
  let t = make () in
  for hash = 0 to count-1 do
    update t ~hash 1
  done;
  let t = to_stats t in
  Format.printf "%a@." Stats.pp t;
  Array.iter (fun t -> assert (t.Stats.Level.count = bins)) t;
  Array.iter (fun t -> assert (t.Stats.Level.min_nonzero = count / bins)) t;
  Array.iter (fun t -> assert (t.Stats.Level.max = count / bins)) t

let test_uniform () =
  let count = 1 lsl 30 in
  let t = make_fill count |> to_stats in
  Format.printf "%a@." Stats.pp t;
  let avg = count / bins in
  Array.iter (fun t -> assert (t.Stats.Level.count = bins)) t;
  Array.iter (fun t -> assert (avg - t.Stats.Level.min_nonzero < avg / 100)) t;
  Array.iter (fun t -> assert (t.Stats.Level.max - avg < avg/100)) t

let test_first_fp () =
  let t = make () in
  let rec loop prev_str i =
    let hash = Hashtbl.hash (Random.bits ()) in
    update t ~hash 1;
    let count = (fold_min t ~hash ~acc:Int.max_int) in
    let fp = ref 0 in
    let str = ref prev_str in
    if count > 1 then begin
      incr fp;
      for j = 0 to i-1 do
          let hash = Hashtbl.hash j in
          if (fold_min t ~hash ~acc:Int.max_int) > 1 then
            incr fp
      done;
      let pct =  100. *. float_of_int !fp /. float_of_int i in
      str := Format.sprintf "%.1f%%" pct;
      if !str <> prev_str then
        Format.printf "%d,%s@." i !str
    end;
    if i = 0 || !fp < i then
      (loop[@tailcall]) !str (i+1)
  in
  loop "" 0;
  Format.printf "%a@.d" Stats.pp (to_stats t)


let () =
  test_first_fp ();
  test_empty ();
  test_one ();
  test_full ();
  test_half ();
  test_all ();
  test_uniform ()


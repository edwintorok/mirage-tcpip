open Mirage_net

(** for both a Set and Lwt_dllist we need ~5 words/element *)
let element_overhead = 5 * Sys.word_size

module Lwt_dllist = struct
  module T = Lwt_dllist

  type 'a t =
  { t: 'a T.t
  ; size: 'a -> int
  }

  type 'a node = 'a T.node
  
  let create size = { t = Lwt_dllist.create (); size }

  let size t elt =
    (* a large list of empty elements still uses memory, account for it *)
    t.size elt + element_overhead

  let clear t =
    let delta = -T.fold_l (fun e acc -> acc + size t e) t.t 0 in
    Memory.update ~delta;
    T.clear t.t

  let add delta = Memory.update ~delta
  let sub delta = Memory.update ~delta:(-delta)

  let set t elt v =
    let delta = size t v - size t (T.get elt) in
    add delta;
    T.set elt v

  let remove t elt =
    elt |> T.get |> size t |> sub;
    T.remove elt

  let add_l elt t =
    add (size t elt);
    T.add_l elt t.t

  let add_r elt t =
    add (size t elt);
    T.add_r elt t.t

  exception Empty

  let take_l t =
    let r = T.take_l t.t in
    sub (size t r);
    r

  let take_r t =
    let r = T.take_r t.t in
    sub (size t r);
    r

  let take_opt_l t =
    match T.take_opt_l t.t with
    | None -> None
    | Some elt as r ->
        sub (size t elt);
        r

  let take_opt_r t =
    match T.take_opt_r t.t with
    | None -> None
    | Some elt as r ->
        sub (size t elt);
        r

  (* memory usage isn't changed in the functions below *)
  let get = T.get
  let is_empty t = T.is_empty t.t
  let length t = T.length t.t
  let transfer_l a b = T.transfer_l a.t b.t
  let transfer_r a b = T.transfer_r a.t b.t
  let iter_l f t = T.iter_l f t.t
  let iter_r f t = T.iter_r f t.t
  let iter_node_l f t = T.iter_node_l f t.t
  let iter_node_r f t = T.iter_node_r f t.t
  let fold_l f t init = T.fold_l f t.t init
  let fold_r f t init = T.fold_r f t.t init
  let find_node_l f t = T.find_node_l f t.t
  let find_node_r f t = T.find_node_r f t.t
  let find_node_opt_l f t = T.find_node_opt_l f t.t
  let find_node_opt_r f t = T.find_node_opt_r f t.t
end

let update_lru (type a) (module L : Lru.F.S with type t = a) ~old next =
  let delta = L.weight next - L.weight old + element_overhead * (L.size next - L.size old) in
  Mirage_net.Memory.update ~delta;
  next

let update_set (type a b) (module S: Set.S with type elt = a and type t = b) size_of ~old next =
  (* a large set of empty elements still uses memory, account for it *)
  let fold_size elt acc = acc + size_of elt + element_overhead in
  let size set =
    S.fold fold_size set 0
  in
  let delta = (S.diff next old |> size) - (S.diff old next |> size) in
  Mirage_net.Memory.update ~delta;
  next

let size_lwt_u = 9 * Sys.word_size
let size_of_lwt_u (_ : _  Lwt.u) = size_lwt_u

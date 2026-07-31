external hash_mix_uint32 : (int32[@unboxed]) -> (int32[@unboxed]) -> (int32[@unboxed]) = "TODO" "caml_hash_mix_uint32" [@@noalloc]

module V46 = struct
  type t =
  { src_range1: Counting_bloom.t (* /16 on ipv4 or /29 ipv6, max RIPE NCC allocation *)
  ; src_range2: Counting_bloom.t (* /24 on ipv4 or /48 ipv6, routing prefix *)
  ; src: Counting_bloom.t
  ; src_with_port: Counting_bloom.t
  ; dst_with_port: Counting_bloom.t
  }

  (* TODO: rotating random seed for single "noisy neighbour" in hash param,
     and different hash param for each
   *)

  let[@inline] fold_min t src_range1 src_range2 src src_with_port dst_with_port acc =
    acc
    |> Counting_bloom.fold_min t.src_range1 ~hash:src_range1
    |> Counting_bloom.fold_min t.src_range2 ~hash:src_range2
    |> Counting_bloom.fold_min t.src ~hash:src
    |> Counting_bloom.fold_min t.src_with_port ~hash:src_with_port
    |> Counting_bloom.fold_min t.dst_with_port ~hash:dst_with_port

  let[@inline] update t src_range1 src_range2 src src_with_port dst_with_port delta=
    Counting_bloom.update t.src_range1 ~hash:src_range1 delta;
    Counting_bloom.update t.src_range2 ~hash:src_range2 delta;
    Counting_bloom.update t.src ~hash:src delta;
    Counting_bloom.update t.src_with_port ~hash:src_with_port delta;
    Counting_bloom.update t.dst_with_port ~hash:dst_with_port delta
end

module V4 = struct
  let[@inline] prefix addr n =
    Int32.shift_right_logical addr n |> Int32.to_int |> Hashtbl.hash

  let fold_min t src src_port dst dst_port acc =
    let src = Ipaddr.V4.to_int32 src
    and dst = Ipaddr.V4.to_int32 dst in
    (* TODO: mix chain *)
    V46.fold_min t (prefix src 16) (prefix src 24) (Hashtbl.hash src) (Hashtbl.hash (src, src_port))
      (Hashtbl.hash (dst, dst_port)) acc

  let update t src src_port dst dst_port delta =
    let src = Ipaddr.V4.to_int32 src
    and dst = Ipaddr.V4.to_int32 dst in
    (* TODO: mix chain *)
    V46.update t (prefix src 16) (prefix src 24) (Hashtbl.hash src) (Hashtbl.hash (src, src_port))
      (Hashtbl.hash (dst, dst_port)) delta
end

module V6 = struct

  let[@inline] prefix addr n =
    (* TODO: hash mix instead *)
    String.sub addr 0 (n-1) |> Hashtbl.hash

  let fold_min t src (src_port:int) dst (dst_port:int) acc =
    let src = Ipaddr.V6.to_octets src
    and dst = Ipaddr.V6.to_octets dst in
    (* TODO: mix chain *)
    V46.fold_min t (prefix src 29) (prefix src 48) (Hashtbl.hash src) (Hashtbl.hash (src, src_port))
      (Hashtbl.hash (dst, dst_port)) acc

  let update t src (src_port:int) dst (dst_port:int) delta =
    let src = Ipaddr.V6.to_octets src
    and dst = Ipaddr.V6.to_octets dst in
    (* TODO: mix chain *)
    V46.update t (prefix src 29) (prefix src 48) (Hashtbl.hash src) (Hashtbl.hash (src, src_port))
      (Hashtbl.hash (dst, dst_port)) delta
end


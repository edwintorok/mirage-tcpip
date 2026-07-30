let hash_ipv4 ipv4 =
  (* on 32-bit this loses 1 bit, but we only calculate a hash here *)
  let addr = ipv4 |> Ipaddr.V4.to_int32 |> Int32.to_int in
  let l0 = addr lsr 8 (* addr/8 *)
  and l1 = addr lsr 16 (* addr/16 *)
  and l2 = addr lsr 24 (* addr/24 *)
  and l3 = addr in     (* addr/32 *)
  (* TODO use all 4 levels separately *)
  l0+l1+l2+l3

let hash_ipv6 ipv6 =
  let addr = Ipaddr.V6.to_octets ipv6 in
  let s0 = String.unsafe_get addr 0 |> Char.code
  and s1 = String.unsafe_get addr 1 |> Char.code
  and s2 = String.unsafe_get addr 2 |> Char.code in
  let l0 = s0
  and l1 = (s0 lsl 8) lor s1
  and l2 = (s0 lsl 16) lor (s1 lsl 8) lor s2 in
  (* TODO use all 4 levels separately, 4th is the entire addr *)
  l0 + l1 + l2

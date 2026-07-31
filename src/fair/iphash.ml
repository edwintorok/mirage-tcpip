module V46 = struct
  type t =
  { src_range: Counting_bloom.t (* /24 on ipv4 or /48 ipv6 *)
  ; src: Counting_bloom.t
  ; src_with_port: Counting_bloom.t
  ; dst_with_port: Counting_bloom.t
  }
end


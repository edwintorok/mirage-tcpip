open Lwt.Infix
type 'a io = 'a Lwt.t
let return = Lwt.return
let run t = Unix_os.Main.run t ; exit
0

let mirage_runtime_delay__key = Mirage_runtime.register_arg @@
# 32 "lib/devices/runtime_arg.ml"
  Mirage_runtime.delay
;;

let mirage_runtime_network_interface_tap0__key = Mirage_runtime.register_arg @@
# 51 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.interface "tap0"
;;

let mirage_runtime_network_v4_optional_network___key = Mirage_runtime.register_arg @@
# 67 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.V4.optional_network ()
;;

let mirage_runtime_network_v4_gateway_none__key = Mirage_runtime.register_arg @@
# 71 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.V4.gateway None
;;

let mirage_runtime_network_v6_network_none__key = Mirage_runtime.register_arg @@
# 84 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.V6.network None
;;

let mirage_runtime_network_v6_gateway_none__key = Mirage_runtime.register_arg @@
# 88 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.V6.gateway None
;;

let mirage_runtime_network_v6_accept_router_advertisements___key = Mirage_runtime.register_arg @@
# 92 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.V6.accept_router_advertisements ()
;;

let mirage_runtime_network_ipv4_only___key = Mirage_runtime.register_arg @@
# 97 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.ipv4_only ()
;;

let mirage_runtime_network_ipv6_only___key = Mirage_runtime.register_arg @@
# 101 "lib/devices/runtime_arg.ml"
  Mirage_runtime_network.ipv6_only ()
;;

let mirage_runtime_logs__key = Mirage_runtime.register_arg @@
# 203 "lib/devices/runtime_arg.ml"
  Mirage_runtime.logs
;;

let cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true___key = Mirage_runtime.register_arg @@
# 391 "lib/mirage.ml"
  Cmdliner_stdlib.setup ~backtrace:(Some true) ~randomize_hashtables:(Some true) ()
;;

# 63 "mirage/main.ml"

module Ethernet_make__12 = Ethernet.Make(Netif)

# 67 "mirage/main.ml"

module Arp_make__13 = Arp.Make(Ethernet_make__12)

# 71 "mirage/main.ml"

module Dhcp_ipv4_make__14 = Dhcp_ipv4.Make(Netif)(Ethernet_make__12)(Arp_make__13)

# 75 "mirage/main.ml"

module Dhcp_ipv4_proj_net__15 = Dhcp_ipv4.Proj_net(Dhcp_ipv4_make__14)

# 79 "mirage/main.ml"

module Dhcp_ipv4_proj_ipv4__16 = Dhcp_ipv4.Proj_ipv4(Dhcp_ipv4_make__14)

# 83 "mirage/main.ml"

module Ipv6_make__17 = Ipv6.Make(Dhcp_ipv4_proj_net__15)(Ethernet_make__12)

# 87 "mirage/main.ml"

module Tcpip_stack_direct_ipv4v6__18 = Tcpip_stack_direct.IPV4V6(Dhcp_ipv4_proj_ipv4__16)(Ipv6_make__17)

# 91 "mirage/main.ml"

module Icmpv4_make__19 = Icmpv4.Make(Dhcp_ipv4_proj_ipv4__16)

# 95 "mirage/main.ml"

module Udp_make__20 = Udp.Make(Tcpip_stack_direct_ipv4v6__18)

# 99 "mirage/main.ml"

module Tcp_flow_make__21 = Tcp.Flow.Make(Tcpip_stack_direct_ipv4v6__18)

# 103 "mirage/main.ml"

module Tcpip_stack_direct_makev4v6__22 = Tcpip_stack_direct.MakeV4V6(Dhcp_ipv4_proj_net__15)(Ethernet_make__12)(Arp_make__13)(Tcpip_stack_direct_ipv4v6__18)(Icmpv4_make__19)(Udp_make__20)(Tcp_flow_make__21)

# 107 "mirage/main.ml"

module Services_main__23 = Services.Main(Tcpip_stack_direct_makev4v6__22)

let mirage_bootvar__1 = lazy (
# 15 "lib/devices/argv.ml"
  return (Mirage_bootvar.argv ())
);;
# 115 "mirage/main.ml"

let struct_end__2 = lazy (
  let __mirage_bootvar__1 = Lazy.force mirage_bootvar__1 in
  __mirage_bootvar__1 >>= fun _mirage_bootvar__1 ->
# 47 "lib/functoria/job.ml"
  return Mirage_runtime.(with_argv (runtime_args ()) "services" _mirage_bootvar__1)
);;
# 123 "mirage/main.ml"

let cmdliner_stdlib__3 = lazy (
  let _cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true_ = (cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true___key ()) in
  return (_cmdliner_stdlib_setup_backtracesome_true_randomize_hashtablessome_true_)
);;
# 129 "mirage/main.ml"

let mirage_runtime__4 = lazy (
  let _mirage_runtime_delay = (mirage_runtime_delay__key ()) in
# 277 "lib/mirage.ml"
  Mirage_sleep.ns (Duration.of_sec _mirage_runtime_delay)
);;
# 136 "mirage/main.ml"

let mirage_logs__5 = lazy (
  let _mirage_runtime_logs = (mirage_runtime_logs__key ()) in
# 20 "lib/devices/reporter.ml"
  let reporter = Mirage_logs.create () in
  Mirage_runtime.set_level ~default:(Some Logs.Info) _mirage_runtime_logs;
  Logs.set_reporter reporter;
  Lwt.return reporter
);;
# 146 "mirage/main.ml"

let mirage_sleep__6 = lazy (
  return ()
);;
# 151 "mirage/main.ml"

let mirage_ptime__7 = lazy (
  return ()
);;
# 156 "mirage/main.ml"

let mirage_mtime__8 = lazy (
  return ()
);;
# 161 "mirage/main.ml"

let mirage_crypto_rng_mirage__9 = lazy (
# 13 "lib/devices/random.ml"
  Mirage_crypto_rng_mirage.initialize (module Mirage_crypto_rng.Fortuna)
);;
# 167 "mirage/main.ml"

let mirage_runtime__10 = lazy (
# 286 "lib/mirage.ml"
  Mirage_runtime.set_name "services"; Lwt.return_unit
);;
# 173 "mirage/main.ml"

let netif__11 = lazy (
  let _mirage_runtime_network_interface_tap0 = (mirage_runtime_network_interface_tap0__key ()) in
# 26 "lib/devices/network.ml"
  Netif.connect _mirage_runtime_network_interface_tap0
);;
# 180 "mirage/main.ml"

let ethernet_make__12 = lazy (
  let __netif__11 = Lazy.force netif__11 in
  __netif__11 >>= fun _netif__11 ->
# 10 "lib/devices/ethernet.ml"
  Ethernet_make__12.connect _netif__11
);;
# 188 "mirage/main.ml"

let arp_make__13 = lazy (
  let __ethernet_make__12 = Lazy.force ethernet_make__12 in
  __ethernet_make__12 >>= fun _ethernet_make__12 ->
# 12 "lib/devices/arp.ml"
  Arp_make__13.connect _ethernet_make__12
);;
# 196 "mirage/main.ml"

let dhcp_ipv4_make__14 = lazy (
  let __netif__11 = Lazy.force netif__11 in
  let __ethernet_make__12 = Lazy.force ethernet_make__12 in
  let __arp_make__13 = Lazy.force arp_make__13 in
  __netif__11 >>= fun _netif__11 ->
  __ethernet_make__12 >>= fun _ethernet_make__12 ->
  __arp_make__13 >>= fun _arp_make__13 ->
  let _mirage_runtime_network_v4_optional_network_ = (mirage_runtime_network_v4_optional_network___key ()) in
  let _mirage_runtime_network_v4_gateway_none = (mirage_runtime_network_v4_gateway_none__key ()) in
  let _mirage_runtime_network_ipv6_only_ = (mirage_runtime_network_ipv6_only___key ()) in
# 71 "lib/devices/ip.ml"
  let requests = Option.map (List.map Dhcp_wire.int_to_option_code_exn)
              (Some [1; 3]) in
Dhcp_ipv4_make__14.connect ?requests
                          ~no_init:_mirage_runtime_network_ipv6_only_
                          ?cidr:_mirage_runtime_network_v4_optional_network_
                          ?gateway:_mirage_runtime_network_v4_gateway_none
                          _netif__11 _ethernet_make__12 _arp_make__13
);;
# 217 "mirage/main.ml"

let dhcp_ipv4_proj_net__15 = lazy (
  let __dhcp_ipv4_make__14 = Lazy.force dhcp_ipv4_make__14 in
  __dhcp_ipv4_make__14 >>= fun _dhcp_ipv4_make__14 ->
# 98 "lib/devices/ip.ml"
  Dhcp_ipv4_proj_net__15.connect _dhcp_ipv4_make__14
);;
# 225 "mirage/main.ml"

let dhcp_ipv4_proj_ipv4__16 = lazy (
  let __dhcp_ipv4_make__14 = Lazy.force dhcp_ipv4_make__14 in
  __dhcp_ipv4_make__14 >>= fun _dhcp_ipv4_make__14 ->
# 108 "lib/devices/ip.ml"
  Dhcp_ipv4_proj_ipv4__16.connect _dhcp_ipv4_make__14
);;
# 233 "mirage/main.ml"

let ipv6_make__17 = lazy (
  let __dhcp_ipv4_proj_net__15 = Lazy.force dhcp_ipv4_proj_net__15 in
  let __ethernet_make__12 = Lazy.force ethernet_make__12 in
  __dhcp_ipv4_proj_net__15 >>= fun _dhcp_ipv4_proj_net__15 ->
  __ethernet_make__12 >>= fun _ethernet_make__12 ->
  let _mirage_runtime_network_v6_network_none = (mirage_runtime_network_v6_network_none__key ()) in
  let _mirage_runtime_network_v6_gateway_none = (mirage_runtime_network_v6_gateway_none__key ()) in
  let _mirage_runtime_network_v6_accept_router_advertisements_ = (mirage_runtime_network_v6_accept_router_advertisements___key ()) in
  let _mirage_runtime_network_ipv4_only_ = (mirage_runtime_network_ipv4_only___key ()) in
# 154 "lib/devices/ip.ml"
  Ipv6_make__17.connect~no_init:_mirage_runtime_network_ipv4_only_
                     ~handle_ra:_mirage_runtime_network_v6_accept_router_advertisements_
                     ?cidr:_mirage_runtime_network_v6_network_none
                     ?gateway:_mirage_runtime_network_v6_gateway_none
                     _dhcp_ipv4_proj_net__15 _ethernet_make__12
);;
# 251 "mirage/main.ml"

let tcpip_stack_direct_ipv4v6__18 = lazy (
  let __dhcp_ipv4_proj_ipv4__16 = Lazy.force dhcp_ipv4_proj_ipv4__16 in
  let __ipv6_make__17 = Lazy.force ipv6_make__17 in
  __dhcp_ipv4_proj_ipv4__16 >>= fun _dhcp_ipv4_proj_ipv4__16 ->
  __ipv6_make__17 >>= fun _ipv6_make__17 ->
  let _mirage_runtime_network_ipv4_only_ = (mirage_runtime_network_ipv4_only___key ()) in
  let _mirage_runtime_network_ipv6_only_ = (mirage_runtime_network_ipv6_only___key ()) in
# 183 "lib/devices/ip.ml"
  Tcpip_stack_direct_ipv4v6__18.connect
                                     ~ipv4_only:_mirage_runtime_network_ipv4_only_
                                     ~ipv6_only:_mirage_runtime_network_ipv6_only_
                                     _dhcp_ipv4_proj_ipv4__16 _ipv6_make__17
);;
# 266 "mirage/main.ml"

let icmpv4_make__19 = lazy (
  let __dhcp_ipv4_proj_ipv4__16 = Lazy.force dhcp_ipv4_proj_ipv4__16 in
  __dhcp_ipv4_proj_ipv4__16 >>= fun _dhcp_ipv4_proj_ipv4__16 ->
# 12 "lib/devices/icmp.ml"
  Icmpv4_make__19.connect _dhcp_ipv4_proj_ipv4__16
);;
# 274 "mirage/main.ml"

let udp_make__20 = lazy (
  let __tcpip_stack_direct_ipv4v6__18 = Lazy.force tcpip_stack_direct_ipv4v6__18 in
  __tcpip_stack_direct_ipv4v6__18 >>= fun _tcpip_stack_direct_ipv4v6__18 ->
# 14 "lib/devices/udp.ml"
  Udp_make__20.connect _tcpip_stack_direct_ipv4v6__18
);;
# 282 "mirage/main.ml"

let tcp_flow_make__21 = lazy (
  let __tcpip_stack_direct_ipv4v6__18 = Lazy.force tcpip_stack_direct_ipv4v6__18 in
  __tcpip_stack_direct_ipv4v6__18 >>= fun _tcpip_stack_direct_ipv4v6__18 ->
# 14 "lib/devices/tcp.ml"
  Tcp_flow_make__21.connect _tcpip_stack_direct_ipv4v6__18
);;
# 290 "mirage/main.ml"

let tcpip_stack_direct_makev4v6__22 = lazy (
  let __dhcp_ipv4_proj_net__15 = Lazy.force dhcp_ipv4_proj_net__15 in
  let __ethernet_make__12 = Lazy.force ethernet_make__12 in
  let __arp_make__13 = Lazy.force arp_make__13 in
  let __tcpip_stack_direct_ipv4v6__18 = Lazy.force tcpip_stack_direct_ipv4v6__18 in
  let __icmpv4_make__19 = Lazy.force icmpv4_make__19 in
  let __udp_make__20 = Lazy.force udp_make__20 in
  let __tcp_flow_make__21 = Lazy.force tcp_flow_make__21 in
  __dhcp_ipv4_proj_net__15 >>= fun _dhcp_ipv4_proj_net__15 ->
  __ethernet_make__12 >>= fun _ethernet_make__12 ->
  __arp_make__13 >>= fun _arp_make__13 ->
  __tcpip_stack_direct_ipv4v6__18 >>= fun _tcpip_stack_direct_ipv4v6__18 ->
  __icmpv4_make__19 >>= fun _icmpv4_make__19 ->
  __udp_make__20 >>= fun _udp_make__20 ->
  __tcp_flow_make__21 >>= fun _tcp_flow_make__21 ->
# 16 "lib/devices/stack.ml"
  Tcpip_stack_direct_makev4v6__22.connect _dhcp_ipv4_proj_net__15 _ethernet_make__12 _arp_make__13 _tcpip_stack_direct_ipv4v6__18 _icmpv4_make__19 _udp_make__20 _tcp_flow_make__21
);;
# 310 "mirage/main.ml"

let services_main__23 = lazy (
  let __tcpip_stack_direct_makev4v6__22 = Lazy.force tcpip_stack_direct_makev4v6__22 in
  __tcpip_stack_direct_makev4v6__22 >>= fun _tcpip_stack_direct_makev4v6__22 ->
  (Services_main__23.start _tcpip_stack_direct_makev4v6__22 : unit io)
);;
# 317 "mirage/main.ml"

let mirage_runtime__24 = lazy (
  let __struct_end__2 = Lazy.force struct_end__2 in
  let __cmdliner_stdlib__3 = Lazy.force cmdliner_stdlib__3 in
  let __mirage_runtime__4 = Lazy.force mirage_runtime__4 in
  let __mirage_logs__5 = Lazy.force mirage_logs__5 in
  let __mirage_sleep__6 = Lazy.force mirage_sleep__6 in
  let __mirage_ptime__7 = Lazy.force mirage_ptime__7 in
  let __mirage_mtime__8 = Lazy.force mirage_mtime__8 in
  let __mirage_crypto_rng_mirage__9 = Lazy.force mirage_crypto_rng_mirage__9 in
  let __mirage_runtime__10 = Lazy.force mirage_runtime__10 in
  let __services_main__23 = Lazy.force services_main__23 in
  __struct_end__2 >>= fun _struct_end__2 ->
  __cmdliner_stdlib__3 >>= fun _cmdliner_stdlib__3 ->
  __mirage_runtime__4 >>= fun _mirage_runtime__4 ->
  __mirage_logs__5 >>= fun _mirage_logs__5 ->
  __mirage_sleep__6 >>= fun _mirage_sleep__6 ->
  __mirage_ptime__7 >>= fun _mirage_ptime__7 ->
  __mirage_mtime__8 >>= fun _mirage_mtime__8 ->
  __mirage_crypto_rng_mirage__9 >>= fun _mirage_crypto_rng_mirage__9 ->
  __mirage_runtime__10 >>= fun _mirage_runtime__10 ->
  __services_main__23 >>= fun _services_main__23 ->
# 372 "lib/mirage.ml"
  return ()
);;
# 343 "mirage/main.ml"

let () =
  let t = Lazy.force struct_end__2 >>= fun _ ->
  Lazy.force cmdliner_stdlib__3 >>= fun _ ->
  Lazy.force mirage_runtime__4 >>= fun _ ->
  Lazy.force mirage_logs__5 >>= fun _ ->
  Lazy.force mirage_sleep__6 >>= fun _ ->
  Lazy.force mirage_ptime__7 >>= fun _ ->
  Lazy.force mirage_mtime__8 >>= fun _ ->
  Lazy.force mirage_crypto_rng_mirage__9 >>= fun _ ->
  Lazy.force mirage_runtime__10 >>= fun _ ->
  Lazy.force mirage_runtime__24 in
  run t
;;

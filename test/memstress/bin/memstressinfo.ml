open Memstress
open Interface

let print_allocator (module A: Allocator) =
  let t = A.connect () in
  let finally () = A.disconnect t in
  Fun.protect ~finally @@ fun () ->
  let info = A.info t in
  Format.printf "%s: %a@." A.name pp info

let () =
  print_allocator (module GcAllocator);
  print_allocator (module CstructAllocator)

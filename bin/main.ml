module Config = struct
  let sz = 5000
  let nruns = 200
  let indirect_mode = true
end

let () = Printf.printf "OCaml SC Violations\n"

module Barrier = struct
  type t = int Atomic.t array

  let make sz = Array.init sz (fun _ -> Atomic.make 0)

  let reinit t =
    Array.iter (fun c -> Atomic.set c 0) t
      
  let wait t id k =
    if k mod 2 = id then Atomic.set t.(k) 1
    else
      while Atomic.get t.(k) = 0 do
        Domain.cpu_relax ()
      done
end

module Ret = struct
  type t = { r0: int option; r1: int option }
end    

module CodeSegments = struct
  let code0 xf yf =
    xf := 1;
    let r0 = !yf in
    { Ret.r0 = Some r0; r1 = None }

  let code1 xf yf =
    yf := 1;
    let r1 = !xf in
    { Ret.r0 = None; r1 = Some r1 }

  let code0_2plus2W xf yf =
    xf := 2;
    yf := 1;
    { Ret.r0 = None; r1 = None }
  
  let code1_2plus2W xf yf =
    yf := 2;
    xf := 1;
    { Ret.r0 = None; r1 = None }
  
  let code0_LB xf yf =
    let r0 = !xf in
    yf := 1;
    { Ret.r0 = Some r0; r1 = None }
  
  let code1_LB xf yf =
    let r1 = !yf in
    xf := 1;
    { Ret.r0 = None; r1 = Some r1 }
  
  let code0_MP xf yf =
    xf := 1;
    yf := 1;
    { Ret.r0 = None; r1 = None }
  
  let code1_MP xf yf =
    let r0 = !yf in
    let r1 = !xf in
    { Ret.r0 = Some r0; r1 = Some r1 }
  
  let code0_R xf yf =
    xf := 1;
    yf := 1;
    { Ret.r0 = None; r1 = None }
  
  let code1_R xf yf =
    yf := 2;
    let r0 = !xf in
    { Ret.r0 = Some r0; r1 = None }
  
  let code0_S xf yf =
    xf := 2;
    yf := 1;
    { Ret.r0 = None; r1 = None }
  
  let code1_S xf yf =
    let r0 = !yf in
    xf := 1;
    { Ret.r0 = Some r0; r1 = None }
  
  let code0_SB xf yf =
    xf := 1;
    let r0 = !yf in
    { Ret.r0 = Some r0; r1 = None }
  
  let code1_SB xf yf =
    yf := 1;
    let r1 = !xf in
    { Ret.r0 = None; r1 = Some r1 }
end

module Env = struct
  type t = { x: int ref array; y: int ref array;
             barrier: Barrier.t;
             r0: int array; r1: int array;
             x_indirect: int ref array; y_indirect: int ref array }

  let shuffle_array arr =
    let n = Array.length arr in
    for i = n - 1 downto 1 do
      let j = Random.int (i + 1) in
      let tmp = arr.(i) in
      arr.(i) <- arr.(j);
      arr.(j) <- tmp
    done

  let make sz =
    let x = Array.init sz (fun _ -> ref 0)
    and y = Array.init sz (fun _ -> ref 0)
    and r0 = Array.make sz 0
    and r1 = Array.make sz 0    
    and barrier = Barrier.make sz in
    let x_indirect = Array.copy x
    and y_indirect = Array.copy y in
    shuffle_array x_indirect;
    shuffle_array y_indirect;
    { x; y; r0; r1; barrier; x_indirect; y_indirect }

  let reinit env =
    let sz = Array.length env.x in
    for k = 0 to sz - 1 do
      env.x.(k) := 0;
      env.y.(k) := 0;
      env.x_indirect.(k) := 0;
      env.y_indirect.(k) := 0;
    done ;
    Barrier.reinit env.barrier

  let xf env k = if Config.indirect_mode then env.x_indirect.(k) else env.x.(k)
  let yf env k = if Config.indirect_mode then env.y_indirect.(k) else env.y.(k)
end

let env = Env.make Config.sz

let run0 code =
  let open Env in
  let b = env.barrier in
  let sz = Array.length env.barrier in
  for k = 0 to sz - 1 do
    Barrier.wait b 0 k;
    let { Ret.r0; r1 } = code (xf env k) (yf env k) in
    (match r0 with
     | Some v -> env.r0.(k) <- v
     | None -> ());
    (match r1 with
     | Some v -> env.r1.(k) <- v
     | None -> ())
  done;
  (env.r0, env.r1)

let run1 code =
  let open Env in
  let b = env.barrier in
  let sz = Array.length env.barrier in
  for k = 0 to sz - 1 do
    Barrier.wait b 1 k;
    let { Ret.r0; r1 } = code (xf env k) (yf env k) in
    (match r0 with
     | Some v -> env.r0.(k) <- v
     | None -> ());
    (match r1 with
     | Some v -> env.r1.(k) <- v
     | None -> ())
  done;
  (env.r0, env.r1)

module Key = struct
  type t = { r0: int; r1: int }
             
  let compare t1 t2 = match Int.compare t1.r0 t2.r0 with
    | 0 -> Int.compare t1.r1 t2.r1
    | r -> r
        
  let pp chan k =
    Printf.fprintf chan "0:r0=%d; 1:r1=%d;" k.r0 k.r1
end

module type KeySig = sig
  type t

  val compare : t -> t -> int

  val pp : out_channel -> t -> unit
end

module Out (Key : KeySig) = struct
  module KeyMap = Map.Make(Key)

  let empty = KeyMap.empty

  let see m k =
    let old =
      try KeyMap.find k m
      with Not_found -> 0 in
    KeyMap.add k (old + 1) m

  let pp chan m =
    KeyMap.iter (fun k c -> Printf.fprintf chan "%-8d:> %a\n" c Key.pp k) m
end

let run_scenario scenario_name code0 code1 =
  let module Out = Out(Key) in
  let out = ref Out.empty in
  for _ = 0 to Config.nruns - 1 do
    Env.reinit env;
    let p0 = Domain.spawn (fun () -> ignore (run0 code0))
    and p1 = Domain.spawn (fun () -> ignore (run1 code1)) in
    Domain.join p0;
    Domain.join p1;
    for k = 0 to Config.sz - 1 do
      let key = { Key.r0 = env.r0.(k); Key.r1 = env.r1.(k) } in 
      out := Out.see !out key
    done
  done;
  Printf.printf "\nScenario: %s\n" scenario_name;
  Out.pp stdout !out


let () =
  run_scenario "2+2W" CodeSegments.code0_2plus2W CodeSegments.code1_2plus2W;
  run_scenario "LB" CodeSegments.code0_LB CodeSegments.code1_LB;
  run_scenario "MP" CodeSegments.code0_MP CodeSegments.code1_MP;
  run_scenario "R" CodeSegments.code0_R CodeSegments.code1_R;
  run_scenario "S" CodeSegments.code0_S CodeSegments.code1_S;
  run_scenario "SB" CodeSegments.code0_SB CodeSegments.code1_SB

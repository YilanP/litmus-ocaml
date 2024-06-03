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

module CodeSegments = struct
  let code0 x y r0  =
    x := 1;
    r0 := !y;
    ()

  let code1 x y r1 =
    y := 1;
    r1 := !x;
    ()
  let code0_S xf yf =
    xf := 2;
    yf := 1;
    ()
    
  
  let code1_S xf yf r0 =
    r0 := !yf ;
    xf := 1;
    ()  
    
end

module Env = struct
  type t = { 
  x: int ref array; 
  y: int ref array;
  r0: int ref array; 
  r1: int ref array;
  barrier: Barrier.t;
  }

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
    and r0 = Array.init sz (fun _ -> ref 0)
    and r1 = Array.init sz (fun _ -> ref 0)
    and barrier = Barrier.make sz in
    { x; y; r0; r1;barrier }

  let reinit env =
    let sz = Array.length env.x in
    for k = 0 to sz - 1 do
      env.x.(k) := 0;
      env.y.(k) := 0;
      env.r0.(k) := 0;
      env.r1.(k) := 0;
    done ;
    Barrier.reinit env.barrier
end

let env = Env.make Config.sz

let run0 code =
  let open Env in
  let b = env.barrier in
  let sz = Array.length env.barrier in
  for k = 0 to sz - 1 do
    Barrier.wait b 0 k;
    code (env.x.(k)) (env.y.(k))  
    
  done;
  (env.r0, env.r1)

let run1 code =
  let open Env in
  let b = env.barrier in
  let sz = Array.length env.barrier in
  for k = 0 to sz - 1 do
    Barrier.wait b 1 k;
    code (env.x.(k)) (env.y.(k)) (env.r0.(k)) 
  done;

  module Key = struct
    type t = { r0: int; x: int; y: int }  (* Added r2 to the record *)
  
    let compare t1 t2 =
      let c = Int.compare t1.r0 t2.r0 in
      if c <> 0 then c else
        let c = Int.compare t1.x t2.x in
        if c <> 0 then c else
          Int.compare t1.y t2.y
  
    let pp chan k =
      Printf.fprintf chan "0:r0=%d; 1:x=%d; 2:y=%d;" k.r0 k.x k.y  (* Updated to print the third key *)
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
      let key = { Key.r0 = !(env.r0.(k)); Key.x = !(env.x.(k)); Key.y = !(env.y.(k)) } in 
      out := Out.see !out key
    done
  done;
  Printf.printf "\nScenario: %s\n" scenario_name;
  Out.pp stdout !out


let () =
  run_scenario "S" CodeSegments.code0_S CodeSegments.code1_S
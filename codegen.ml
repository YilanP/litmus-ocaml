open Ast
(* Function to extract all memory types used in the code's body *)
let get_memories_in_code (code : code) =
  let (_, _, body, _) = code in
  List.fold_left (fun acc b_content -> match b_content with
    | MemAssign (mem, _) -> mem :: acc
    | MemAtomicAssign (mem, _) -> mem :: acc
    | RegRead (_, mem) -> mem :: acc
    | RegAtomicRead (_, mem) -> mem :: acc
    | _ -> acc) [] body
  |> List.sort_uniq compare
  let get_all_memories_in_codes codes =
    codes
    |> List.map get_memories_in_code  (* Apply 'get_memories_in_code' to each code *)
    |> List.concat                   (* Flatten the list of lists into a single list *)
    |> List.sort_uniq compare        (* Remove duplicates and sort the results *)
(* Function to get module and register pairs from the code's returns *)
let get_module_and_register_in_code (code : code) =
  let (_, _, _, returns) = code in
  List.map (fun (modul, reg) -> (modul, reg)) returns

let convert_module_register_to_string (modul, reg) = Printf.sprintf "r%d_%d" modul reg

let combine_proc_reg_tostring (proc,reg) =
  Printf.sprintf "r%d_%d" proc reg


(* Function to get module and register pairs as formatted strings *)
let get_module_and_register_in_code_string (code : code) =
  let (_, _, _, returns) = code in
  List.map (fun (modul, reg) -> Printf.sprintf "r%d_%d" modul reg) returns

  let get_all_module_and_registers codes =
    codes
    |> List.map get_module_and_register_in_code  (* Apply 'get_module_and_register_in_code' to each code *)
    |> List.concat
    
    let rec extract_memories cond =
      let rec aux acc = function
        | Predicate (PredMem (mem, _)) -> mem :: acc
        | And (c1, c2) | Or (c1, c2) ->
            let acc = aux acc c1 in
            aux acc c2
        | _ -> acc
      in
      aux [] cond
      
      let rec extract_registers cond =
        let rec aux acc = function
          | Predicate (PredReg (reg, _)) -> reg :: acc
          | And (c1, c2) | Or (c1, c2) ->
              let acc = aux acc c1 in
              aux acc c2
          | _ -> acc
        in
        aux [] cond
      
  let generate_code program output_name=

  let replace_mem_type memAny =
    let memList = get_all_memories_in_codes program.codes in
    let find_replacement =
      let rec find_match = function
        | [] -> memAny (* No match found, return MemAny as is *)
        | MemRef(name) as memRef :: _ when name = (match memAny with MemAny(name) -> name | _ -> "") -> memRef
        | MemAtomic(name) as memAtomic :: _ when name = (match memAny with MemAny(name) -> name | _ -> "") -> memAtomic
        | _ :: rest -> find_match rest
      in
      find_match memList
    in
    find_replacement
  in

    let output_file = open_out output_name in 
    let memory_to_string mem =
      match mem with
      | MemAny s -> s
      | MemRef s -> s
      | MemAtomic s -> s
    in
    let processors_info = 
      List.map (fun (processor, params, body_list, returns) ->
        let body_str = List.fold_right (fun body_content acc ->
          match body_content with
          | Ast.MemAssign (mem, value) -> 
              Printf.sprintf "\t\t%s := %d; \n" (memory_to_string mem) value ^ acc
          | Ast.RegRead (reg, mem) -> 
              Printf.sprintf "\t\tR%d := !%s;\n" reg (memory_to_string mem) ^ acc
          | Ast.MemAtomicAssign (mem, value) -> 
              Printf.sprintf "\t\tatomic { %s := %d; }\n" (memory_to_string mem) value ^ acc
          | Ast.RegAtomicRead (reg, mem) -> 
              Printf.sprintf "\t\tatomic { R%d := !%s; }\n" reg (memory_to_string mem) ^ acc
        ) body_list "" in
        let return_str = List.fold_right (fun (return_module, reg) acc ->
          Printf.sprintf "\t\t{ Ret%d.r%d }\n" return_module reg ^ acc
        ) returns "" in
        (processor, params, body_str, return_str)
      ) program.codes
    
    in    
    (*DESTROYED COMBINE_PROCESSOR_PARAMS*)
      let config_write = 
      "module Config = struct\n\
       \tlet sz = 5000\n\
       \tlet nruns = 200\n\
       \tlet indirect_mode = true\n\
       end\n"
    in
    let main_write = "let () =   run_scenario \""^program.testname^"\" ;
  check_exists env" in
    let barrier_write = 
      "module Barrier = struct\n\
       \ttype t = int Atomic.t array\n\
       \n\
       \tlet make sz = Array.init sz (fun _ -> Atomic.make 0)\n\
       \n\
       \tlet reinit t =\n\
       \t\tArray.iter (fun c -> Atomic.set c 0) t\n\
       \n\
       \tlet wait t id k =\n\
       \t\tif k mod 2 = id then Atomic.set t.(k) 1\n\
       \t\telse\n\
       \t\t\twhile Atomic.get t.(k) = 0 do\n\
       \t\t\t\tDomain.cpu_relax ()\n\
       \t\t\tdone\n\
       end\n"
    in
    let return_modules_write =
      let return_modules = List.fold_right (fun (_, _, _, returns) acc ->
        List.fold_right (fun (return_module, _) acc ->
          let module_def = Printf.sprintf "module Ret%d = struct\n\ttype t = { r%d:int; }\nend\n\n" return_module return_module in
          acc ^ module_def
        ) returns acc
      ) program.codes "" in
      return_modules
    in
    
    let code_segment_write (codes : Ast.code list) =
      let head = "module CodeSegments = struct\n" in
      let tail = "end\n" in
    
      let rec write_code codes =
        match codes with
        | [] -> ""
        | (processor, parameters, body, returns) :: rest ->
          let code_name = "code" ^ string_of_int processor in
          let params_make = List.fold_left (fun acc x -> acc ^ x ^ " ") "" parameters in
          let rec write_body body =
            match body with
            | [] -> ""
            | MemAssign (mem, value) :: rest ->
              Printf.sprintf "\t\t%s := %d;\n" (memory_to_string mem) value ^ write_body rest
            | RegRead (reg, mem) :: rest ->
              Printf.sprintf "\t\tlet r%d = !%s in\n" reg (memory_to_string mem) ^ write_body rest
            | MemAtomicAssign (mem, value) :: rest ->
              Printf.sprintf "\t\tAtomic.set %s %d;\n" (memory_to_string mem) value ^ write_body rest
            | RegAtomicRead (reg, mem) :: rest ->
              Printf.sprintf "\t\tlet r%d = Atomic.get %s in\n" reg (memory_to_string mem) ^ write_body rest
          in
          let rec write_returns returns =
            match returns with
            | [] -> ""
            | (return_module, reg) :: rest ->
              Printf.sprintf "\t\t{ Ret%d.r%d = r%d; }\n" return_module reg reg ^ write_returns rest
          in
          Printf.sprintf "let %s %s = \n%s%s\n" code_name params_make (write_body body) (write_returns returns) ^ write_code rest
      in
      head ^ write_code codes ^ tail
    
    in

  let environment_write = 
      let memories_type_write = "{" ^ 
        (List.fold_left (fun acc x -> acc ^ (match x with
          | MemAtomic s -> s ^":"^ "int Atomic.t array;\n" 
          | MemRef s ->  s ^":"^ "int ref array;\n" 
          | _ -> "")) "" (get_all_memories_in_codes program.codes))
        in
      let regname_type_write = List.fold_left (fun acc x-> (acc ^ convert_module_register_to_string x) ^":int array;\n" ) "" (get_all_module_and_registers program.codes)  
        in 


      let head = "module Env = struct\ntype t = \n" in
      let tail = "end\nlet env = Env.make Config.sz\n" in


    let barrier_write = "barrier: Barrier.t;\n}\n" in 
    let make_write =
      let head ="let make sz =\n" in
      let barrier_write_arr_init = "let barrier = Barrier.make sz in\n" in
      
      let memories_make_write =
        (List.fold_left (fun acc x -> acc ^ (match x with
          | MemAtomic s -> "let " ^ s ^ " = Array.init sz (fun _ -> Atomic.make 0) in\n"
          | MemRef s -> "let " ^ s ^ " = Array.init sz (fun _ -> ref 0) in\n"
          | _ -> "")) "" (get_all_memories_in_codes program.codes))
        in
        let regname_make_write = List.fold_left (fun acc x-> (acc ^"let "^ convert_module_register_to_string x) ^ "= Array.make sz 0 in\n" ) "" (get_all_module_and_registers program.codes)  
      in 

      
      let return_make_write = 
        let memories = 
        (List.fold_left (fun acc x -> acc ^ (match x with
          | MemAtomic s -> s ^";"
          | MemRef s -> s^";"
          | _ -> "")) "" (get_all_memories_in_codes program.codes))
        in
        let regname = List.fold_left (fun acc x-> (acc ^ convert_module_register_to_string x) ^ ";" ) "" (get_all_module_and_registers program.codes)  
        in 
        "{" ^ memories ^ regname ^ "barrier; }\n"
      in
      head ^ memories_make_write ^ regname_make_write ^ barrier_write_arr_init ^ return_make_write
      in
      let reinit_write =
        let memories_reinit_write = 
        (List.fold_left (fun acc x -> acc ^ (match x with
          | MemAtomic s -> "Atomic.set env." ^ s ^ ".(k) 0;\n"
          | MemRef s -> "env." ^ s ^ ".(k) := 0;\n"
          | _ -> "")) "" (get_all_memories_in_codes program.codes))
        in
        let regname_reinit_write = List.fold_left (fun acc x-> (acc ^"env." ^ convert_module_register_to_string x) ^ ".(k) <- 0;\n" ) "" (get_all_module_and_registers program.codes)  
        in
        let head = "let reinit env =\nfor k = 0 to Config.sz - 1 do\n" in
        let tail = "done ;\nBarrier.reinit env.barrier\n" in
        head ^ memories_reinit_write ^ regname_reinit_write ^ tail
      in
      head ^ memories_type_write ^ regname_type_write ^  barrier_write^ make_write  ^reinit_write^ tail 
    in


    let runs_write =
      let rec processor_run_string list processor_no = 
        match list with
        | [] -> ""
        | (processor, parameters, body, returns) as code :: rest ->
          let processor_run = Printf.sprintf "let run%d env =\nlet open Env in\nlet b = env.barrier in\n" processor in
          let processor_run_vars = List.fold_left (fun acc x -> acc ^ "let " ^ memory_to_string x ^ " = env." ^ memory_to_string x ^ " in\n") "" (get_memories_in_code code) in
          let run_regs = List.fold_left (fun acc x -> acc ^ "let " ^ convert_module_register_to_string x ^ " = env." ^ convert_module_register_to_string x ^ " in\n") "" (get_module_and_register_in_code code) in
          let mid_text = "for k = 0 to Config.sz - 1 do\n  Barrier.wait b " ^ string_of_int processor_no ^ " k;\n" in
          let rec processor_returns rets =
            match rets with
            | [] -> ""
            | (return_module, reg) :: rest -> "Ret" ^ string_of_int return_module ^ ".r" ^ string_of_int reg ^ " = r" ^ string_of_int reg ^ ";\n" ^ processor_returns rest
          in
          let rec code_segment_part params =
            match params with
            | [] -> "in\n"
            | param :: rest -> " " ^ param ^ ".(k)" ^ code_segment_part rest
          in
          let code_segment_2 = List.fold_left (fun acc (proc, reg) -> acc ^combine_proc_reg_tostring (proc, reg) ^ ".(k) <- " ^ "r"^ string_of_int reg ^ ";\n") "" (get_module_and_register_in_code code) in
          let end_seg = "done;\n()\n" in
          processor_run ^ processor_run_vars ^ run_regs ^ mid_text ^ 
          "\nlet{ "^processor_returns returns^"} = CodeSegments.code"^string_of_int processor ^
          " "^code_segment_part parameters ^ code_segment_2 ^ end_seg ^ processor_run_string rest (processor_no + 1)
      in
      processor_run_string program.codes 0
    

    in
    let key_module_write =
      let head = "module Key = struct
      type t =" in

      let memories = extract_memories program.condition in
      let registers = extract_registers program.condition in
        
      let t_types_write = 
        
        let get_memories_strings =
          List.fold_left (fun acc x -> acc ^ (match x with
            | MemAny s -> s ^ ":int ;\n"
            | _ -> "")) "" memories
          in
        let get_registers_strigns = List.fold_left (fun acc x -> acc ^ convert_module_register_to_string x ^ ": int;\n") "" registers
        in
        get_memories_strings ^ get_registers_strigns
        in
        
      let compare_write=
            let get_memory_names_list  =
          List.fold_left (fun acc x -> match x with
            | MemAny s -> s :: acc
            | _ -> acc) [] memories
          |> List.rev
        in
        let get_registers_names_list  =
          List.fold_left (fun acc x -> (convert_module_register_to_string x ) :: acc) [] registers
          |> List.rev
        in
        let compare_write_head = "let compare t1 t2 =\n\t" in
        let rec compare_write_body list proc_no = match list with
          | [] -> failwith "Empty list not expected" (* Adjusted to handle unexpected empty list *)
          | [str] -> Printf.sprintf "Int.compare t1.%s t2.%s" str str
          | str :: rest -> 
              Printf.sprintf "match Int.compare t1.%s t2.%s with\n\t| 0 -> (\n\t%s\n\t)\n\t| r -> r\n" str str (compare_write_body rest (proc_no+1))
        in
        compare_write_head ^ compare_write_body (get_memory_names_list @ get_registers_names_list) 0 
      in
      let pp_write_head = "let pp chan k =\nPrintf.fprintf chan " in
      let pp_write_body =
      
        let pp_write_regs = List.fold_left (fun acc (proc,reg) -> acc ^ string_of_int proc ^ ":r"^string_of_int reg^"=%d; " )"" registers in
        let pp_write_mems = List.fold_left (fun acc mem -> acc ^ memory_to_string mem ^ "=%d; ") "" memories in
        let pp_write_regs2 = List.fold_left (fun acc (proc,reg) -> acc ^"k.r"^ string_of_int proc ^ "_"^string_of_int reg^" " )"" registers in
        let pp_write_mems2 = List.fold_left (fun acc mem -> acc ^"k."^ memory_to_string mem ^ " ") "" memories in

        "\""^pp_write_regs ^ pp_write_mems^ "\"" ^ pp_write_regs2 ^ pp_write_mems2 ^"\n"
      in
      let tail = "\nend\n" in
      head ^"{"^t_types_write ^"}"^compare_write^ pp_write_head ^ pp_write_body ^ tail
    in
    let key_sig_write = "    module type Key = sig
      type t
    
      val compare : t -> t -> int
    
      val pp : out_channel -> t -> unit
    end\n"
  in
   let out_module_write = "    
    module Out(Key:Key) = struct
    
      module KeyMap = Map.Make(Key)
    
      let empty = KeyMap.empty
    
      let see m k =
        let old =
          try KeyMap.find k m
          with Not_found -> 0 in
        KeyMap.add k (old+1) m
    
      let pp chan m =
        KeyMap.iter
          (fun k c -> Printf.fprintf chan \"%-8d:> %a\n\" c Key.pp k)
          m      
    end\n" in
    let check_exists_write =
      let memories = extract_memories program.condition in
      let registers = extract_registers program.condition in
      let head = "let check_exists env=
  let open Env in
  let found = ref false in
  for i = 0 to Config.sz - 1 do
    if " in
      let replace_mem_types memList anyList =
        let find_replacement memAny =
          let rec find_match = function
            | [] -> memAny (* No match found, return MemAny as is *)
            | MemRef(name) as memRef :: _ when name = match memAny with MemAny(name) -> name | _ -> "" -> memRef
            | MemAtomic(name) as memAtomic :: _ when name = match memAny with MemAny(name) -> name | _ -> "" -> memAtomic
            | _ :: rest -> find_match rest
          in
          find_match memList
        in
        List.map find_replacement anyList
      in
      


      let condition_write  =
        let rec aux = function
          | Predicate (PredMem (mem, value)) ->
            (match replace_mem_type mem with
             | MemRef _ -> Printf.sprintf "env.%s.(i) = %d " (memory_to_string mem) value
             | MemAtomic _ -> Printf.sprintf "Atomic.get (env.%s.(i)) = %d" (memory_to_string mem) value
             | _ -> Printf.sprintf "env.%s.(i) = %d && " (memory_to_string mem) value) (* Fallback for MemAny or other types *)
          | Predicate (PredReg ((modul, reg), value)) ->
            Printf.sprintf "env.%s.(i) = %d" (combine_proc_reg_tostring (modul, reg)) value
          | And (c1, c2) -> aux c1 ^ "&& " ^ aux c2
          | Or (c1, c2) -> aux c1 ^ "|| " ^ aux c2
        in
        aux program.condition 
      in
      head ^ condition_write ^ " then\n      found := true\n  done;\n  if !found then\n    Printf.printf \"OK\\n\"\n  else\n    Printf.printf \"No\\n\"\n"
    in

    let run_scenario_write = 
      let head = "let run_scenario scenario_name  =
  let module Out = Out(Key) in
  let out = ref Out.empty in
  for _ = 0 to Config.nruns - 1 do
    Env.reinit env;\n"
  in
    let domains_write = 
      let spawns = List.fold_right (fun (processor, _, _, _) acc ->
        Printf.sprintf "    let p%d = Domain.spawn (fun () -> ignore (run%d env)) in \n" processor processor ^ acc
      ) program.codes "" in
      let joins = List.fold_right (fun (processor, _, _, _) acc ->
        Printf.sprintf "    Domain.join p%d;\n" processor ^ acc
      ) program.codes "" in 
      spawns ^ joins;
    in
    let loop_write =
      let head = "for k = 0 to Config.sz - 1 do
      let key = "in
      let keys_of_loop =
        let memories = extract_memories program.condition in
        let registers = extract_registers program.condition in
        let memories_str = List.fold_left (fun acc x -> acc ^"Key."^ memory_to_string x ^ " = "^ (match (replace_mem_type x) with
        |MemRef s -> "env."^s
        |MemAtomic s -> "Atomic.get env."^s
        |MemAny s -> "ERROR"
        ) ^ ".(k); ") "" memories in
        let registers_str = List.fold_left (fun acc x -> acc ^"Key."^ convert_module_register_to_string x ^ " = env." ^ convert_module_register_to_string x ^ ".(k); ") "" registers in
        Printf.sprintf "{ %s%s}" memories_str registers_str in
      let tail = " in\n    out := Out.see !out key\n  done\n  done;\n  Printf.printf \"\\nScenario: %s\\n\" scenario_name;\n  Out.pp stdout !out\n" in
      head ^ keys_of_loop ^ tail
      in
    head^domains_write ^ loop_write
    in



    

        
      
let final_out = config_write ^ barrier_write ^return_modules_write^ (code_segment_write program.codes) 
^ environment_write ^ runs_write ^key_module_write^ key_sig_write^out_module_write^
check_exists_write^run_scenario_write^ main_write 
in 
  Printf.fprintf output_file "%s" final_out;  (* Include "%s" format specifier for clarity *)
  close_out output_file;
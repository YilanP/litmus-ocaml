open Ast
let get_params body_list =
  let rec extract_params acc = function
    | [] -> acc
    | Ast.MemAssign(mem, _) :: tl -> extract_params (mem :: acc) tl
    | Ast.RegRead(reg, mem) :: tl -> extract_params (mem :: reg :: acc) tl
  in
  extract_params [] body_list |> List.sort_uniq String.compare (*|> List.map (fun p -> p ^ " ")*)
  |> String.concat " "
let get_combined_params processors_info =
  let combine_params acc (processor, _, body_list) =
    let regs, mems = List.fold_left (fun (r, m) body_content ->
      match body_content with
      | Ast.MemAssign(mem, _) -> (r, mem :: m)
      | Ast.RegRead(reg, mem) -> ((processor ^ "_" ^ reg) :: r, mem :: m)
    ) ([], []) body_list in
    let unique_regs = List.sort_uniq String.compare regs in
    let unique_mems = List.sort_uniq String.compare mems in
    List.append unique_regs unique_mems @ acc
  in
  List.fold_left combine_params [] processors_info |> List.sort_uniq String.compare |> String.concat ", "

  let generate_code program output_name=
    let output_file = open_out output_name in  (* Open the file for writing *)
    
    (* Extract and format processor parameters and bodies at a higher level *)
    let processors_info = 
      List.map (fun (processor, body_list) ->
        let params = get_params body_list in
        let body_str = List.fold_right (fun body_content acc ->
          match body_content with
          | Ast.MemAssign (mem, value) -> Printf.sprintf "\t\t%s := %d; \n" mem value ^ acc
          | Ast.RegRead (reg, mem) -> Printf.sprintf "\t\t%s := !%s;\n" reg mem ^ acc
        ) body_list "" in
        (processor, params, body_str)
      ) program.codes
    in
    
    (*DESTROYED COMBINE_PROCESSOR_PARAMS*)
    let combine_processor_params processors_info =
      let combined_params = List.fold_left (fun acc (processor, params, _) ->
        let params_list = List.map (fun param -> 
          if String.get param 0 = 'r' then (*processor ^ "_" ^* DECOMMENT TO FIX*) param else param
        ) (String.split_on_char ' ' params) in
        acc @ params_list
      ) [] processors_info in
      List.sort_uniq compare combined_params
        in
        let processor_params_to_init = combine_processor_params processors_info in
      let config_write = 
      "module Config = struct\n\
       \tlet sz = 5000\n\
       \tlet nruns = 200\n\
       \tlet indirect_mode = true\n\
       end\n"
    in
    let main_write = "let () = Printf.printf \"OCaml SC Violations\\n\"\n" in
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
    let code_segment_write =
      let head = "module CodeSegments = struct\n" in
      let tail = "end\n" in
      let write_codes_list =
        List.fold_right (fun (processor, params, body_str) acc ->
          let processor_write = Printf.sprintf "\tlet %s %s = \n" processor params in
          processor_write ^ body_str ^ "\t()\n" ^ acc
        ) processors_info ""
      in
      head ^ write_codes_list ^ tail
    in
    let print_processors_info processors_info =
      List.iter (fun (processor, params, body_str) ->
        Printf.printf "Processor: %s\n" processor;
        Printf.printf "Parameters: %s\n" params;
        Printf.printf "Body:\n%s\n" body_str;
      ) processors_info
    in
    (*processor_params_to_init COMBINES PROCESSOR NAME + REGISTER NAME IMPLEMENT BETTER LATER*)
    let extract_unique_params processors_info =
      let all_params = List.fold_left (fun acc (_, params, _) ->
        acc @ (String.split_on_char ' ' params)
      ) [] processors_info in
      List.sort_uniq compare all_params
    in
    let environment_write = 
      let head = "module Env = struct\ntype t = {\n" in
      let tail = "end\n" in
      let write_environment_array_list = String.concat ""(List.map (fun str -> str ^ ":" ^ "int ref array;\n" ) processor_params_to_init )in
    let barrier_write = "barrier: Barrier.t;\n}\n" in 
    let make_write =
      let head ="let make sz =\n" in
      let barrier_write_arr_init = "and barrier = Barrier.make sz in\n" in
      let return_make_write = "{ " ^ String.concat ""(List.map (fun str -> str ^ "; " ) processor_params_to_init ) ^ "barrier }\n" in
      match processor_params_to_init with
      | [] -> ""
      | first :: rest ->
        let first_str = "let " ^ first ^ " = " ^ "Array.init sz (fun _ -> ref 0)\n" in
        let rest_str = String.concat "" (List.map (fun str -> "and " ^ str ^ " = " ^ "Array.init sz (fun _ -> ref 0)\n") rest) in

        head ^ first_str ^ rest_str ^ barrier_write_arr_init ^ return_make_write
      in
    let reinit_write = 
      let head = "let reinit env =\nfor k = 0 to Config.sz - 1 do\n" in
      let tail = "done ;\nBarrier.reinit env.barrier\n" in
      let write_reinit_list = String.concat ""(List.map (fun str -> "env." ^ str ^ ".(k) := 0;\n" ) processor_params_to_init )in
      head ^ write_reinit_list ^ tail
    in
    head ^ write_environment_array_list ^ barrier_write ^ make_write ^ reinit_write ^ tail
    in

    let runs_write =
      let head = "let env = Env.make Config.sz\n" in
      let rec write_params i = function
        | [] -> ""
        | (processor, params, _) :: rest ->
          let params_str = String.concat " " (List.map (fun param -> 
            if String.get param 0 = 'r' then "(env." ^ param ^ ".(k))"
            else "(env." ^ param ^ ".(k))") (String.split_on_char ' ' params)) in
          let run_str = "let run" ^ processor ^ " code =\nlet open Env in
            let b = env.barrier in
            let sz = Array.length env.barrier in
            for k = 0 to sz - 1 do
            Barrier.wait b "^ string_of_int i ^ " k;\n
            code " ^ params_str ^
            "\ndone;\n()\n" in
            run_str ^ (write_params (i + 1) rest)
          in
      let run_gen_write = write_params 0 processors_info in
    head ^ run_gen_write
    in
    let key_write =
      let rec write_fields = function
        | [] -> ""
        | param :: rest -> param ^ ": int; " ^ write_fields rest
      in
      let rec write_compare = function
        | [] -> "0"
        | param :: rest ->
          "let c = Int.compare t1." ^ param ^ " t2." ^ param ^ " in\n" ^
          "if c <> 0 then c else\n" ^ write_compare rest
      in
      let rec write_pp i = function
        | [] -> ""
        | param :: rest ->
          let prefix = if String.get param 0 = 'r' then string_of_int i ^ ":" else "" in
          prefix ^ param ^ "=%d; " ^ write_pp (i + 1) rest
      in
      let unique_params = extract_unique_params processors_info in

      "module Key = struct\n" ^
      "type t = { " ^ write_fields unique_params ^ "}\n\n" ^
      "let compare t1 t2 =\n" ^ write_compare unique_params ^ "\n\n" ^
      "let pp chan k =\n" ^
      "Printf.fprintf chan \"" ^ write_pp 0 unique_params ^"\""^ (String.concat " " (List.map (fun param -> "k." ^ param) unique_params)) ^"\n" ^
      "end\n"
    in
    let key_sig_out_write = "
    
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
    KeyMap.iter (fun k c -> Printf.fprintf chan \"%-8d:> %a\\n\" c Key.pp k) m
end
"
in
let scenario_write =
  (* Function to extract unique parameters as a list from parameters string *)
  
  let unique_params = extract_unique_params processors_info in

  (* Beginning of the function *)
  let head = Printf.sprintf "let run_scenario scenario_name %s =\n" (List.map (fun (processor, _, _) ->
    Printf.sprintf "code%s" processor
  ) processors_info |> String.concat " ") in
  let module_setup = "  let module Out = Out(Key) in\n" in
  let out_declaration = "  let out = ref Out.empty in\n" in
  let loop_start = Printf.sprintf "  for _ = 0 to  Config.nruns - 1 do\n" in
  let env_reset = "    Env.reinit env;\n" in

  let processor_executions = List.map (fun (processor, _, _) ->
    Printf.sprintf "    let p%s = Domain.spawn (fun () -> ignore (run%s code%s)) in\n" processor processor processor
  ) processors_info |> String.concat "" in

  let joins = List.map (fun (processor, _, _) ->
    Printf.sprintf "    Domain.join p%s;\n" processor
  ) processors_info |> String.concat "" in

  let key_computation_start = "    for k = 0 to Config.sz - 1 do\n      let key = { " in
  let key_fields = List.map (fun param ->
    Printf.sprintf "Key.%s = !(env.%s.(k)); " param param
  ) unique_params |> String.concat "" in
  let key_computation_end = "} in\n      out := Out.see !out key\n    done\n" in

  let loop_end = "  done;\n" in
  let print_results = "  Printf.printf \"\\nScenario: %s\\n\" scenario_name;\n" in
  let output_print = "  Out.pp stdout !out\n" in

  let full_function = head ^
                      module_setup ^
                      out_declaration ^
                      loop_start ^
                      env_reset ^
                      processor_executions ^
                      joins ^
                      key_computation_start ^
                      key_fields ^
                      key_computation_end ^
                      loop_end ^
                      print_results ^
                      output_print in
  full_function
  in    
  let start_main_write =
    "let () =\n" ^
    "  run_scenario "^"\"" ^ program.testname ^ "\"" ^
    (List.fold_right
      (fun (processor, _, _) acc -> "CodeSegments." ^ processor ^ " " ^acc)
      processors_info
      "") ^
    "\n"
  in
    Printf.fprintf output_file "%s%s%s%s%s%s%s%s%s%s" 
    config_write main_write barrier_write code_segment_write environment_write
    runs_write key_write key_sig_out_write scenario_write start_main_write;
    
    (*print_processors_info processors_info;*)
    close_out output_file 
  
  
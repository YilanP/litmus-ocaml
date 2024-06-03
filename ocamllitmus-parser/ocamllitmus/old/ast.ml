type number = int
type memory = string * number option
type register = int
type predicate = 
  | PredReg of register * number
  | PredMem of memory * number
type logicsymb = And | Or
type condition = predicate list * logicsymb list
type codes = string
type cycle = string
type init = (memory * number) list
type arch = string
type testname = string
type s = 
  { arch : arch;
    testname : testname;
    init : init;
    cycle : cycle;
    codes : codes;
    condition : condition }


let to_string s =
  let string_of_number n =
    string_of_int n
  in
  let string_of_memory (str, opt_num) =
    Printf.sprintf "(%s, %s)" str (
      match opt_num with
      | None -> "None"
      | Some num -> "Some " ^ string_of_number num
    )
  in
  let string_of_predicate pred =
    match pred with
    | PredReg (reg, num) ->
      Printf.sprintf "PredReg (%d, %d)" reg num
    | PredMem (mem, num) ->
      Printf.sprintf "PredMem (%s, %d)" (string_of_memory mem) num
  in
  let string_of_logicsymb ls =
    match ls with
    | And -> "And"
    | Or -> "Or"
  in
  let string_of_condition (preds, ls) =
    let preds_str = String.concat ", " (List.map string_of_predicate preds) in
    let ls_str = String.concat ", " (List.map string_of_logicsymb ls) in
    Printf.sprintf "(%s, [%s])" preds_str ls_str
  in
  let string_of_code (id, bod) =
    Printf.sprintf "(%d, %s)" id bod
  in
  let string_of_init init =
    String.concat ", " (List.map (fun (mem, num) -> Printf.sprintf "%s %d" (string_of_memory mem) num) init)
  in
  Printf.sprintf "{ arch = %s; testname = %s; init = [%s]; cycle = %s; codes = [%s]; condition = %s }"
    s.arch
    s.testname
    (string_of_init s.init)
    s.cycle
    (s.codes)
    (string_of_condition s.condition)

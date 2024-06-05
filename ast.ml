type number = int
type processor = string

type memory = string
type register = string
type predicate = 
  | PredReg of register * number
  | PredMem of memory * number
type logicsymb = And | Or
type condition = predicate list * logicsymb list
type ocaml_code = string

type body_content = 
| MemAssign of (memory * number)
| RegRead of (register * memory)

type body = body_content list

type code = processor * body
type codes = code list
type cycle = string
type init = (memory * number) list
type arch = 
  | X86
  | X86_64

type testname = string
type s = 
  { arch : arch;
    testname : testname;
    cycle : cycle;
    init : init;
    codes : codes;
    condition : condition }


    let string_of_arch = function
    | X86 -> "X86"
    | X86_64 -> "X86_64"
  
  let string_of_predicate = function
    | PredReg (reg, num) -> Printf.sprintf "PredReg(%s, %d)" reg num
    | PredMem (mem, num) -> Printf.sprintf "PredMem(%s, %d)" mem num
  
  let string_of_logicsymb = function
    | And -> "And"
    | Or -> "Or"
  
  let string_of_condition (preds, logs) =
    let preds_str = String.concat ", " (List.map string_of_predicate preds) in
    let logs_str = String.concat ", " (List.map string_of_logicsymb logs) in
    Printf.sprintf "(%s, [%s])" preds_str logs_str
  
  let string_of_init init_list =
    let item_to_string (mem, num) = Printf.sprintf "(%s, %d)" mem num in
    String.concat ", " (List.map item_to_string init_list)
  
  let string_of_body_content = function
    | MemAssign (mem, num) -> Printf.sprintf "MemAssign(%s, %d)" mem num
    | RegRead (reg, mem) -> Printf.sprintf "RegRead(%s, %s)" reg mem
  
  let string_of_body body =
    String.concat ", " (List.map string_of_body_content body)
  
  let string_of_code (proc, body) =
    Printf.sprintf "(%s, [%s])" proc (string_of_body body)
  
  let string_of_codes codes =
    String.concat ", " (List.map string_of_code codes)
  
  let to_string s =
    Printf.sprintf "{arch = %s; testname = %s; cycle = %s; init = [%s]; codes = [%s]; condition = %s}"
      (string_of_arch s.arch)
      s.testname
      s.cycle
      (string_of_init s.init)
      (string_of_codes s.codes)
      (string_of_condition s.condition)
  
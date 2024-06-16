type number = int
type processor = int

type memory = 
  | MemAny of string
  | MemRef of string
  | MemAtomic of string
type register = int
type return_module = int

type predicate = 
  | PredReg of (return_module * register)* number
  | PredMem of memory * number

type logical_op =
  | And of condition * condition
  | Or of condition * condition
  | Predicate of predicate

and condition = logical_op

type ocaml_code = string
type body_content = 
| MemAssign of (memory * number)
| RegRead of (register * memory)
| MemAtomicAssign of (memory * number)
| RegAtomicRead of (register * memory)

type body = body_content list

type returns = ((return_module * register)list)

type parameters = string list

type code = processor * parameters * body * returns
type codes = code list
type cycle = string
type init = (memory * number) list
type arch = 
  | ArchOcaml

type testname = string
type s = 
  { arch : arch;
    testname : testname;
    cycle : cycle option;
    init : init;
    codes : codes;
    condition : condition }


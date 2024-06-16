%{
open Ast
%}

%token <string>  STRING
%token <int> NUMBER
%token <int> REGISTER
%token <int> RETURN_MODULE
%token <int> PROCESSOR
%token SPACE LBRACE RBRACE SEMICOLON COLON R RET IN PERIOD DEREFERENCE QUOTE LET ASSIGN EQUAL EXISTS LPAREN RPAREN AND OR EOF ATOMIC_SET ATOMIC_GET
%token ARCH_Ocaml
%right AND OR
%type <Ast.s> main
%start main

%%

main:
| arch = Arch testname = Testname cycle = Cycle? init = Init codes = Code_Block condition = Condition EOF
    { 
      { arch = arch; testname = testname; cycle = cycle; init = init; codes = codes; condition = condition }
    }

Arch:
| ARCH_Ocaml { ArchOcaml}

Testname:
| STRING  { $1 }


Cycle:
| QUOTE STRING QUOTE { $2 }

Init:
| LBRACE init_contents RBRACE { $2 }

init_contents:
| { [] }
| init_item { [$1] }
| init_item SEMICOLON init_contents { $1 :: $3 }

init_item:
| STRING EQUAL NUMBER { (MemAny $1, $3) }


Code_Block:
| Codes  { $1 }

Codes:
| { [] }
| Code Codes { $1 :: $2 }

Code:
| LET PROCESSOR Parameters EQUAL Body Codepart2  { ($2, $3 ,$5, $6) }

Codepart2:
|LBRACE Returns RBRACE { print_endline "GAYyyyyy"; $2 }
Parameters:
| { [] }
| Parameter Parameters { $1 :: $2 }

Parameter:
| STRING { $1 }



Body:
| { [] }
| body_content Body { $1 :: $2 }

Returns:
| { [] }
| RETURN_MODULE PERIOD REGISTER{ print_endline "G2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAY";[($1,$3)] }
| RETURN_MODULE PERIOD REGISTER SEMICOLON Returns { print_endline "G2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAY";[($1,$3)] }

body_content:
| LET REGISTER EQUAL DEREFERENCE STRING SEMICOLON  { RegRead ($2, MemRef $5) }
| STRING ASSIGN NUMBER SEMICOLON{ MemAssign (MemRef $1, $3) }
| ATOMIC_SET STRING NUMBER SEMICOLON{ MemAtomicAssign (MemAtomic $2,  $3) }
| LET REGISTER EQUAL ATOMIC_GET STRING IN  { RegAtomicRead ($2, MemAtomic $5) }


Predicate:
| NUMBER COLON REGISTER EQUAL NUMBER { PredReg (($1, $3), $5) }
| STRING EQUAL NUMBER { PredMem (MemAny $1, $3) }


Condition:
  | EXISTS LogicalOp { $2 }

LogicalOp:
  | Predicate { Predicate $1 }
  | LogicalOp AND LogicalOp { And ($1, $3) }
  | LogicalOp OR LogicalOp { Or ($1, $3) }
  | LPAREN LogicalOp RPAREN { $2 }


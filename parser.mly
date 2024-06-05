%{
open Ast
%}

%token <string>  STRING
%token <int> NUMBER
%token <string> REGISTER
%token <string> PROCESSOR
%token LBRACE RBRACE SEMICOLON DEREFERENCE QUOTE LET ASSIGN EQUAL EXISTS LPAREN RPAREN AND OR EOF 
%token ARCH_X86 ARCH_X86_64
%type <Ast.s> main
%start main

%%

main:
| arch = Arch testname = Testname cycle = Cycle init = Init codes = Code_Block condition = Condition EOF
    { 
      { arch = arch; testname = testname; cycle = cycle; init = init; codes = codes; condition = condition }
    }

Arch:
| ARCH_X86 { X86 }
| ARCH_X86_64 { X86_64}

Testname:
| STRING  { $1 }

Memory:
|STRING { $1 }
Cycle:
| QUOTE STRING QUOTE { $2 }

Init:
| LBRACE init_contents RBRACE { $2 }

init_contents:
| /* empty */ { [] }
| init_item { [$1] }
| init_item SEMICOLON init_contents { $1 :: $3 }

init_item:
| Memory EQUAL NUMBER { ($1, $3) }


Code_Block:
| LBRACE Codes RBRACE { $2 }

Codes:
| { [] }
| Code Codes { $1 :: $2 }

Code:
| LET PROCESSOR EQUAL Body { ($2, $4) }

Body:
| { [] }
| body_content { [$1] } 
| body_content SEMICOLON Body { $1 :: $3 }

body_content:
| REGISTER ASSIGN DEREFERENCE Memory  { RegRead ($1, $4) }
| Memory ASSIGN NUMBER  { MemAssign ($1, $3) }

Condition:
| EXISTS LPAREN Predicate pred_list RPAREN { ($3 :: $4, []) }

Predicate:
| REGISTER EQUAL NUMBER { PredReg ($1, $3) }
| Memory EQUAL NUMBER { PredMem ($1, $3) }


pred_list:
| { [] }
| Logicsymb Predicate pred_list { $2 :: $3 }

Logicsymb:
| AND { And }
| OR { Or }

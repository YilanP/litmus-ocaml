%{
open Ast
%}

%token <string> ARCH STRING CODES
%token <int> NUMBER
%token LBRACE RBRACE SEMICOLON QUOTE LET P R EQUAL EXISTS LPAREN RPAREN AND OR EOF
%type <Ast.s> main
%start main

%%

main:
| Arch STRING Testname STRING Init Cycle Codes Condition { { arch = $2; testname = $4; init = $5; cycle = $6; codes = $7; condition = $8 } }

Arch:
| ARCH { $1 }

Testname:
| STRING { $1 }

Init:
| LBRACE init_contents RBRACE { $2 }

init_contents:
| /* empty */ { [] }
| init_item { [$1] }
| init_item SEMICOLON init_contents { $1 :: $3 }

init_item:
| Memory EQUAL NUMBER { ($1, $3) }

Memory:
| STRING { ($1, None) }
| STRING NUMBER { ($1, Some $2) }

Cycle:
| QUOTE STRING QUOTE { $2 }

Codes:
| CODES { $1 }

Condition:
| EXISTS LPAREN Predicate pred_list RPAREN { ($3 :: $4, []) }

Predicate:
| Register EQUAL NUMBER { PredReg ($1, $3) }
| Memory EQUAL NUMBER { PredMem ($1, $3) }


Register:
| R NUMBER { $2 }

pred_list:
| /* empty */ { [] }
| Logicsymb Predicate pred_list { $2 :: $3 }

Logicsymb:
| AND { And }
| OR { Or }

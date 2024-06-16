{
open Parser
open Lexing

exception Error of string

}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanum = ['a'-'z' 'A'-'Z' '0'-'9' '_']
let space = [' ' '\t' '\r' '\n']

rule token = parse
| space { token lexbuf } (* skip whitespace *)
| "{" { print_endline "{ LBRACE"; LBRACE }
| "}" { print_endline "} RBRACE"; RBRACE }
| ";" { print_endline "; SEMICOLON"; SEMICOLON }
| ":" { print_endline ": COLON"; COLON }
| "." {
    print_endline ". PERIOD";
    PERIOD;
}
| "p" (digit+ as num) {
    print_endline (num ^ " PROCESSOR");
    PROCESSOR (int_of_string num)
}
| "r" (digit+ as num) {
    print_endline ("num= "^ num ^ " REGISTER");
    REGISTER (int_of_string num);
}
| "Ret" (digit+ as num) {
    print_endline ("Ret num= " ^ num ^ " RETURN MODULE");
    RETURN_MODULE (int_of_string num);
}

| "in"{ print_endline "in IN"; IN }

| "\"" { print_endline "\" QUOTE"; QUOTE }


| "!" { print_endline "!"; DEREFERENCE }
| ":=" { print_endline ":= ASSIGN"; ASSIGN }
| "=" { print_endline "= EQUAL"; EQUAL }
| "exists" { print_endline "exists EXISTS"; EXISTS }
| "(" { print_endline "( LPAREN"; LPAREN }
| ")" { print_endline ") RPAREN"; RPAREN }
| "&&" { print_endline "&& AND"; AND }
| "||" { print_endline "|| OR"; OR }
| "let" { print_endline "let LET"; LET }
| "Ocaml" { print_endline "X86_64 ARCH_X86_64"; ARCH_Ocaml }
| "Atomic.set" { print_endline "Atomic.set"; ATOMIC_SET }
| "Atomic.get" { print_endline "Atomic.get"; ATOMIC_GET }
| digit+ as num { let n = int_of_string num in print_endline (num ^ " NUMBER"); NUMBER n }
| alphanum+ as str { print_endline (str ^ " STRING"); STRING str }
| _ { raise (Failure "lexing: unexpected character") }
| eof { print_endline "EOF"; EOF }

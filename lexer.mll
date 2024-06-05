{
open Parser
open Lexing

exception Error of string

}
(* In Lexer.ml *)

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanum = ['a'-'z' 'A'-'Z' '0'-'9' '_' '.']
let space = [' ' '\t' '\r' '\n']
(*
rule token = parse
| space { token lexbuf } (* skip whitespace *)
| "{" { LBRACE }
| "}" { RBRACE }
| ";" { SEMICOLON }
| "\"" { QUOTE }
| "r" { R }
| "P" { P }
| ":=" { ASSIGN }
| "=" { EQUAL }
| "exists" { EXISTS }
| "(" { LPAREN }
| ")" { RPAREN }
| "&&" { AND }
| "||" { OR }
| "let" { LET }
| "X86_64" { ARCH_X86_64 }
| "X86" { ARCH_X86 }
| digit+ { NUMBER (int_of_string (lexeme lexbuf)) }
| alphanum+ as str { STRING (lexeme lexbuf) }
| _ { raise (Failure "lexing: unexpected character") }
| eof { EOF }

*)
rule token = parse
| space { token lexbuf } (* skip whitespace *)
| "{" { print_endline "{ LBRACE"; LBRACE }
| "}" { print_endline "} RBRACE"; RBRACE }
| ";" { print_endline "; SEMICOLON"; SEMICOLON }
| "\"" { print_endline "\" QUOTE"; QUOTE }
| "r" digit+ as num { print_endline (num ^ " REGISTER"); REGISTER num }
| "p" digit+ as num { print_endline (num ^ " PROCESSOR"); PROCESSOR num }
| "!" { print_endline "!"; DEREFERENCE }
| ":=" { print_endline ":= ASSIGN"; ASSIGN }
| "=" { print_endline "= EQUAL"; EQUAL }
| "exists" { print_endline "exists EXISTS"; EXISTS }
| "(" { print_endline "( LPAREN"; LPAREN }
| ")" { print_endline ") RPAREN"; RPAREN }
| "&&" { print_endline "&& AND"; AND }
| "||" { print_endline "|| OR"; OR }
| "let" { print_endline "let LET"; LET }
| "X86_64" { print_endline "X86_64 ARCH_X86_64"; ARCH_X86_64 }
| "X86" { print_endline "X86 ARCH_X86"; ARCH_X86 }
| digit+ as num { let n = int_of_string num in print_endline (num ^ " NUMBER"); NUMBER n }
| alphanum+ as str { print_endline (str ^ " STRING"); STRING str }
| _ { raise (Failure "lexing: unexpected character") }
| eof { print_endline "EOF"; EOF }
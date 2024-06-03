{
open Parser
open Lexing

exception Error of string

}
(* In Lexer.ml *)

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanum = ['a'-'z' 'A'-'Z' '0'-'9' '_']
let space = [' ' '\t' '\r' '\n']
let nonbrace = [^ '}']  (* Any character except '}' *)

rule token = parse
| space { token lexbuf } (* skip whitespace *)
| "{" { LBRACE }
| "}" { RBRACE }
| ";" { SEMICOLON }
| "\"" { QUOTE }
| "let" { LET }
| "r" { R }
| "P" { P }
| "=" { EQUAL }
| "exists" { EXISTS }
| "(" { LPAREN }
| ")" { RPAREN }
| "&&" { AND }
| "||" { OR }
| nonbrace+ as codes { CODES codes }
| alpha+ { ARCH (lexeme lexbuf) }
| digit+ { NUMBER (int_of_string (lexeme lexbuf)) }
| alphanum+ as str { STRING (lexeme lexbuf) }
| _ { raise (Failure "lexing: unexpected character") }
| eof { EOF }

(* Assume Ast has a function to_string : s -> string for converting parsed results to string *)
open Ast
open Parser
open Lexing

(* Describes a token generated by the lexer for debugging purposes *)
let describe_token = function
  | LBRACE -> "LBRACE"
  | RBRACE -> "RBRACE"
  | QUOTE -> "QUOTE"
  | SEMICOLON -> "SEMICOLON"
  | ASSIGN -> "ASSIGN"
  | EQUAL -> "EQUAL"
  | EXISTS -> "EXISTS"
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | AND -> "AND"
  | OR -> "OR"
  | ARCH_X86 -> "ARCH_X86"
  | ARCH_X86_64 -> "ARCH_X86_64"
  | NUMBER n -> Printf.sprintf "NUMBER(%d)" n
  | STRING s -> Printf.sprintf "STRING(%s)" s
  | EOF -> "EOF"
  | _ -> "Unknown Token"

 let () =
  let lexbuf = Lexing.from_channel stdin in
  try
    let result = Parser.main Lexer.token lexbuf in
    print_endline (Ast.to_string result)
  with
  | Parser.Error ->
    let pos = lexbuf.Lexing.lex_curr_p in
    Printf.eprintf "Syntax error at line %d, position %d\n" pos.Lexing.pos_lnum (pos.Lexing.pos_cnum - pos.Lexing.pos_bol)
  | Lexer.Error msg ->
    Printf.eprintf "Lexer error: %s\n" msg
open Ast
open Parser
open Lexing
open Codegen
let output_name = "output.ml"

let () =
  let lexbuf = Lexing.from_channel stdin in
  try
    let result = Parser.main Lexer.token lexbuf in
    print_endline (Ast.to_string result) ;
    generate_code result output_name
  with
  | Parser.Error ->
    let pos = lexbuf.Lexing.lex_curr_p in
    Printf.eprintf "Syntax error at line %d, position %d\n" pos.Lexing.pos_lnum (pos.Lexing.pos_cnum - pos.Lexing.pos_bol)
  | Lexer.Error msg ->
    Printf.eprintf "Lexer error: %s\n" msg


(* The type of tokens. *)

type token = 
  | STRING of (string)
  | SEMICOLON
  | RPAREN
  | REGISTER of (string)
  | RBRACE
  | QUOTE
  | PROCESSOR of (string)
  | OR
  | NUMBER of (int)
  | LPAREN
  | LET
  | LBRACE
  | EXISTS
  | EQUAL
  | EOF
  | ASSIGN
  | ARCH_X86_64
  | ARCH_X86
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.s)

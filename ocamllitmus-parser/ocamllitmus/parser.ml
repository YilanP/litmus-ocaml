
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | STRING of (
# 5 "parser.mly"
       (string)
# 15 "parser.ml"
  )
    | SEMICOLON
    | RPAREN
    | REGISTER of (
# 7 "parser.mly"
       (string)
# 22 "parser.ml"
  )
    | RBRACE
    | QUOTE
    | PROCESSOR of (
# 8 "parser.mly"
       (string)
# 29 "parser.ml"
  )
    | OR
    | NUMBER of (
# 6 "parser.mly"
       (int)
# 35 "parser.ml"
  )
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
  
end

include MenhirBasics

# 1 "parser.mly"
  
open Ast

# 56 "parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState11 : ('s _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle, _menhir_box_main) _menhir_state
    (** State 11.
        Stack shape : Arch Testname Cycle.
        Start symbol: main. *)

  | MenhirState14 : (('s, _menhir_box_main) _menhir_cell1_init_item, _menhir_box_main) _menhir_state
    (** State 14.
        Stack shape : init_item.
        Start symbol: main. *)

  | MenhirState22 : ('s _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init, _menhir_box_main) _menhir_state
    (** State 22.
        Stack shape : Arch Testname Cycle Init.
        Start symbol: main. *)

  | MenhirState25 : (('s, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_PROCESSOR, _menhir_box_main) _menhir_state
    (** State 25.
        Stack shape : LET PROCESSOR.
        Start symbol: main. *)

  | MenhirState27 : (('s, _menhir_box_main) _menhir_cell1_REGISTER, _menhir_box_main) _menhir_state
    (** State 27.
        Stack shape : REGISTER.
        Start symbol: main. *)

  | MenhirState30 : (('s, _menhir_box_main) _menhir_cell1_body_content, _menhir_box_main) _menhir_state
    (** State 30.
        Stack shape : body_content.
        Start symbol: main. *)

  | MenhirState38 : (('s, _menhir_box_main) _menhir_cell1_Code, _menhir_box_main) _menhir_state
    (** State 38.
        Stack shape : Code.
        Start symbol: main. *)

  | MenhirState42 : ('s _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init _menhir_cell0_Code_Block, _menhir_box_main) _menhir_state
    (** State 42.
        Stack shape : Arch Testname Cycle Init Code_Block.
        Start symbol: main. *)

  | MenhirState46 : (('s _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init _menhir_cell0_Code_Block, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_state
    (** State 46.
        Stack shape : Arch Testname Cycle Init Code_Block Predicate.
        Start symbol: main. *)

  | MenhirState51 : ((('s, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_cell1_Logicsymb, _menhir_box_main) _menhir_state
    (** State 51.
        Stack shape : Predicate Logicsymb.
        Start symbol: main. *)

  | MenhirState52 : (((('s, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_cell1_Logicsymb, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_state
    (** State 52.
        Stack shape : Predicate Logicsymb Predicate.
        Start symbol: main. *)


and 's _menhir_cell0_Arch = 
  | MenhirCell0_Arch of 's * (Ast.arch)

and ('s, 'r) _menhir_cell1_Code = 
  | MenhirCell1_Code of 's * ('s, 'r) _menhir_state * (Ast.code)

and 's _menhir_cell0_Code_Block = 
  | MenhirCell0_Code_Block of 's * (Ast.codes)

and 's _menhir_cell0_Cycle = 
  | MenhirCell0_Cycle of 's * (Ast.cycle)

and 's _menhir_cell0_Init = 
  | MenhirCell0_Init of 's * (Ast.init)

and ('s, 'r) _menhir_cell1_Logicsymb = 
  | MenhirCell1_Logicsymb of 's * ('s, 'r) _menhir_state * (Ast.logicsymb)

and ('s, 'r) _menhir_cell1_Predicate = 
  | MenhirCell1_Predicate of 's * ('s, 'r) _menhir_state * (Ast.predicate)

and 's _menhir_cell0_Testname = 
  | MenhirCell0_Testname of 's * (Ast.testname)

and ('s, 'r) _menhir_cell1_body_content = 
  | MenhirCell1_body_content of 's * ('s, 'r) _menhir_state * (Ast.body_content)

and ('s, 'r) _menhir_cell1_init_item = 
  | MenhirCell1_init_item of 's * ('s, 'r) _menhir_state * (Ast.memory * Ast.number)

and ('s, 'r) _menhir_cell1_LET = 
  | MenhirCell1_LET of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_PROCESSOR = 
  | MenhirCell0_PROCESSOR of 's * (
# 8 "parser.mly"
       (string)
# 152 "parser.ml"
)

and ('s, 'r) _menhir_cell1_REGISTER = 
  | MenhirCell1_REGISTER of 's * ('s, 'r) _menhir_state * (
# 7 "parser.mly"
       (string)
# 159 "parser.ml"
)

and _menhir_box_main = 
  | MenhirBox_main of (Ast.s) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 23 "parser.mly"
           ( X86 )
# 170 "parser.ml"
     : (Ast.arch))

let _menhir_action_02 =
  fun () ->
    (
# 24 "parser.mly"
              ( X86_64)
# 178 "parser.ml"
     : (Ast.arch))

let _menhir_action_03 =
  fun () ->
    (
# 57 "parser.mly"
  ( [] )
# 186 "parser.ml"
     : (Ast.body))

let _menhir_action_04 =
  fun _1 ->
    (
# 58 "parser.mly"
               ( [_1] )
# 194 "parser.ml"
     : (Ast.body))

let _menhir_action_05 =
  fun _1 _3 ->
    (
# 59 "parser.mly"
                              ( _1 :: _3 )
# 202 "parser.ml"
     : (Ast.body))

let _menhir_action_06 =
  fun _2 _4 ->
    (
# 54 "parser.mly"
                           ( (_2, _4) )
# 210 "parser.ml"
     : (Ast.code))

let _menhir_action_07 =
  fun _2 ->
    (
# 47 "parser.mly"
                      ( _2 )
# 218 "parser.ml"
     : (Ast.codes))

let _menhir_action_08 =
  fun () ->
    (
# 50 "parser.mly"
  ( [] )
# 226 "parser.ml"
     : (Ast.codes))

let _menhir_action_09 =
  fun _1 _2 ->
    (
# 51 "parser.mly"
             ( _1 :: _2 )
# 234 "parser.ml"
     : (Ast.codes))

let _menhir_action_10 =
  fun _3 _4 ->
    (
# 66 "parser.mly"
                                           ( (_3 :: _4, []) )
# 242 "parser.ml"
     : (Ast.condition))

let _menhir_action_11 =
  fun _2 ->
    (
# 32 "parser.mly"
                     ( _2 )
# 250 "parser.ml"
     : (Ast.cycle))

let _menhir_action_12 =
  fun _2 ->
    (
# 35 "parser.mly"
                              ( _2 )
# 258 "parser.ml"
     : (Ast.init))

let _menhir_action_13 =
  fun () ->
    (
# 78 "parser.mly"
      ( And )
# 266 "parser.ml"
     : (Ast.logicsymb))

let _menhir_action_14 =
  fun () ->
    (
# 79 "parser.mly"
     ( Or )
# 274 "parser.ml"
     : (Ast.logicsymb))

let _menhir_action_15 =
  fun _1 ->
    (
# 30 "parser.mly"
        ( _1 )
# 282 "parser.ml"
     : (Ast.memory))

let _menhir_action_16 =
  fun _1 _3 ->
    (
# 69 "parser.mly"
                        ( PredReg (_1, _3) )
# 290 "parser.ml"
     : (Ast.predicate))

let _menhir_action_17 =
  fun _1 _3 ->
    (
# 70 "parser.mly"
                      ( PredMem (_1, _3) )
# 298 "parser.ml"
     : (Ast.predicate))

let _menhir_action_18 =
  fun _1 ->
    (
# 27 "parser.mly"
          ( _1 )
# 306 "parser.ml"
     : (Ast.testname))

let _menhir_action_19 =
  fun _1 _3 ->
    (
# 62 "parser.mly"
                          ( RegRead (_1, _3) )
# 314 "parser.ml"
     : (Ast.body_content))

let _menhir_action_20 =
  fun _1 _3 ->
    (
# 63 "parser.mly"
                        ( MemAssign (_1, _3) )
# 322 "parser.ml"
     : (Ast.body_content))

let _menhir_action_21 =
  fun () ->
    (
# 38 "parser.mly"
              ( [] )
# 330 "parser.ml"
     : (Ast.init))

let _menhir_action_22 =
  fun _1 ->
    (
# 39 "parser.mly"
            ( [_1] )
# 338 "parser.ml"
     : (Ast.init))

let _menhir_action_23 =
  fun _1 _3 ->
    (
# 40 "parser.mly"
                                    ( _1 :: _3 )
# 346 "parser.ml"
     : (Ast.init))

let _menhir_action_24 =
  fun _1 _3 ->
    (
# 43 "parser.mly"
                      ( (_1, _3) )
# 354 "parser.ml"
     : (Ast.memory * Ast.number))

let _menhir_action_25 =
  fun arch codes condition cycle init testname ->
    (
# 18 "parser.mly"
    ( 
      { arch = arch; testname = testname; cycle = cycle; init = init; codes = codes; condition = condition }
    )
# 364 "parser.ml"
     : (Ast.s))

let _menhir_action_26 =
  fun () ->
    (
# 74 "parser.mly"
              ( [] )
# 372 "parser.ml"
     : (Ast.predicate list))

let _menhir_action_27 =
  fun _2 _3 ->
    (
# 75 "parser.mly"
                                ( _2 :: _3 )
# 380 "parser.ml"
     : (Ast.predicate list))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | AND ->
        "AND"
    | ARCH_X86 ->
        "ARCH_X86"
    | ARCH_X86_64 ->
        "ARCH_X86_64"
    | ASSIGN ->
        "ASSIGN"
    | EOF ->
        "EOF"
    | EQUAL ->
        "EQUAL"
    | EXISTS ->
        "EXISTS"
    | LBRACE ->
        "LBRACE"
    | LET ->
        "LET"
    | LPAREN ->
        "LPAREN"
    | NUMBER _ ->
        "NUMBER"
    | OR ->
        "OR"
    | PROCESSOR _ ->
        "PROCESSOR"
    | QUOTE ->
        "QUOTE"
    | RBRACE ->
        "RBRACE"
    | REGISTER _ ->
        "REGISTER"
    | RPAREN ->
        "RPAREN"
    | SEMICOLON ->
        "SEMICOLON"
    | STRING _ ->
        "STRING"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_49 : type  ttv_stack. (ttv_stack _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init _menhir_cell0_Code_Block, _menhir_box_main) _menhir_cell1_Predicate -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_Predicate (_menhir_stack, _, _3) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_10 _3 _4 in
      match (_tok : MenhirBasics.token) with
      | EOF ->
          let MenhirCell0_Code_Block (_menhir_stack, codes) = _menhir_stack in
          let MenhirCell0_Init (_menhir_stack, init) = _menhir_stack in
          let MenhirCell0_Cycle (_menhir_stack, cycle) = _menhir_stack in
          let MenhirCell0_Testname (_menhir_stack, testname) = _menhir_stack in
          let MenhirCell0_Arch (_menhir_stack, arch) = _menhir_stack in
          let condition = _v in
          let _v = _menhir_action_25 arch codes condition cycle init testname in
          MenhirBox_main _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_53 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_cell1_Logicsymb, _menhir_box_main) _menhir_cell1_Predicate -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_Predicate (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_Logicsymb (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_27 _2 _3 in
      _menhir_goto_pred_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_pred_list : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState52 ->
          _menhir_run_53 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState46 ->
          _menhir_run_49 _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  let rec _menhir_run_12 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_15 _1 in
      _menhir_goto_Memory _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_Memory : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState42 ->
          _menhir_run_54 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState51 ->
          _menhir_run_54 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState25 ->
          _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState30 ->
          _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState27 ->
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState11 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState14 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_54 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let (_1, _3) = (_v, _v_0) in
              let _v = _menhir_action_17 _1 _3 in
              _menhir_goto_Predicate _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_Predicate : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState51 ->
          _menhir_run_52 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState42 ->
          _menhir_run_46 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_52 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate, _menhir_box_main) _menhir_cell1_Logicsymb as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_Predicate (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | OR ->
          _menhir_run_47 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState52
      | AND ->
          _menhir_run_48 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState52
      | RPAREN ->
          let _v_0 = _menhir_action_26 () in
          _menhir_run_53 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_47 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate as 'stack) -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_14 () in
      _menhir_goto_Logicsymb _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_Logicsymb : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_Logicsymb (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING _v_0 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState51
      | REGISTER _v_1 ->
          _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState51
      | _ ->
          _eRR ()
  
  and _menhir_run_43 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let (_1, _3) = (_v, _v_0) in
              let _v = _menhir_action_16 _1 _3 in
              _menhir_goto_Predicate _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_48 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_Predicate as 'stack) -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_13 () in
      _menhir_goto_Logicsymb _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_46 : type  ttv_stack. (ttv_stack _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init _menhir_cell0_Code_Block as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_Predicate (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | OR ->
          _menhir_run_47 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | AND ->
          _menhir_run_48 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | RPAREN ->
          let _v_0 = _menhir_action_26 () in
          _menhir_run_49 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_31 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | ASSIGN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let (_1, _3) = (_v, _v_0) in
              let _v = _menhir_action_20 _1 _3 in
              _menhir_goto_body_content _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_body_content : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _menhir_stack = MenhirCell1_body_content (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v_0 ->
              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState30
          | REGISTER _v_1 ->
              _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState30
          | LET | RBRACE ->
              let _v_2 = _menhir_action_03 () in
              _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
          | _ ->
              _eRR ())
      | LET | RBRACE ->
          let _1 = _v in
          let _v = _menhir_action_04 _1 in
          _menhir_goto_Body _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_26 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_REGISTER (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ASSIGN ->
          let _menhir_s = MenhirState27 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | STRING _v ->
              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_34 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_body_content -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_body_content (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_05 _1 _3 in
      _menhir_goto_Body _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_Body : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState25 ->
          _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState30 ->
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_35 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_PROCESSOR -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell0_PROCESSOR (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_LET (_menhir_stack, _menhir_s) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_06 _2 _4 in
      let _menhir_stack = MenhirCell1_Code (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | LET ->
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState38
      | RBRACE ->
          let _v_0 = _menhir_action_08 () in
          _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_23 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LET (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PROCESSOR _v ->
          let _menhir_stack = MenhirCell0_PROCESSOR (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQUAL ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | STRING _v_0 ->
                  _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState25
              | REGISTER _v_1 ->
                  _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState25
              | LET | RBRACE ->
                  let _v_2 = _menhir_action_03 () in
                  _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_39 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_Code -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_Code (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_09 _1 _2 in
      _menhir_goto_Codes _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_Codes : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState38 ->
          _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState22 ->
          _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_36 : type  ttv_stack. ttv_stack _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle _menhir_cell0_Init -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _2 = _v in
      let _v = _menhir_action_07 _2 in
      let _menhir_stack = MenhirCell0_Code_Block (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | EXISTS ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LPAREN ->
              let _menhir_s = MenhirState42 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | STRING _v ->
                  _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | REGISTER _v ->
                  _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_28 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_REGISTER -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_REGISTER (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_19 _1 _3 in
      _menhir_goto_body_content _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_16 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | EQUAL ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let (_1, _3) = (_v, _v_0) in
              let _v = _menhir_action_24 _1 _3 in
              (match (_tok : MenhirBasics.token) with
              | SEMICOLON ->
                  let _menhir_stack = MenhirCell1_init_item (_menhir_stack, _menhir_s, _v) in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | STRING _v_0 ->
                      _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState14
                  | RBRACE ->
                      let _v_1 = _menhir_action_21 () in
                      _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
                  | _ ->
                      _eRR ())
              | RBRACE ->
                  let _1 = _v in
                  let _v = _menhir_action_22 _1 in
                  _menhir_goto_init_contents _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_init_item -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_init_item (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_23 _1 _3 in
      _menhir_goto_init_contents _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_init_contents : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState11 ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState14 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_19 : type  ttv_stack. ttv_stack _menhir_cell0_Arch _menhir_cell0_Testname _menhir_cell0_Cycle -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _2 = _v in
      let _v = _menhir_action_12 _2 in
      let _menhir_stack = MenhirCell0_Init (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | LBRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LET ->
              _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState22
          | RBRACE ->
              let _v_0 = _menhir_action_08 () in
              _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  let _menhir_goto_Arch : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_Arch (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | STRING _v_0 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v_0 in
          let _v = _menhir_action_18 _1 in
          let _menhir_stack = MenhirCell0_Testname (_menhir_stack, _v) in
          (match (_tok : MenhirBasics.token) with
          | QUOTE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | STRING _v_0 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | QUOTE ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      let _2 = _v_0 in
                      let _v = _menhir_action_11 _2 in
                      let _menhir_stack = MenhirCell0_Cycle (_menhir_stack, _v) in
                      (match (_tok : MenhirBasics.token) with
                      | LBRACE ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | STRING _v_0 ->
                              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState11
                          | RBRACE ->
                              let _v_1 = _menhir_action_21 () in
                              _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ARCH_X86_64 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_02 () in
          _menhir_goto_Arch _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | ARCH_X86 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_01 () in
          _menhir_goto_Arch _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
end

let main =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_main v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v

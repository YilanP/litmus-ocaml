all: main

main: ast.cmo lexer.cmo parser.cmo main.cmo
	ocamlc -o main ast.cmo lexer.cmo parser.cmo main.cmo

ast.cmo: ast.ml
	ocamlc -c ast.ml

lexer.ml: lexer.mll
	ocamllex lexer.mll

lexer.cmo: lexer.ml parser.cmi
	ocamlc -c lexer.ml

parser.ml parser.mli: parser.mly
	menhir --infer parser.mly

parser.cmi: parser.mli
	ocamlc -c parser.mli

parser.cmo: parser.ml ast.cmo
	ocamlc -c parser.ml

main.cmo: main.ml parser.cmi ast.cmo
	ocamlc -c main.ml

clean:
	rm -f main lexer.ml parser.ml parser.mli *.cmo *.cmi

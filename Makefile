all: main

main: ast.cmo lexer.cmo parser.cmo codegen.cmo main.cmo
	ocamlc -o main ast.cmo lexer.cmo parser.cmo codegen.cmo main.cmo

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

codegen.cmi: codegen.mli
	ocamlc -c codegen.mli

codegen.cmo: codegen.ml codegen.cmi
	ocamlc -c codegen.ml

main.cmo: main.ml parser.cmi ast.cmo codegen.cmi
	ocamlc -c main.ml

# Clean up
clean:
	rm -f main lexer.ml parser.ml parser.mli *.cmo *.cmi *.o

run:
	ocamlc -o out output.ml
	./out 
cleanmake:
	make clean
	make
	./main < $(f)
c:
	./main < $(f)

.PHONY: all clean

.PHONY: clean
.PHONY: run-tests
.PHONY: run-tests-compare-files

CC := gcc
CFLAGS := -I./include -I./build -Wall -Wextra -Wpedantic -g
LDFLAGS := -lfl -lm

bin/forlang: src/main.c build/interpreter.o build/ast.o build/symbol_table.o build/lex.o build/parser.o build/parser.tab.h
	$(CC) $(CFLAGS) -o bin/forlang build/symbol_table.o build/ast.o build/parser.o build/lex.o build/interpreter.o src/main.c $(LDFLAGS)

build/lex.o: build/lex.yy.c build/parser.tab.h 
	$(CC) $(CFLAGS) -c build/lex.yy.c -o build/lex.o

build/parser.o: build/parser.tab.h build/parser.tab.c
	$(CC) $(CFLAGS) -c build/parser.tab.c -o build/parser.o

build/interpreter.o: src/interpreter.c include/interpreter.h src/ast.c include/ast.h src/symbol_table.c include/symbol_table.h
	$(CC) $(CFLAGS) -c src/interpreter.c -o build/interpreter.o

build/ast.o: src/ast.c include/ast.h
	$(CC) $(CFLAGS) -c src/ast.c -o build/ast.o

build/symbol_table.o: src/symbol_table.c include/symbol_table.h
	$(CC) $(CFLAGS) -c src/symbol_table.c -o build/symbol_table.o

build/parser.tab.c build/parser.tab.h: src/parser.y src/lex.l
	bison -Wcounterexamples -d -o build/parser.tab.c src/parser.y

build/lex.yy.c: src/parser.y src/lex.l
	flex -o build/lex.yy.c src/lex.l

clean:
	rm -f bin/forlang 
	rm -f build/*

run-tests: bin/forlang
	./run_tests.sh

run-tests-compare-files: bin/forlang
	./run_tests.sh --compare-files

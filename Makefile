# source @https://www.saltycrane.com/blog/2007/02/example-using-bison-and-flex-with/
# source @https://github.com/meyerd/flex-bison-example/blob/master/Makefile


# Compile
compile: build

build: assembler.exe clean
	./assembler.exe sample.asm

# First clean
clean: assembler.exe
	rm lex.yy.o
	rm lex.yy.c

# Parse and Scan process
assembler.exe: lex.yy.o
	gcc lex.yy.o -o assembler.exe

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: assembler.l
	flex assembler.l

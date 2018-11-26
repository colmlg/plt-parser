#!/bin/bash
bison -d parser.y
flex scanner.flex
gcc lex.yy.c parser.tab.c -o parser
./parser < jaibuc.txt

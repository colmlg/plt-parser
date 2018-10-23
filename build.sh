#!/bin/bash
flex scanner.flex
gcc lex.yy.c -o scanner
./scanner < jaibuc.txt

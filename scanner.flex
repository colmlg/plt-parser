%{
#include <stdio.h>
    
int getSize(char *x) {
    int counter = 0;
    while (*x++) {
        counter++;
    }
    return counter;
}
%}

%option noyywrap
%option caseless

VARIABLE    [A-Z][A-Z0-9\-]*

%%
[\t\n ]+                    /* Ignore whitespace */ ;
BEGINING                    |
BODY                        |
END                         |
MOVE                        |
TO                          |
ADD                         |
INPUT                       |
PRINT                       { printf("Found keyword: %s \n", yytext); }
;                           { printf("Found semicolon\n"); }
X+[ ]X+                     { printf("%s doesn't match \n", yytext); };
X+[ ][0-9]+.*               { printf("%s doesn't match \n", yytext); };
X+                          { printf("Found variable declaration %s of size %d \n", yytext, getSize(yytext)); }
[0-9]+                      { printf("Found digit: %s \n", yytext);}
{VARIABLE}                  { printf("Found variable name: %s \n", yytext);  }
\"(\\.|[^"\\])*\"           { printf("Found text string: %s \n", yytext); }
\.                          { printf("Found terminator: %s \n", yytext); }
.                           ;
%%

int main() {
  yylex();
}

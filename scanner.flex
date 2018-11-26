%{
#include <stdio.h>
#include "parser.tab.h"
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
%option yylineno

%%
[\t\n ]+                    /* Ignore whitespace */ ;
BEGINING                    { return BEGINING; }
BODY                        { return BODY; }
END                         { return END; }
MOVE                        { return MOVE; }
TO                          { return TO; }
ADD                         { return ADD; }
INPUT                       { return INPUT; }
PRINT                       { return PRINT; }
;                           { return SEMICOLON; }
X+                          { yylval.length = getSize(yytext); return NUMSIZE; }
[0-9]+                      { yylval.length = getSize(yytext); return INTEGER; }
\"[^"\n]*\"                 { yylval.value = strdup(yytext); return STRING; }
[A-Z]+[A-Z0-9\-]*           { yylval.value = strdup(yytext); return IDENTIFIER; }
\.                          { return TERMINATOR; }
. ;
%%


/*BEGINING\.\n|.*X+\t[A-Z][A-Z0-9-]*\n|.*BODY. { printf("Found declaration: %s\n", yytext); }*/
/*BEGINING\.\n      |
BODY\.\n          |
END\.\n      { printf("Found token: %s \n", yytext); }
(MOVE|ADD)[ ]([A-Z][A-Z0-9-]*|[0-9]+)[ ]TO[ ][A-Z][A-Z0-9-]*\.\n { printf("Found assignment: %s \n", yytext); }
PRINT[ ](\".*\"|[A-Z][A-Z0-9-]*)(;(\".*\"|[A-Z][A-Z0-9-]*))*\.\n  { printf("Found output: %s \n", yytext); }
INPUT[ ][A-Z][A-Z0-9-]*(;([A-Z][A-Z0-9-]*))*\.\n { printf("Found input: %s \n", yytext); }*/

%{
#include <stdio.h>
%}

%option noyywrap

%%
[ \t\n]         /* Ignore whitespace */;
X+[ ]X+\.\n { printf("%s doesn't match", yytext); };
X+[ ][A-Z][A-Z0-9-]*\.\n { printf("Found declaration: %s \n", yytext); }
BEGINING\.\n      |
BODY\.\n          |
END\.\n      { printf("Found token: %s \n", yytext); }
(MOVE|ADD)[ ]([A-Z][A-Z0-9-]*|[0-9]+)[ ]TO[ ][A-Z][A-Z0-9-]*\.\n { printf("Found assignment: %s \n", yytext); }
PRINT[ ](\".*\"|[A-Z][A-Z0-9-]*)(;(\".*\"|[A-Z][A-Z0-9-]*))*\.\n  { printf("Found output: %s \n", yytext); }
INPUT[ ][A-Z][A-Z0-9-]*(;([A-Z][A-Z0-9-]*))*\.\n { printf("Found input: %s \n", yytext); }
.*\n { printf("%s doesn't match", yytext); }
%%

int main() {
  yylex();
}

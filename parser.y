%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>
#include <ctype.h>
extern int yylex();
extern int yyparse();
extern int yylineno;

void yyerror(const char *s);

char variableIdentifiers[100][100];
int variableSizes[100];
int getVarSize(char *var);
    
void moveIntToVar(int numLength, char* var);
void moveVarToVar(char *var1, char *var2);
    
void addIntToVar(int numLength, char* var);
void addVarToVar(char *var1, char *var2);
    
void isVarInitialized(char *var);
    
bool hasErrors = false;
int declaredVariables = 0;
bool isVarDeclared(char* string);
void createVariable(int size, char* varName);

%}
%union {
    char* value;
    int length;
}
%start program
%token <length> INTEGER
%token <length> NUMSIZE
%token <value> IDENTIFIER STRING
%token BEGINING BODY END MOVE TO ADD INPUT PRINT SEMICOLON TERMINATOR INVALID

%%
program:        begining declarations body code end {}

begining:       BEGINING TERMINATOR {}

declarations:   declaration declarations {}
                | {}

declaration:    NUMSIZE IDENTIFIER TERMINATOR { createVariable($1, $2); }

body:           BODY TERMINATOR {}

code:           line code {}
                | {}
line:           print | input | move | add {}

print:          PRINT printStatement {}
printStatement: STRING SEMICOLON printStatement {}
                | STRING TERMINATOR {}
                | IDENTIFIER TERMINATOR { isVarInitialized($1); }
                | IDENTIFIER SEMICOLON printStatement { isVarInitialized($1); }

input:          INPUT inputStatement {}
inputStatement: IDENTIFIER TERMINATOR { isVarInitialized($1); }
                | IDENTIFIER SEMICOLON inputStatement { isVarInitialized($1); }

move:           MOVE INTEGER TO IDENTIFIER TERMINATOR { moveIntToVar($2, $4); }
                | MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { moveVarToVar($2, $4); }

add:            ADD INTEGER TO IDENTIFIER TERMINATOR { addIntToVar($2, $4); }
                | ADD IDENTIFIER TO IDENTIFIER TERMINATOR { addVarToVar($2, $4); }

end:            END TERMINATOR { }
%%

int main() {
    yyparse();
    if (!hasErrors) {
        printf("Program is well-formed.\n");
    }
    return hasErrors;
}

void yyerror(const char* s) {
    printf("%s on line %d\n", s, yylineno);
    hasErrors = true;
}

void uppercase(char * temp) {
  char * name;
  name = strtok(temp,":");

  // Convert to upper case
  char *s = name;
  while (*s) {
    *s = toupper((unsigned char) *s);
    s++;
  }

}

bool isVarDeclared(char* string) {
    uppercase(string);
    for(int i = 0; i < declaredVariables; i++) {
        if(strcmp(string, variableIdentifiers[i]) == 0) {
            return true;
        }
    }
    return false;
}

void createVariable(int size, char* varName) {
     uppercase(varName);
    if(isVarDeclared(varName)) {
        yyerror("Identifier already initialized");
        return;
    }
    
    //Variable is not declared so we can add it to our list
    strcpy(variableIdentifiers[declaredVariables], varName);
    variableSizes[declaredVariables] = size;
    declaredVariables++;
}

void isVarInitialized(char *var) {
    if (!isVarDeclared(var)) {
        yyerror("Identifier not initialized");
    }
}

int getVarSize(char* var) {
    uppercase(var);
    for (int i = 0; i < declaredVariables; i++) {
        if (strcmp(var, variableIdentifiers[i]) == 0) {
            return variableSizes[i];
        }
    }
    return -1; //This should never happen
}

void moveIntToVar(int numLength, char* var) {
    if (!isVarDeclared(var)) {
        yyerror("Cannot assign integer, variable not declared");
        return;
    }
    
    if (numLength > getVarSize(var)) {
        yyerror("Value you are trying to assign to this variable is too large");
    }
}

void moveVarToVar(char *var1, char *var2) {
    if(!isVarDeclared(var1) || !isVarDeclared(var2)) {
        yyerror("Cannot assign to identifier, identifier is not declared");
        return;
    }
    int size1 = getVarSize(var1);
    int size2 = getVarSize(var2);
    if (size1 > size2) {
        yyerror("Trying to assign to identifier that is too small");
    }
}

void addIntToVar(int numLength, char* var) {
    if (!isVarDeclared(var)) {
        yyerror("Cannot assign integer, variable not declared");
        return;
    }
    
    if (numLength > getVarSize(var)) {
        yyerror("Value you are trying to assign to this variable is too large");
    }
}

void addVarToVar(char *var1, char *var2) {
    if(!isVarDeclared(var1) || !isVarDeclared(var2)) {
        yyerror("Cannot add to identifier, identifier is not declared");
        return;
    }
    int size1 = getVarSize(var1);
    int size2 = getVarSize(var2);
    if (size1 > size2) {
        yyerror("Trying to add to identifier that is too small");
    }
}

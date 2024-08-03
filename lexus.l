%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

void yyerror(const char *s);

// Estructura para almacenar variables
typedef struct {
    char* name;
    int value;
} variable;

// Array para almacenar variables
#define MAX_VARIABLES 1000
variable lista[MAX_VARIABLES];
int num_variables = 0;

// Función para buscar una variable por nombre
int findVar(const char* name) {
    int i;
    for (i = 0; i < num_variables; ++i) {
        if (strcmp(lista[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

// Función para agregar o modificar una variable
void setVar(const char* name, int value) {
    int index = findVar(name);
    if (index != -1) {
        lista[index].value = value;
    } else {
        lista[num_variables].name = strdup(name);
        lista[num_variables].value = value;
        num_variables++;
    }
}

// Función para obtener el valor de una variable
int getVar(const char* name) {
    int index = findVar(name);
    if (index != -1) {
        return lista[index].value;
    } else {
        yyerror("Variable no definida");
        return 0;
    }
}
%}

%option noyywrap

DIGIT   [0-9]
NUM     {DIGIT}+("."{DIGIT}+)?
ID      [a-zA-Z_][a-zA-Z0-9_]*

/*Definiciones*/
%%
"add"               { return ADD; }
"subtract"          { return SUBTRACT; }
"mix"               { return MIX; }
"filter"            { return FILTER; }
"=="                { return EQ; }
">="                { return GE; }
"<="                { return LE; }
">"                 { return GT; }
"<"                 { return LT; }
"="                 { return '='; }
"prepare"           { return PREPARE; }
"ferment"           { return FERMENT; }
{NUM}               { yylval.num = atoi(yytext); return NUMBER; }
{ID}                { yylval.str = strdup(yytext); return IDENTIFIER; }
[();]               { return *yytext; }
[ \t]+              ;  // Ignorar espacios y tabulaciones
\n                  ;  // Ignorar nuevas líneas
.                   { yyerror("Unknown character"); }

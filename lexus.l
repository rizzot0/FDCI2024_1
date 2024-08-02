%{
#include <stdio.h>       // Para printf y fprintf
#include "y.tab.h"  // Incluye los tokens definidos por Bison
void yyerror(const char *s);  // Declaración de la función yyerror
%}

%option noyywrap

DIGIT   [0-9]
NUM     {DIGIT}+("."{DIGIT}+)?
ID      [a-zA-Z_][a-zA-Z0-9_]*

/*Definiciones*/
%%
{NUM}               { yylval = atoi(yytext); return NUMBER; }
"add"               { return ADD; }
"subtract"          { return SUBTRACT; }
"mix"               { return MIX; }
"filter"            { return FILTER; }
"=="                { return EQ; }
">="                { return GE; }
"<="                { return LE; }
">"                 { return GT; }
"<"                 { return LT; }
[();]               { return *yytext; }
"prepare"           { return PREPARE; }
[[:blank:]]         ;  // Ignorar espacios y tabulaciones
\n                  ;  // Ignorar nuevas líneas
.                   { yyerror("Unknown character"); }
%%
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex(void);
void yyerror(const char *s);
int getVar(const char* name);
void setVar(const char* name, int value);

%}

%union {
    int num;
    char* str;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token EQ GT LT GE LE
%token ADD SUBTRACT MIX FILTER
%token PREPARE FERMENT

%type <num> INSTRUCCIONES INSTRUCCION Expr

%start INSTRUCCIONES

// Leer de izquierda a derecha
%left EQ GT LT GE LE
%left ADD SUBTRACT
%left MIX FILTER
%left NEG

/* Regla de secciones */
%%
   // Ejecucion de lineas
   INSTRUCCIONES
      : INSTRUCCION
      | INSTRUCCIONES INSTRUCCION
      ;

   // Ejecucion instruccion
   INSTRUCCION
      : IDENTIFIER '=' Expr ';'
      {
         setVar($1, $3);
         free($1);
      }
      | PREPARE '(' Expr ')' ';'
      {
         printf("\nResultado = %d\n", $3);
      }
      | FERMENT '(' IDENTIFIER '=' Expr ')' ';'
      {
         setVar($3, $5);
         free($3);
      }
      ;

   /* Expresiones matematicas */
   Expr
   : Expr ADD Expr {
      $$ = $1 + $3;
   }

   | Expr SUBTRACT Expr {
      $$ = $1 - $3;
   }

   | Expr MIX Expr {
      $$ = $1 * $3;
   }

   | Expr FILTER Expr {
      $$ = $1 / $3;
   }

   | Expr EQ Expr {
      $$ = $1 == $3;
   }

   | Expr GT Expr {
      $$ = $1 > $3;
   }

   | Expr LT Expr {
      $$ = $1 < $3;
   }

   | Expr GE Expr {
      $$ = $1 >= $3;
   }

   | Expr LE Expr {
      $$ = $1 <= $3;
   }

   | '-' Expr %prec NEG {
      $$ = -$2;
   }

   | '(' Expr ')' {
      $$ = $2;
   }

   | NUMBER {
      $$ = $1;
   }

   | IDENTIFIER {
      $$ = getVar($1);
      free($1);
   }
   ;
%%

// Errores
void yyerror(const char *s) {
   fprintf(stderr, "Error: %s\n", s);
}

// Lectura del archivo 
int main(int argc, char **argv) {
   extern FILE *yyin;
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (!yyin) {
         perror(argv[1]);
         return 1;
      }
   }
   return yyparse();
}

// Finalizacion del archivo
int yywrap() {
   return 1;
}

%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char *s);
%}

// Tokens
%token NUMBER EVALUAR
%token EQ GT LT GE LE
%token ADD SUBTRACT MIX FILTER
%token PREPARE

%start INSTRUCCIONES

// Leer de izquierda a derecha
%left EQ GT LT GE LE
%left ADD SUBTRACT
%left MIX FILTER
%left NEG

/* Rule Section */
%%
   // Ejecucion de lineas
   INSTRUCCIONES
      : INSTRUCCION
      | INSTRUCCIONES INSTRUCCION
      ;

   // Ejecucion instruccion
   INSTRUCCION
      : PREPARE '(' Expr ')' ';'
      {
         printf("\nResultado = %d\n", $3);
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
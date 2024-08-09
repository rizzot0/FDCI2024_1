%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

extern int yylex(void);
void yyerror(const char *s);
int getVar(const char* name);
void setVar(const char* name, int value);

int opSuma(int a, int b, int* overflow);
int opMulti(int a, int b, int* overflow);
void opComparacion(int result);

int contOverflow = 0; // Contador Overflow
int comparador = 0; // Comparacion
int flag = 1;

int fibonacci(int n) {
   if (n <= 0) return 0;
   else if (n == 1) return 1;
   else return fibonacci(n-1) + fibonacci(n-2);
}
%}

%union {
    int num;
    char* str;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token EQ GT LT GE LE
%token ADD SUBTRACT MIX FILTER
%token PREPARE FERMENT FIBONACCI
%token IF ELSE WHILE

%type <num> INSTRUCCIONES INSTRUCCION Expr

%start INSTRUCCIONES

%left EQ GT LT GE LE
%left ADD SUBTRACT
%left MIX FILTER
%left NEG

%%

INSTRUCCIONES
   : INSTRUCCION
   | INSTRUCCIONES INSTRUCCION
   ;

INSTRUCCION
   : IDENTIFIER '=' Expr ';'
   {
      if (!contOverflow) {
         setVar($1, $3);
      }
      free($1);
   }
   | PREPARE '(' Expr ')' ';'
   {
      if (!contOverflow) {
         printf("\nResultado = %d\n", $3);
      }
      contOverflow = 0;
   }
   | FERMENT '(' IDENTIFIER '=' Expr ')' ';'
   {
      if (!contOverflow) {
         setVar($3, $5);
      }
      free($3);
   }
   | IF '(' Expr ')' '{' INSTRUCCIONES '}' ELSE '{' INSTRUCCIONES '}' // if-else
   {
      if ($3) {
         $$ = $6;    
      } else {
         $$ = $10; 
      }
   }
   | IF '(' Expr ')' '{' INSTRUCCIONES '}' // if 
   {
      if ($3) {
         $$ = $6; 
      }
   }
   | WHILE '(' Expr ')' '{' INSTRUCCIONES '}'
   {  
      while (flag){
         if ($3){
            $$ = $6;
         } else{
            flag = 0;
         }
      }
      flag = 1;
   }
   ;

Expr
   : Expr ADD Expr {
      $$ = opSuma($1, $3, &contOverflow);
   }
   | Expr SUBTRACT Expr {
      $$ = opSuma($1, -$3, &contOverflow);
   }
   | Expr MIX Expr {
      $$ = opMulti($1, $3, &contOverflow);
   }
   | Expr FILTER Expr {
      if ($3 == 0) {
         yyerror("Division por cero");
         $$ = 0;
      } else {
         $$ = $1 / $3;
      }
   }
   | Expr EQ Expr {
      $$ = ($1 == $3);
   }
   | Expr GT Expr {
      $$ = ($1 > $3); 
   }
   | Expr LT Expr {
      $$ = ($1 < $3); 
   }
   | Expr GE Expr {
      $$ = ($1 >= $3); 
   }
   | Expr LE Expr {
      $$ = ($1 <= $3); 
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
   | FIBONACCI '(' Expr ')'{
      $$ = fibonacci($3);
   }
   ;
%%

// Funciones de soporte
void yyerror(const char *s) {
   fprintf(stderr, "Error: %s\n", s);
}

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

int yywrap() {
   return 1;
}

int opSuma(int a, int b, int* overflow) {
    long long result = (long long)a + (long long)b;
    if (result > INT_MAX || result < INT_MIN) {
        printf("\nAdvertencia: Ocurrio overflow.\n");
        *overflow = 1;
        return 0;
    }
    *overflow = 0;
    return (int)result;
}

int opMulti(int a, int b, int* overflow) {
    long long result = (long long)a * (long long)b;
    if (result > INT_MAX || result < INT_MIN) {
        printf("\nAdvertencia: Ocurrio overflow.\n");
        *overflow = 1;
        return 0;
    }
    *overflow = 0;
    return (int)result;
}

void opComparacion(int result) {
    if (result) {
        printf("\nTRUE\n");
    } else {
        printf("\nFALSE\n");
    }
}
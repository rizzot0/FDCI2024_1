%{
#include "y.tab.h"
#include <string.h>  // Agregar la declaración de strdup

YY_BUFFER_STATE yy_scan_string(const char *str);
void yypush_buffer_state(YY_BUFFER_STATE new_buffer);
void yypop_buffer_state(void);
void yy_delete_buffer(YY_BUFFER_STATE buffer);
void yy_switch_to_buffer(YY_BUFFER_STATE new_buffer);
%}

%%

"if"            { return IF; }
"else"          { return ELSE; }
"then"          { return THEN; }
"endif"         { return ENDIF; }
"=="            { return IGUAL; }
"<"             { return MENOR; }
">"             { return MAYOR; }
"<="            { return MENORIGUAL; }
">="            { return MAYORIGUAL; }
"="             { return ASIGNAR; }  
"add"           { return SUMA; }
"subtract"      { return RESTA; }
"mix"           { return MULT; }
"filter"        { return DIV; }
"bloodymary"    { return BLOODYMARY; } 
"pourup"        { return WHILE; }
"prepare"       { return DO; }  
"pour"          { return ENDWHILE; }  
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); return ID; }  // Usar yylval.str para nombres de variables
[0-9]+          { yylval.num = atoi(yytext); return NUM; }  // Usar yylval.num para números
[();]           { return *yytext; }
[ \t]+          ;  
\n              { return '\n'; }  
.               { printf("Caracter no reconocido: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

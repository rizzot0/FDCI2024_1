%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definimos una estructura para almacenar las variables y sus valores
typedef struct {
    char nombre[32];
    int valor;
} Variable;

// Nodo para el AST
typedef struct ASTNode {
    enum { COMPARE_NODE, BINARY_OP_NODE, NUM_NODE, VARIABLE_NODE, ASSIGN_NODE, WHILE_NODE, BLOCK_NODE } type;
    union {
        struct {
            char* op;  // Operador de comparación (==, <, >, <=, >=)
            struct ASTNode* left;
            struct ASTNode* right;
        } compare;
        struct {
            char* var_name;
            struct ASTNode* value;
        } assign;
        struct {
            struct ASTNode* condition;
            struct ASTNode* block;
        } while_node;
        struct {
            struct ASTNode** stmts; // Arreglo de declaraciones
            int stmt_count;         // Número de declaraciones
        } block;
        int num;
        char* var_name;
    };
} ASTNode;

Variable tablaSimbolos[100]; 
int numVariables = 0;

int obtenerValor(char* nombre);
void asignarValor(char* nombre, int valor);
int fibonacci(int n);  // Declaración de la función Fibonacci
void yyerror(const char *s);
int yylex();

ASTNode* createComparisonNode(char* op, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = COMPARE_NODE;
    node->compare.op = strdup(op);
    node->compare.left = left;
    node->compare.right = right;
    return node;
}


int evaluateNode(ASTNode* node);
int compareNode(ASTNode* node);
void executeBlockNode(ASTNode* block);
void executeStatement(ASTNode* stmt);
ASTNode* createBlockNode(ASTNode* stmt);
ASTNode* addStatementToBlock(ASTNode* block, ASTNode* stmt);
ASTNode* createExpressionNode(ASTNode* expr);

ASTNode* createWhileNode(ASTNode* condition, ASTNode* block) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = WHILE_NODE;
    node->while_node.condition = condition;
    node->while_node.block = block;
    return node;
}

ASTNode* createNumNode(int value) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NUM_NODE;
    node->num = value;
    return node;
}

// Función para ejecutar un nodo while
void executeWhileNode(ASTNode* node) {
    while (evaluateNode(node->while_node.condition)) {
        executeBlockNode(node->while_node.block);
    }
}

// Comparar nodos
int compareNode(ASTNode* node) {
    // Ejemplo de implementación para comparación
    if (strcmp(node->compare.op, "==") == 0) {
        return evaluateNode(node->compare.left) == evaluateNode(node->compare.right);
    }
    // Agregar más comparaciones según sea necesario
    return 0;
}

ASTNode* createBlockNode(ASTNode* stmt) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = BLOCK_NODE;
    node->block.stmts = (ASTNode**)malloc(sizeof(ASTNode*));
    node->block.stmts[0] = stmt;
    node->block.stmt_count = 1;
    return node;
}

ASTNode* addStatementToBlock(ASTNode* block, ASTNode* stmt) {
    block->block.stmt_count++;
    block->block.stmts = (ASTNode**)realloc(block->block.stmts, block->block.stmt_count * sizeof(ASTNode*));
    block->block.stmts[block->block.stmt_count - 1] = stmt;
    return block;
}

ASTNode* createExpressionNode(ASTNode* expr) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = expr->type;
    node->num = expr->num;
    node->var_name = expr->var_name ? strdup(expr->var_name) : NULL;
    return node;
}

// Evaluar nodos
int evaluateNode(ASTNode* node) {
    switch (node->type) {
        case NUM_NODE:
            return node->num;
        case VARIABLE_NODE:
            return obtenerValor(node->var_name);
        case COMPARE_NODE:
            return compareNode(node);
        // Otros casos...
    }
    return 0;
}

// Ejecutar bloque
void executeBlockNode(ASTNode* block) {
    for (int i = 0; i < block->block.stmt_count; i++) {
        executeStatement(block->block.stmts[i]);
    }
}

void executeStatement(ASTNode* stmt) {
    // Ejecutar declaración
    switch (stmt->type) {
        case ASSIGN_NODE:
            // Asignación
            asignarValor(stmt->assign.var_name, evaluateNode(stmt->assign.value));
            break;
    }
}

%}

%union {
    int num;  // Para manejar números
    char* str;  // Para manejar cadenas de texto
    struct ASTNode* node; // ATS 
}

%token <num> NUM
%token <str> ID
%token SUMA RESTA MULT DIV PARI PARD
%token IF ELSE THEN ENDIF
%token WHILE DO ENDWHILE
%token IGUAL MENOR MAYOR MENORIGUAL MAYORIGUAL
%token ASIGNAR
%token BLOODYMARY  // Declaración del nuevo token

%left SUMA RESTA
%left MULT DIV
%right UMINUS

%type <num> expr cond_expr cond_simple
%type <str> asignacion  // Mantener asignacion como str para manejar IDs
%type <node> exprW block stmt while

%%

input:
    lines
    ;

lines:
    line '\n'         { /* Procesa una línea y sigue */ }
    | line '\n' lines /* Procesa múltiples líneas */
    ;

line:
    expr                { printf("Resultado: %d\n", $1); }
    | cond_simple        { printf("%s\n", $1 ? "true" : "false"); }
    | cond_block
    | asignacion
    | fibonacci_call  // Nueva regla para manejar la llamada a Fibonacci
    | while
    | /* vacío para manejar líneas vacías */ 
    ;

asignacion:
    ID ASIGNAR expr     { asignarValor($1, $3); free($1); }  // Liberar memoria de strdup
    ;

cond_block:
    IF '(' cond_expr ')' THEN expr ELSE expr ENDIF
        { 
            if ($3) {
                printf("Condición verdadera, resultado: %d\n", $6);
            } else {
                printf("Condición falsa, resultado: %d\n", $8);
            }
        }
    ;

while:
    WHILE '(' exprW ')' DO block ENDWHILE {
        $$ = createWhileNode($3, $6);
    }
    ;

block:
    stmt { $$ = createBlockNode($1); }
    | block stmt { $$ = addStatementToBlock($1, $2); }
    ;

stmt:
    expr ';' { $$ = createExpressionNode(createNumNode($1)); }
    ;

fibonacci_call:  // Nueva regla para manejar 'bloodymary'
    BLOODYMARY expr { printf("Fibonacci(%d): %d\n", $2, fibonacci($2)); }
    ;

cond_expr:
    expr IGUAL expr       { $$ = $1 == $3; }
    | expr MENOR expr     { $$ = $1 < $3; }
    | expr MAYOR expr     { $$ = $1 > $3; }
    | expr MENORIGUAL expr { $$ = $1 <= $3; }
    | expr MAYORIGUAL expr { $$ = $1 >= $3; }
    ;

exprW:
    expr IGUAL expr        { $$ = createComparisonNode("==", createNumNode($1), createNumNode($3)); }
    | expr MENOR expr      { $$ = createComparisonNode("<", createNumNode($1), createNumNode($3)); }
    | expr MAYOR expr      { $$ = createComparisonNode(">", createNumNode($1), createNumNode($3)); }
    | expr MENORIGUAL expr { $$ = createComparisonNode("<=", createNumNode($1), createNumNode($3)); }
    | expr MAYORIGUAL expr { $$ = createComparisonNode(">=", createNumNode($1), createNumNode($3)); }
    ;

cond_simple:
    expr IGUAL expr       { $$ = $1 == $3; }
    | expr MENOR expr     { $$ = $1 < $3; }
    | expr MAYOR expr     { $$ = $1 > $3; }
    | expr MENORIGUAL expr { $$ = $1 <= $3; }
    | expr MAYORIGUAL expr { $$ = $1 >= $3; }
    ;

expr:
    expr SUMA expr   { $$ = $1 + $3; }
    | expr RESTA expr { $$ = $1 - $3; }
    | expr MULT expr  { $$ = $1 * $3; }
    | expr DIV expr   { 
        if ($3 == 0) {
            yyerror("Error: División por cero");
            YYABORT;
        } else {
            $$ = $1 / $3;
        }
    }
    | RESTA expr %prec UMINUS { $$ = -$2; }
    | PARI expr PARD { $$ = $2; }
    | NUM            { $$ = $1; }
    | ID             { $$ = obtenerValor($1); }
    ;

%%

int obtenerValor(char* nombre) {
    int i; // Declarar aquí la variable
    for (i = 0; i < numVariables; i++) {
        if (strcmp(tablaSimbolos[i].nombre, nombre) == 0) {
            return tablaSimbolos[i].valor;
        }
    }
    yyerror("Error: Variable no definida");
    return 0;
}


void asignarValor(char* nombre, int valor) {
    int i; // Declarar aquí la variable
    for (i = 0; i < numVariables; i++) {
        if (strcmp(tablaSimbolos[i].nombre, nombre) == 0) {
            tablaSimbolos[i].valor = valor;
            return;
        }
    }
    // Si la variable no existe, la añadimos a la tabla de símbolos
    strcpy(tablaSimbolos[numVariables].nombre, nombre);
    tablaSimbolos[numVariables].valor = valor;
    numVariables++;
}

int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Ingrese una expresión:\n");
    return yyparse();
}
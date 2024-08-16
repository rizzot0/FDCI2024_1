
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUM = 258,
     ID = 259,
     SUMA = 260,
     RESTA = 261,
     MULT = 262,
     DIV = 263,
     PARI = 264,
     PARD = 265,
     IF = 266,
     ELSE = 267,
     THEN = 268,
     ENDIF = 269,
     WHILE = 270,
     DO = 271,
     ENDWHILE = 272,
     IGUAL = 273,
     MENOR = 274,
     MAYOR = 275,
     MENORIGUAL = 276,
     MAYORIGUAL = 277,
     ASIGNAR = 278,
     BLOODYMARY = 279,
     UMINUS = 280
   };
#endif
/* Tokens.  */
#define NUM 258
#define ID 259
#define SUMA 260
#define RESTA 261
#define MULT 262
#define DIV 263
#define PARI 264
#define PARD 265
#define IF 266
#define ELSE 267
#define THEN 268
#define ENDIF 269
#define WHILE 270
#define DO 271
#define ENDWHILE 272
#define IGUAL 273
#define MENOR 274
#define MAYOR 275
#define MENORIGUAL 276
#define MAYORIGUAL 277
#define ASIGNAR 278
#define BLOODYMARY 279
#define UMINUS 280




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 154 ".\\parser.y"

    int num;  // Para manejar números
    char* str;  // Para manejar cadenas de texto
    struct ASTNode* node; // ATS 



/* Line 1676 of yacc.c  */
#line 110 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



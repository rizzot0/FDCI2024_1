# FDCI2024_1
Fundamentos de la computacion curso invierno 2024-1

## Lenguaje COPT

Desallorado utilizando bison(2.4.1 o posterior) y flex( 2.5.4a o posterior)  

Lenguaje de alto nivel el cual tiene referencias a acciones relacionas al alcohol y sus procesos el cual su uso seria similar a la escritura sin reglas del ingles.

## Diccionario

### accion = prepare (llamar a la funcion de procesar datos)
### variable = ferment (creacion de variable)
### + = add
### - = subtract
### * = mix
### / = filter
### if = if
### while = pourup

## Salida por consola de datos booleanos
### 0 = negative
### 1 = positive

## Compilacion

-> Abrir cmd en la carpeta donde descomprimira el proyecto
-> flex lexus.l
-> bison -dy parsero.y
-> gcc lex.yy.c y.tab.c 
-> a.exe < testF.txt

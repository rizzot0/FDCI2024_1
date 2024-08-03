# FDCI2024_1
Fundamentos de la computacion curso invierno 2024-1

## Lenguaje COPT

Desallorado utilizando bison(2.4.1 o posterior) y flex( 2.5.4a o posterior)  

Lenguaje de alto nivel el cual tiene referencias a acciones relacionas al alcohol y sus procesos el cual su uso seria similar a la escritura sin reglas del ingles.

## Diccionario

#### Accion = prepare (llamar a la funcion de procesar datos)
#### variable = ferment (creacion de variable)
#### [Operacion]; (Se debe escribir ; al final de una linea de codigo)
#### + = add
#### - = subtract
#### * = mix
#### / = filter
#### if = if
#### while = pourup

## Salida por consola de datos booleanos
#### 0 = negative
#### 1 = positive

## Compilacion

#### -> Abrir cmd en la carpeta donde descomprimira el proyecto
#### -> flex lexus.l
#### -> bison -dy parsero.y
#### -> gcc lex.yy.c y.tab.c 
#### -> a.exe < testF.txt

## Ejemplos de operaciones 

### Ejemplo 1
#### prepare(1 add 1); (Sumar 1+1)

### Ejemplo 2
#### prepare((9 add 3) filter 4); (Suma 9 +3 y lo divide en 3)

### Ejemplo 3
#### ferment(x = 5); (Asignar valor 5 a la variable x)
#### ferment(y = 10); (Asignar valor 10 a la variable y)
#### ferment(z = (x mix y)); (Multiplica x con y asignadolo a la variable z)
#### prepare(z); (Muestra por consola el valor de la variable z)



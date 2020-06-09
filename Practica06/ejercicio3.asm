.data
	first_msg: .asciiz "Ingrese el valor de n \n"
	second_msg: .asciiz "Ingrese el valor de k \n"

#Macro para imprimir cadenas
.macro print_str(%r)
	move $t0, $a0		#Guarda contenido de $a0 en ·$t0
	li $v0 4		#Prepara para imprimir un string
	la $a0, %r 		#Guarda en $a0 la cadena 
    	syscall			#Imprime el mensaje con una llamda al sistema 
    	move $a0, $t0		#Regresa el contenido a $a0
.end_macro

#Macro para terminar el programa con una llamada a sistema
.macro end()
	li 	$v0, 10	 	#Prepara para terminar la ejecución
	syscall 		#Termina ejecución con llamada al sistema 
.end_macro

#Macro para leer un entero de la terminal y lo guarda en %rd
.macro read_int(%rd)
	li $v0,5 		#Prepara a leer un entero
	syscall  		#Lee entero con llamada al sistema
	move %rd $v0		#Guarda en el registro %rd el valor del registro ubicado en $v0
.end_macro
#Macro para imprimir un entero
.macro print_int(%rs)
	move $t1 %rs
	li $v0 1 		#Prepara para imprimir un entero
	move $a0, $t1  		
	syscall 		#Llamada al sistema para imprimir dicho entero
.end_macro
#Marco para dar el preambulo de cf_binomial como rutina invocada
.macro pre_cf_binomial_0()
	addi 	$sp, $sp, -16	#Guarda espacio en la pila de 16 bytes
	sw	$a1, 8($sp)	#Guarda el valor de k
	sw 	$a0, 4($sp)	#Guarda el valor de n
	sw 	$ra, 0($sp)	#Guarda la direccion de retorno
.end_macro

#Macro para dar la conclusion de cf_binomial como rutina invodada
.macro con_cf_binomial_0()
	lw 	$ra, 0($sp)	#Restaura de la pila la direccion de retorno
	addi 	$sp, $sp, 16	#Limpia de la pila 16 bytes
	jr 	$ra		#Regresa el control a donde fue llamado
.end_macro

#Marco para dar el preambulo de cf_binomial_1 como rutina invocada
.macro pre_cf_binomial_1()
	subi  	$a0, $a0, 1	#Resta 1 a n
	subi  	$a1, $a1, 1	#Resta 1 a k
.end_macro
#Macro para dar la conclusion de cf_binomial_1 como rutina invodada
.macro con_cf_binomial_1()
	lw 	$a1, 8($sp)	#Restaura el valor de k
	lw 	$a0, 4($sp)	#Restaura el valor de n
	sw	$v0, 12($sp)	#Guarda el resultado de C(n-1, k-1)
.end_macro
#Marco para dar el preambulo de cf_binomial_2 como rutina invocada
.macro pre_cf_binomial_2()
	subi  	$a0, $a0, 1	#Se resta 1 a n
.end_macro
#Macro para dar la conclusion de cf_binomial_2 como rutina invodada
.macro con_cf_binomial_2()
	lw 	$t0, 12($sp)	#Restaura el valor de C(n-1, k-1) 
.end_macro

#Macro para invocar la subrutina cf_binomial
.macro inv_cf_binomial()
	jal cf_binomial 	#Salto ligado a subrutina cf_binomial	
.end_macro

#Macro para ver si el caso_base_1 se cumple 
.macro caso_base_1(%n, %k)
	sge $t0, %n, $zero	#Si n es mayor o igual a cero se guarda uno en $t0 si no se guarda cero
	seq $t1, %k, $zero	#Si k es cero guarda 1 en $t1 de lo contrario guarda 0 
	add $t2, $t0, $t1	#Si $t1 y $t2 son cietrtos (1) en $t2 se guarda 2
	beq $t2, 2, base_1	#Si $t2 es igual a 2 se ejecuta la subrutina base_1
.end_macro

#Macro para ver si el caso_base_2 se cumple 
.macro caso_base_2(%n, %k)
	seq $t0, %n, $zero	#Si n es igual a 0 guarda un uno en $t0 de no serlo guarda en cero
	sgt $t1, %k, $zero	#Si k es cero guarda un uno en $t1 de no serlo guarda cero
	add $t2, $t0, $t1	#Si $t1 y $t2 son cietrtos (1) en $t2 se guarda 2
	beq $t2, 2, base_2	#Si $t2 es igual a 2 se ejecuta la subrutina base_2
.end_macro


.text 
.globl main

main:
	print_str(first_msg)	#Imprime el primer mensaje 
	read_int($a0)		#Recibe n
	print_str(second_msg)	#Imprime segundo mensaje
	read_int($a1)		#Recibe k
	inv_cf_binomial()	#Calcula en $v0 el coefieciente binomial de n en k
	print_int($v0)		#Imprime el coeficiente binomial deseado
	end()			#Finaliza la ejecucion del programa


cf_binomial:
	pre_cf_binomial_0()	#Preambulo para calcular C(n, k)
	caso_base_1($a0, $a1)	#Verifica si se cumple el caso base 1
	caso_base_2($a0, $a1)	#Valida si se cumple el caso base 2
	pre_cf_binomial_1()	#Preambulo a la invocacion de C(n-1, k-1)
	inv_cf_binomial()	#Invoca  C(n-1, k-1)
	con_cf_binomial_1()	#Conclusion de la invocacion de C(n-1, k-1)
	move 	$t0, $v0	#Guardam el contenido de $v0 en un registro temporal $t0
	pre_cf_binomial_2()	#Preambulo a la invocacion de C(n-1, k)
	inv_cf_binomial()	#Invoca C(n-1, k)
	con_cf_binomial_2()	#Conclusion de la invocacion de C(n-1, k)
	add 	$v0, $v0, $t0	#Regresa C(n, k) = C(n-1, k-1) + C(n-1, k)
	j 	return		#Salto a subrutina return


return:
	con_cf_binomial_0()	#Conclusion del procedimiento.
	

base_1:	
	li 	$v0, 1		#Guarda uno como el resultado
	j 	return		#Salto a subrutina return
	

base_2:	
	li 	$v0, 0		#Guarda cero como el resultado
	j 	return		#Salto a subrutina return

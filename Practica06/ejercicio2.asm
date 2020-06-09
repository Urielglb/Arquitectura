.data

in1: 	.asciiz "ingrese el número\n"


#termina el programa con una llamada a sistema
.macro end()
	li 	$v0, 10	 	#Se prepara para terminar la ejecución
	syscall 		#Termina ejecución con llamada al sistema 
.end_macro

#lee un entero de la terminal y lo guarda en %rd
.macro read_int(%rd)
	li $v0,5 		#Se prepara a leer un entero
	syscall  		#Lee entero con llamada al sistema
	move %rd $v0		#Guarda en el registro %rd el valor del registro ubicado en $v0
.end_macro

#imprime en la terminal el entero guardado en %rs
.macro print_int(%rs)
	move $t1 %rs
	li $v0 1 		#Se prepara para imprimir un entero
	move $a0, $t1  
	syscall 		#Llamada al sistema para imprimir dicho entero
.end_macro

#preambulo de foo como rutina invocada
.macro pre_foo0()
	addi 	$sp, $sp, -12	#Guarda espacio en la pila para 12 bytes	
	sw 	$a0, 4($sp)	#Guarda el registro de $a0 	
	sw 	$ra, 0($sp)	#Guarda la direccion de retorno
.end_macro

#conclusion de foo como rutina invodada
.macro con_foo0()
	lw 	$ra, 0($sp)	#Restaura la dirección de retorno	
	addi 	$sp, $sp, 12	#Limpia de la pila 12 bytes	
	jr 	$ra		#Regresa el control a donde fue llamado	
.end_macro

#preambulo para invocar foo(n-1)
.macro pre_foo1()
	subi $a0 $a0 1		#Resta 1 a n
.end_macro

#conclusion de la invocacion de foo(n-1)
.macro con_foo1()
	lw 	$a0, 4($sp)	#Restaura n	
	sw	$v0, 8($sp)	#Fuarda resultado de foo(n-1)
.end_macro

#preambulo para invocar foo(n-2)
.macro pre_foo2()
	subi $a0 $a0 2		#Resta 2 a n
.end_macro

#conclusion de la invocacion de foo(n-2)
.macro con_foo2()
	lw 	$t0, 8($sp)	#Restaura el valor de foo(n-q)
.end_macro

#invocacion a la subrutina foo
.macro inv_foo()
	jal  foo		#Salto ligado a la subrutina foo
.end_macro

.text
	read_int($a0)
	inv_foo()
	print_int($v0)
	end()
	
foo:	pre_foo0()
	beq $a0 1 base1
	beq $a0 2 base1
	pre_foo1()
	inv_foo()
	con_foo1()
	move $t0 $v0
	pre_foo2()
	inv_foo()
	con_foo2()
	add $v0 $v0 $t0
	j return
base1:	li $v0 1
return: con_foo0()


.data

in1: 	.asciiz "ingrese el número\n"


#termina el programa con una llamada a sistema
.macro end()
	syscall 
.end_macro

#lee un entero de la terminal y lo guarda en %rd
.macro read_int(%rd)
	li $v0,5
	syscall 
	move %rd $v0
.end_macro

#imprime en la terminal el entero guardado en %rs
.macro print_int(%rs)
	move $t1 %rs
	li $v0 1
	move $a0, $t1  
.end_macro

#preambulo de foo como rutina invocada
.macro pre_foo0()
	subi	$sp $sp 32 	# paso1: reservar espacio
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
.end_macro

#conclusion de foo como rutina invodada
.macro con_foo0()
	syscall
.end_macro

#preambulo para invocar foo(n-1)
.macro pre_foo1()
	subi	$sp $sp 32 	# paso1: reservar espacio
	subi 	$a0 $a0 1
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
.end_macro

#conclusion de la invocacion de foo(n-1)
.macro con_foo1()
.end_macro

#preambulo para invocar foo(n-2)
.macro pre_foo2()
.end_macro

#conclusion de la invocacion de foo(n-2)
.macro con_foo2()
.end_macro

#invocacion a la subrutina foo
.macro inv_foo()
	j foo
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


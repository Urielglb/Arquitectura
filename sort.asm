.data
	arr: .space 64
	n:	.asciiz "\n"
	nArr: .asciiz "ingrese el numero de elementos en el arreglo\n"
	ingArr: .asciiz "ingrese los elementos del arreglo\n"
	fin: .asciiz "numeros ordenados"
.text

#lee int
.macro read_int(%in)
	li $v0, 5
	syscall
	move %in $v0
.end_macro 

#imprime cadena de registro
.macro print_str(%r)
	li $v0 4
	la $a0, %r 
    	syscall
.end_macro

#imprime int
.macro print_int(%out)
	li $v0 1
	move $a0, %out  
    	syscall
.end_macro


#es lo mismo que %v = %arr[%i]
.macro get (%arr, %i, %v)	
	add $t6 $zero %i
	mul $t7 $t6 8
	lw %v %arr($t7)
.end_macro


# generic looping mechanism
.macro for (%regIterator, %from, %to, %label)
	add %regIterator, $zero, %from
	Loop:
		jal %label
	add %regIterator, %regIterator, 1
	blt %regIterator, %to, Loop
.end_macro


j main #brinco a main para saltarse las definiciones 

#definiciones
outer_loop: 
	subi	$sp $sp 32 	# paso1: reservar espacio(no hay paso2)
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
	
	for($t1, $t0, $s0, inner_loop) #for desde t0 hasta s0, el cuerpo es inner_loop

	lw	$ra 16($sp)
	lw	$fp 20($sp)
	addi	$sp $sp	32
	jr	$ra
	
inner_loop:
	subi	$sp $sp 32 	# paso1: reservar espacio(no hay paso2)
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
		
	get(arr, $t0, $t2)
	get(arr, $t1, $t3)
	
	ble $t2 $t3  if_end #si t1->t3 es menor que t0-t2 cambialos
	
	mul $t4 $t0 8 # calculamos el indice de guardado
	sw $t3 arr($t4) #lo guardamos en el arreglo
	mul $t4 $t1 8 # calculamos el indice de guardado
	sw $t2 arr($t4) #lo guardamos en el arreglo

if_end:
	
	lw	$ra 16($sp)
	lw	$fp 20($sp)
	addi	$sp $sp	32
	jr	$ra
	
read_int: 
	read_int($t1) #leemos int
	mul $t2 $t0 8 # calculamos el indice de guardado
	sw $t1 arr($t2) #lo guardamos en el arreglo
	
	jr	$ra

print_int:
	get(arr, $t0, $t1)
	print_int($t1)
	print_str(n)
	jr	$ra

main:

print_str(nArr)
read_int($s0) # leemos el tamaño del arreglo

print_str(ingArr)
for($t0, 0, $s0, read_int)


print_str(n)
print_str(fin)
for($t0, 0, $s0, outer_loop) # iniciamos el  for loop con el outer_loop de cuerpo
for($t0, 0, $s0, print_int)
	









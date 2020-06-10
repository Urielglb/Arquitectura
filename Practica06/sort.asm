.data
	arr: .space 64
	n:	.asciiz "\n"
	nArr: .asciiz "ingrese el numero de elementos en el arreglo\n"
	ingArr: .asciiz "ingrese los elementos del arreglo\n"
	fin: .asciiz "numeros ordenados"
.text

#lee int
.macro read_int(%in)
	li $v0, 5 # guardamos valor para leet int
	syscall #llamada al sistema
	move %in $v0 # guardamos el valor en %in
.end_macro 

#imprime cadena de registro
.macro print_str(%r) 
	li $v0 4 # guardamos valor para imprimir cadena
	la $a0, %r #guardamos el argumento a imprimir
    	syscall # llamada al sistema
.end_macro

#imprime int
.macro print_int(%out)
	li $v0 1 #guardamos en el valor para imprir un int
	move $a0, %out  # guardamos el int  a imprimir
    	syscall #llamada al sistema
.end_macro


#es lo mismo que %v = %arr[%i]
.macro get (%arr, %i, %v)	
	add $t6 $zero %i # guardamos el valor del inidice para poder utilizarlo sin que nos importe si es un registro o una literal
	mul $t7 $t6 8 # multipicamos el indice por 8 (1 byte) para poder encontrar la localidad del valor que nos interesa
	lw %v %arr($t7) #guardamos el valor del indice
.end_macro


# generic looping mechanism
.macro for (%regIterator, %from, %to, %label)
	add %regIterator, $zero, %from #inicializamos el iterador
	Loop: #deinimos la etiqueta a la que volveremos
		jal %label # salto a la etiqueta del cuerpo del loop
	add %regIterator, %regIterator, 1 #avnzamos el iterador
	blt %regIterator, %to, Loop #checamos si debemos  iterar una vez mas
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
	jr	$ra #regresamos el control
	
inner_loop:
	subi	$sp $sp 32 	# paso1: reservar espacio(no hay paso2)
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
		
	get(arr, $t0, $t2) # conseguimos el valor del arreglo del indice $t0
	get(arr, $t1, $t3) # conseguimos el valor del arreglo del indice $t1
	
	ble $t2 $t3  if_end #si t1->t3 es menor que t0-t2 cambialos
	
	mul $t4 $t0 8 # calculamos el indice de guardado
	sw $t3 arr($t4) #lo guardamos en el arreglo
	mul $t4 $t1 8 # calculamos el indice de guardado
	sw $t2 arr($t4) #lo guardamos en el arreglo

if_end:
	
	lw	$ra 16($sp)
	lw	$fp 20($sp)
	addi	$sp $sp	32
	jr	$ra #regresamos el control
	
read_int: 
	read_int($t1) #leemos int
	mul $t2 $t0 8 # calculamos el indice de guardado
	sw $t1 arr($t2) #lo guardamos en el arreglo
	
	jr	$ra #regresamos el control

print_int:
	get(arr, $t0, $t1) # conseguimos el valor del arreglo del indice $t1
	print_int($t1) # imprimmos el valor
	print_str(n) # imprimimos salto de linea
	jr	$ra #regreasmos el control

main:

print_str(nArr) # preguntamos al usuario el tamaño del arreglo
read_int($s0) # leemos el tamaño del arreglo

print_str(ingArr) # preguntamos por el arreglo
for($t0, 0, $s0, read_int) #leemos los ints


print_str(n) # imprimimos un salto se linea
print_str(fin) # imprimimos un separador sencillo para separar entrada de salida
for($t0, 0, $s0, outer_loop) # iniciamos el  for loop con el outer_loop de cuerpo, el ordenado
for($t0, 0, $s0, print_int) # imprimimos el arreglo ordenado
	









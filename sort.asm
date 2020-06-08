.data
	arr: .space 32
	n:	.asciiz "\n"
.text

.macro read_int(%in)
	li $v0, 5
	syscall
	move %in $v0
.end_macro 

.macro print_str(%r)
	li $v0 4
	la $a0, %r 
    	syscall
.end_macro

.macro print_int(%out)
	li $v0 1
	move $a0, %out  
    	syscall
.end_macro

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


j main
#definitions
outer_loop: 
	subi	$sp $sp 32 	# paso1: reservar espacio(no hay paso2)
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
	
	for($t4, $t0, $t1, inner_loop)

	lw	$ra 16($sp)
	lw	$fp 20($sp)
	addi	$sp $sp	32
	jr	$ra
	
inner_loop:
	subi	$sp $sp 32 	# paso1: reservar espacio(no hay paso2)
	sw	$ra 16($sp)	# paso3: guardar direccion de retorno
	sw	$fp 20($sp)	# paso4: guardar fp
	
	get(arr, $t0, $t5)
	print_int($t5)
	get(arr, $t4, $t5)
	print_int($t5)
	print_str(n)
	
	lw	$ra 16($sp)
	lw	$fp 20($sp)
	addi	$sp $sp	32
	jr	$ra

main:

read_int($t1)

addi $t2 $zero 0
read_int: beq $t1 $t2 start_ordering
	read_int($s0)
	mul $t3 $t2 8
	sw $s0 arr($t3)
	add $t2 $t2 1
	j read_int
	


start_ordering: addi $t2 $zero 0
		addi $t3 $zero 0
ordering:
	for($t0, 0, $t1, outer_loop)
	print_int($t0)
	
#	beq $t1 $t2 end
#	j inner_loop
#	addi $t2 $t2 1
#	
#inner_loop: beq $t1 $t3 $ra
#	addi $t3 $t3 1
#	
#
#end








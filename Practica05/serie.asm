.data
	in1: .asciiz "Ingrese m\n"
	f4: .float 4
	f1: .float 1
	f3: .float 3
	f0: .float 0
	
.text

.macro read_int(%in)
	li $v0, 5
	syscall
	move %in $v0
.end_macro 
.macro read_flt(%in)
	li $v0, 6
	syscall
	mov.s %in $f0
.end_macro 

.macro print_str(%r)
	li $v0 4
	la $a0, %r  # load desired value into argument register $a0, using pseudo-op
    	syscall
.end_macro

.macro print_int(%out)
	li $v0 1
	move $a0, %out  
    	syscall
.end_macro
.macro print_flt(%out)
	mov.s $f0 $f12
	li $v0 2
	mov.s $f12, %out  
    	syscall
    	mov.s $f12 $f0
.end_macro

lwc1 $f4 f4
lwc1 $f10 f0
lwc1 $f1 f1
lwc1 $f3 f3

	
print_str(in1) 
read_flt($f11)
lwc1 $f12 f0

while: c.lt.s $f10 $f11
	bc1f end	
	sub.s $f11 $f11 $f1
	
	mul.s $f13 $f4 $f11
	add.s $f14 $f13 $f1
	add.s $f15 $f13 $f3
	
	div.s $f14 $f1 $f14
	div.s $f15 $f1 $f15
	
	sub.s $f13 $f14 $f15
	add.s $f12 $f12 $f13
		
	j while
end:
mul.s $f12 $f12 $f4
print_flt($f12)
 
 

#


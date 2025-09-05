#402106359
#402106723

.data
.align 0
	str_input: .space 64
	zero_ascii: .byte '0'
	yes_str: .asciiz "YES"
	no_str: .asciiz "NO"
.text
.globl main
main:
	la $a0, str_input
	li $a1, 64
	li $v0, 8
	syscall
	li $t0, 1
	li $t7, -1
	li $t1, 8
	li $t2, 8
	la $s0, str_input
	la $s1, zero_ascii
	lb $s1, 0($s1)
	li $s2, 0 #take out the number
loop:	
	subi $t1, $t1, 1
	beq $t1, $t7, calculate_length
	add $t3, $s0, $t1
	lb $t4, 0($t3)
	sub $t4, $t4, $s1
	mul $t9, $t0, $t4
	add $s2, $s2, $t9
	sll $t0, $t0, 1
	j loop
	
calculate_length:
	li $t0, 10
	div $t1, $s2, $t0
	beq $t1, $zero, set_length_1
	li $t0, 100
	div $t1, $s2, $t0
	beq $t1, $zero, set_length_2
	j set_length_3 
	
set_length_1:
	li $s1, 1
	j calculate_Psum
set_length_2:
	li $s1, 2
	j calculate_Psum
set_length_3:
	li $s1, 3
calculate_Psum:
	# $s1 = length
	# $s2 = number in decimal
	li $t9, 100
	div $t0, $s2, $t9

	div $t1, $s2, $t9
	mul $t1, $t1, $t9
	sub $t1, $s2, $t1
	li $t9, 10
	div $t1, $t1, $t9

	div $t2, $s2, $t9
	mul $t2, $t2, $t9
	sub $t2, $s2, $t2
	
	li $t5, 3
	beq $t5, $s1, pow3
	li $t5, 2
	beq $t5, $s1, pow2
	j result
	
pow3:
	mul $t5, $t1, $t1
	mul $t1, $t1, $t5
	mul $t5, $t0, $t0
	mul $t0, $t0, $t5
	mul $t5, $t2, $t2
	mul $t2, $t2, $t5
	j result

pow2:
	mul $t0, $t0, $t0
	mul $t1, $t1, $t1
	mul $t2, $t2,$t2
	
result:
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	beq $t0, $s2, print_yes
	la $a0, no_str
	li $v0, 4
	syscall
	j end

print_yes:
	la $a0, yes_str
	li $v0, 4
	syscall

end:
	li $v0,10
	syscall

#402106359
#402106723

.data
	first_poly: .space 400
	second_poly: .space 400
	cross:	.word 0:200
	x_amount: .asciiz "x^"
	plus: .asciiz "+"
	minus: .asciiz "-"
	input: .asciiz "Input:\n"
	output: .asciiz "Output:\n"
	input_introduction: .asciiz "This input represents "
	forward: .asciiz "("
	backward: .asciiz ")"
	enter: .asciiz "\n"
.text
.globl main
main:
	la $a0, input
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0 #degree of first poly is in $t0
	la $s0, first_poly
	sll $t0, $t0, 2
	add $s0, $s0, $t0
	srl $t0, $t0, 2
	addi $t1, $t0, 2
	addi $s0, $s0, 4
input1:
	subi $t1, $t1, 1
	subi $s0, $s0, 4
	beq $t1, $zero, exit_input1
	li $v0, 5
	syscall
	sw $v0, 0($s0)
	j input1

exit_input1:
	li $v0, 5
	syscall 
	move $t1, $v0 #degree of second polu is in $t1
	la $s0, second_poly
	sll $t1, $t1, 2
	add $s0, $s0, $t1
	srl $t1, $t1, 2
	addi $t2, $t1, 2
	addi $s0, $s0, 4
	
input2:
	subi $t2, $t2, 1
	subi $s0, $s0, 4
	beq $t2, $zero, introduce_input
	li $v0, 5
	syscall
	sw $v0, 0($s0)
	j input2
	
	
introduce_input:
	la $a0, input_introduction
	li $v0, 4
	syscall
	la $a0, forward
	li $v0, 4
	syscall
	
	
	subi $sp, $sp, 40
	sw $t0, 36($sp)
	sw $t1, 32($sp)
	sw $t2, 28($sp)
	sw $t3, 24($sp)
	sw $t4, 20($sp)
	sw $t5, 16($sp)
	sw $t6, 12($sp)
	sw $t7, 8($sp)
	sw $t8, 4($sp)
	sw $t9, 0($sp)
	
	addi $a0, $t0, 1
	la $a1, first_poly
	jal print_poly_function
	
	lw $t0, 36($sp)
	lw $t1, 32($sp)
	lw $t2, 28($sp)
	lw $t3, 24($sp)
	lw $t4, 20($sp)
	lw $t5, 16($sp)
	lw $t6, 12($sp)
	lw $t7, 8($sp)
	lw $t8, 4($sp)
	lw $t9, 0($sp)
	
	addi $sp, $sp, 40
	
	la $a0, backward
	li $v0, 4
	syscall
	la $a0, forward
	li $v0, 4
	syscall
	
	subi $sp, $sp, 40
	sw $t0, 36($sp)
	sw $t1, 32($sp)
	sw $t2, 28($sp)
	sw $t3, 24($sp)
	sw $t4, 20($sp)
	sw $t5, 16($sp)
	sw $t6, 12($sp)
	sw $t7, 8($sp)
	sw $t8, 4($sp)
	sw $t9, 0($sp)
	
	addi $a0, $t1, 1
	la $a1, second_poly
	jal print_poly_function
	lw $t0, 36($sp)
	lw $t1, 32($sp)
	lw $t2, 28($sp)
	lw $t3, 24($sp)
	lw $t4, 20($sp)
	lw $t5, 16($sp)
	lw $t6, 12($sp)
	lw $t7, 8($sp)
	lw $t8, 4($sp)
	lw $t9, 0($sp)
	
	addi $sp, $sp, 40
	
	la $a0, backward
	li $v0, 4
	syscall
	la $a0, enter
	li $v0, 4
	syscall
	
start_calc:
	li $t3, -4 # t3 = i
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	sll $t0, $t0, 2
	sll $t1, $t1, 2
	la $s0, first_poly
	la $s1, second_poly
	la $s7, cross
loop1:	
	addi $t3, $t3, 4
	beq $t3, $t0, print_data
	li $t4, -4 #t4 = j
loop2:
	addi $t4, $t4, 4
	beq $t4, $t1, loop1
	add $s2, $s0, $t3
	add $s3, $s1, $t4
	lw $s2, 0($s2)
	lw $s3, 0($s3)
	mul $s2, $s2, $s3
	add $s6, $s7, $t3
	add $s6, $s6, $t4
	lw $s4, 0($s6)
	add $s4, $s2,$s4
	sw $s4, 0($s6)
	j loop2
print_data:
	la $a0, output
	li $v0, 4
	syscall
	
	srl $t0, $t0,2
	srl $t1, $t1,2
	add $t0, $t0, $t1
	subi $t0, $t0, 1
	move $a0, $t0
	la $a1, cross
	jal print_poly_function
	j end
	
	
print_poly_function:

	subi $sp, $sp, 40
	sw $a0, 36($sp)
	sw $a1, 32 ($sp)
	sw $ra, 28 ($sp)
	sw $s3 24($sp)
	sw $s5, 20($sp)
	move $t0, $a0

	li $t5, -1
	move $s3, $t0
	subi $s3, $s3, 1
final_loop:
	li $t5, -1
	addi $t0, $t0, -1
	beq $t0, $t5,end_func
	lw $s0, 32($sp)
	sll $t1, $t0, 2
	add $t1, $t1,$s0
	lw $a0,0($t1)
	move $t9, $a0 # a9 = the coefficent which we are printing
	beq $t9, $zero, final_loop
	slt $s5, $zero, $t9
	beq $s5, $zero, negative_coefficent
	beq $t0, $s3, negative_coefficent
	la $a0, plus
	li $v0, 4
	syscall

negative_coefficent:
	
	li $t8, 1
	beq $t9, $t8, end_print_coefficent
	li $t8, -1
	beq $t9, $t8, print_minus
	move $a0, $t9
	li $v0, 1
	syscall 
	j end_print_coefficent
	
print_minus:
	la $a0, minus
	li $v0,4
	syscall
	
end_print_coefficent:
	beq $t0, $zero, end_func
	la $a0, x_amount
	li $v0, 4
	syscall
	sub $a0, $t0, $t5
	subi $a0, $a0, 1
	li $v0, 1
	syscall
	j final_loop
end_func:
	# if the last coefficent is 1 print it:
	li $t0, 1
	bne $t9, $t0, go_back_to_ra
	li $a0, 1
	li $v0, 1
	syscall

go_back_to_ra:
	
	lw $a0, 36($sp)
	lw $a1, 32 ($sp)
	lw $ra, 28 ($sp)
	lw $s3 24($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 40
	jr $ra
	
end:
	li $v0, 10
	syscall

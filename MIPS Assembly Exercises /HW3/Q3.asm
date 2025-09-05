# 402106723 402106359

.text
.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 5
	syscall
	move $s0, $v0 # n
	la $s1, arr
	li $s2, 0
loop_start: # for receiving n numbers
	slt $t8, $s2, $s0
	beq $t8, $zero, loop_end
	li $v0, 5
	syscall
	sll $t9, $s2, 2
	add $t9, $t9, $s1
	sw $v0, 0($t9)
	addi $s2, $s2, 1
	j loop_start
loop_end:
	li $s2, 0
	li $s7, 0 # final answer
outer_loop_start:
	slt $t8, $s2, $s0
	beq $t8, $zero, outer_loop_end
	addi $s3, $s2, 1
	inner_loop_start:
		slt $t8, $s3, $s0
		beq $t8, $zero, inner_loop_end
		sll $t8, $s2, 2
		sll $t9, $s3, 2
		add $t8, $t8, $s1
		add $t9, $t9, $s1
		lw $a0, 0($t8)
		lw $a1, 0($t9)
		jal get_gcd
		addi $v0, $v0, -1
		bne $v0, $zero, else
		addi $s7, $s7, 1
	else:
		addi $s3, $s3, 1
		j inner_loop_start
	inner_loop_end:
	addi $s2, $s2, 1
	j outer_loop_start
outer_loop_end:
	li $v0, 1
	move $a0, $s7
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall

get_gcd:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sub $t4, $a0, $a1
	srl $t5, $t4, 31
	mul $t4, $t4, $t5
	sub $t6, $a0, $t4 # max($a0, $a1)
	add $t7, $a0, $a1
	sub $t7, $t7, $t6 # min($a0, $a1)
	beq $t7, $zero, zero_case
	div $t6, $t7
	mfhi $a0
	move $a1, $t7
	jal get_gcd
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
zero_case:
	move $v0, $t6
	addi $sp, $sp, 4
	jr $ra
	
.data
arr: .space 900
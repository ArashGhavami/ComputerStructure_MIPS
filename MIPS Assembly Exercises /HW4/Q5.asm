# 402106723 402106359

.text
.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $s0, str
	li $v0, 8
	move $a0, $s0
	li $a1, 20
	syscall
	li $s1, 0 # length of the string
	move $t0, $s0
count_loop: # to calculate the length of the string
	lb $t1, 0($t0)
	li $t2, 1
	slti $t3, $t1, 58
	and $t2, $t2, $t3
	li $t4, 47
	slt $t3, $t4, $t1
	and $t2, $t2, $t3
	beq $t2, $zero, end_count_loop
	addi $s1, $s1, 1
	addi $t0, $t0, 1
	j count_loop
end_count_loop:
	li $a0, 0
	move $a1, $s1
	jal check_palindrome
	move $a0, $v0
	li $v0, 1
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall
	
check_palindrome: # check being palindrome in [$a0, $a1) - buffer in $s0
	li $v0, 1
	addi $sp, $sp, -60
	sw $fp, 56($sp)
	addi $fp, $sp, 56
	sw $ra, -4($fp)
	sw $s1, -8($fp)
	sw $s2, -12($fp)
	sub $t0, $a1, $a0
	addi $t0, $t0, -2
	slt $t0, $t0, $zero
	bne $t0, $zero, last_part
	
	move $s1, $a0
	move $s2, $a1
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	jal check_palindrome
	add $t0, $s0, $s1
	add $t1, $s0, $s2
	addi $t1, $t1, -1
	lb $t0, 0($t0)
	lb $t1, 0($t1)
	beq $t0, $t1, last_part
	li $v0, 0
last_part:
	lw $ra, -4($fp)
	lw $s1, -8($fp)
	lw $s2, -12($fp)
	lw $fp, 56($sp)
	addi $sp, $sp, 60
	jr $ra
.data
str: .space 20
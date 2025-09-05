# 402106723 402106359

.text
.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 5
	syscall
	move $t0, $v0
	li $v0, 5
	syscall
	move $t1, $v0	
	li $v0, 5
	syscall
	move $t2, $v0
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	jal tak
	move $a0, $v0
	li $v0, 1
	syscall
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall
tak:
	addi $sp, $sp, -60
	sw $fp, 56($sp)
	addi $fp, $sp, 56
	sw $s0, -4($fp)
	sw $s1, -8($fp)
	sw $s2, -12($fp)
	sw $s5, -16($fp)
	sw $ra, -20($fp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	slt $t0, $zero, $a0
	bne $t0, $zero, second_case
	move $v0, $a1
	j last_part
second_case:
	slt $t0, $zero, $a1
	bne $t0, $zero, third_case
	move $v0, $a2
	j last_part
third_case:
	slt $t0, $zero, $a2
	bne $t0, $zero, fourth_case
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	jal tak
	j last_part
fourth_case:
	addi $a0, $s1, -1
	move $a1, $s2
	move $a2, $s0
	jal tak
	move $s5, $v0
	move $a0, $s1
	addi $a1, $s2, -1
	move $a2, $s0
	jal tak
	move $a2, $v0
	move $a1, $s5
	addi $a0, $s0, -1
	jal tak
	j last_part
last_part:
	lw $ra, -20($fp)
	lw $s5, -16($fp)
	lw $s2, -12($fp)
	lw $s1, -8($fp)
	lw $s0, -4($fp)
	lw $fp, 56($sp)
	addi $sp, $sp, 60
	jr $ra

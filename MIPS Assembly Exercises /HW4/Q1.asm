# 402106723 402106359

.text
.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 5
	syscall
	move $s0, $v0 # size of first string
	li $v0, 9
	addi $t0, $s0, 5
	move $a0, $t0
	syscall
	move $s2, $v0 # buffer of first string
	li $v0, 8
	move $a0, $s2
	move $a1, $t0
	syscall
	li $v0, 5
	syscall
	move $s1, $v0 # size of second string
	addi $t0, $s1, 5
	li $v0, 9
	move $a0, $t0
	syscall
	move $s3, $v0 # buffer of second string
	li $v0, 8
	move $a0, $s3
	move $a1, $t0
	syscall
	li $s4, 0
	move $s5, $s3 # second string counter
	li $s7, 0 # number of occurences
loop:
	addi $s4, $s4, 1
	slt $t0, $s4, $s0
	bne $t0, $zero, last_part
	move $a0, $s2
	move $a1, $s5
	jal check_equality
	addi $s5, $s5, 1
	add $s7, $s7, $v0
last_part:
	li $v0, 1
	move $a0, $s7
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	bne $s4, $s1, loop
exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall
		
check_equality: # check equality of strings in $a0 and $a1
	li $t0, 0
	li $v0, 1 # answer of subroutine
check_loop:
	add $t1, $t0, $a0
	add $t2, $t0, $a1
	lb $t1, 0($t1)
	lb $t2, 0($t2)
	beq $t1, $t2, continue
	li $v0, 0
	jr $ra
continue:
	addi $t0, $t0, 1
	bne $t0, $s0, check_loop
	jr $ra

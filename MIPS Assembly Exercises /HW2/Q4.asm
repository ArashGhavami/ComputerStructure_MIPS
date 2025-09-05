# 402106723 402106359

.text
.globl main
main:
	li $v0, 5
	syscall
	add $t0, $v0, $zero # if 0 -> sra, if 1 -> srav
	li $v0, 5
	syscall
	add $s0, $v0, $zero # number to be shifted
	li $s1, 6 # immediate shift amount
	beq $t0, $zero, L
	li $v0, 5
	syscall
	add $s1, $v0, $zero
	# now we implement (srav $s2, $s0, $s1)
L:
	srl $t4, $s0, 31 # sign bit
	sub $t0, $zero, $t4
	srlv $t1, $t0, $s1
	sub $t0, $t0, $t1
	srlv $t2, $s0, $s1
	or $s2, $t2, $t0
	
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 10
	syscall

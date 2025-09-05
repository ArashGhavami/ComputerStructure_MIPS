# 402106723 402106359

.text
.globl main
main:
	la $s0, A # A
	la $s1, B # B
	la $s2, N
	lw $s2, 0($s2) # n
	la $s3, M
	lw $s3, 0($s3) # m
	la $s4, P
	lw $s4, 0($s4) # p
	la $s5, ANS # ANS
	li $t0, 0
loop1_start: # n times
	slt $t8, $t0, $s2
	beq $t8, $zero, loop1_end
	li $t1, 0
	loop2_start: # p times
		slt $t8, $t1, $s4
		beq $t8, $zero, loop2_end
		li $t2, 0
		li $t3, 0 # sum of pairwise multiplications
		loop3_start: # m times
			slt $t8, $t2, $s3
			beq $t8, $zero, loop3_end
			
			mul $t4, $t0, $s3
			add $t4, $t4, $t2 # current index of A
			mul $t5, $t2, $s4
			add $t5, $t5, $t1 # current index of B
			sll $t4, $t4, 2
			sll $t5, $t5, 2
			add $t4, $t4, $s0
			add $t5, $t5, $s1
			lw $t4, 0($t4)
			lw $t5, 0($t5)
			mul $t6, $t4, $t5
			add $t3, $t3, $t6
			
			addi $t2, $t2, 1
			j loop3_start
		loop3_end:
		
		mul $t4, $t0, $s4
		add $t4, $t4, $t1 # current index of ANS
		sll $t4, $t4, 2
		add $t4, $t4, $s5
		sw $t3, 0($t4)	
		addi $t1, $t1, 1
		j loop2_start
	loop2_end:
	addi $t0, $t0, 1
	j loop1_start
loop1_end:
	li $v0, 10
	syscall
	
.data
N: .word 3
M: .word 2
P: .word 4
A: .word 1, 2, 3, 4, 5, 6
B: .word 8, 7, 6, 5, 4, 3, 2, 1
ANS: .space 1000
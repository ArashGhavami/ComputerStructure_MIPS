#402106359  402106723

.data
	array: .word 0, 0
	format: .asciiz " "
	format1: .asciiz "\n"
.text 
.globl main
main:
	la $s0, array
	li $v0, 5
	syscall
	move $t0, $v0
	li $v0, 5
	syscall
	move $t1, $v0
	li $v0, 5
	syscall
	move $t2, $v0
	
	sw $t0, 0($s0)
	sw $t1, 4($s0)
	sub $t3, $t1, $t0
	srl $t3, $t3, 31
	sll $t3, $t3, 2
	add $s0, $s0, $t3
	lw $t0, 0($s0) # min of t1 and t0 is here
	la $s0, array
	sub $t3, $zero, $t3
	li $t4, 4
	add $t3, $t3, $t4
	add $s0, $s0, $t3
	lw $t1, 0($s0) #max of t1 and t0 is here
	
	la $s0, array
	sw $t1, 0($s0)
	sw $t2, 4($s0)
	sub $t3, $t2, $t1
	srl $t3, $t3, 31
	sll $t3, $t3, 2
	add $s0, $s0, $t3
	lw $t1, 0($s0) # min of t1 and t0 is here
	la $s0, array
	sub $t3, $zero, $t3
	li $t4, 4
	add $t3, $t3, $t4
	add $s0, $s0, $t3
	lw $t2, 0($s0) #max of t1 and t0 is here
	
	
	la $s0, array
	sw $t0, 0($s0)
	sw $t1, 4($s0)
	sub $t3, $t1, $t0
	srl $t3, $t3, 31
	sll $t3, $t3, 2
	add $s0, $s0, $t3
	lw $t0, 0($s0) # min of t1 and t0 is here
	la $s0, array
	sub $t3, $zero, $t3
	li $t4, 4
	add $t3, $t3, $t4
	add $s0, $s0, $t3
	lw $t1, 0($s0) #max of t1 and t0 is here
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	la $a0, format
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	la $a0, format
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	la $a0, format1
	li $v0, 4
	syscall
	
	#printing reversed numbers
	
	srl $t3, $t2, 0
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 1
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 2
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 3
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 4
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 5
	and $a0, $t3, 1
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, format
	syscall
	
	srl $t3, $t1, 0
	and $a0, $t3, 1
	li $v0, 1
	syscall

	srl $t3, $t1, 1
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t1, 2
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t1, 3
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t1, 4
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 5
	and $a0, $t3, 1
	li $v0, 1
	syscall	
	
	li $v0, 4
	la $a0, format
	syscall
	
	
	srl $t3, $t0, 0
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t0, 1
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t0, 2
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t0, 3
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t0, 4
	and $a0, $t3, 1
	li $v0, 1
	syscall
	srl $t3, $t2, 5
	and $a0, $t3, 1
	li $v0, 1
	syscall
	
end:
	li $v0, 10
	syscall

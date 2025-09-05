#402106359
#402106723

.data
	format: .asciiz "\n"
.text
.globl main
main:
	li $v0, 5
	syscall
	move $a0, $v0 #a0 = n
	move $s0, $a0 #globally know the amount of n
	li $a1, 0  #a1 = number so far
	
	
	subi $sp, $sp, 16
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	
	jal generate_number

	lw $a1, 12($sp)
	lw $a0, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	
	addi $sp, $sp, 16
	
end:
	li $v0,10
	syscall
	

generate_number:
	subi $sp, $sp, 28
	sw $t1, 24($sp)
	sw $t0, 20($sp)
	sw $s1, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	beq $a0, $zero, print_num
	bne $a0, $s0, continue
	li $a1, 1
	subi $a0, $a0, 1
	jal generate_number
	
	li $a1, 0
	jal generate_number
	
	j end
	
continue:

	sll $t0, $a1, 31
	srl $t0, $t0, 31
	li $t1, 1
	beq $t0, $t1, handle_one
	
	move $s1, $a1
	sll $a1, $a1,1
	addi $a1, $a1, 1
	subi $a0, $a0, 1
	sw $s1, 0($sp)
	jal generate_number
	lw $s1, 0($sp)
	move $a1, $s1
	sll $a1, $a1, 1
	jal generate_number
	
	lw $t1, 24($sp)
	lw $t0, 20($sp)
	lw $s1, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 28
	jr $ra
	
handle_one:
	sll $a1, $a1, 1
	subi $a0, $a0, 1
	jal generate_number
	
	lw $t1, 24($sp)
	lw $t0, 20($sp)
	lw $s1, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 28
	jr $ra

print_num:

	move $t0, $s0
loop:
	subi $t0, $t0, 1
	srlv $a0, $a1, $t0
	sll $a0, $a0, 31
	srl $a0, $a0, 31
	li $v0,1
	syscall
	bne $t0, $zero, loop 

	la $a0, format
	li $v0, 4
	syscall

	lw $t1, 24($sp)
	lw $t0, 20($sp)
	lw $s1, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 28
	jr $ra

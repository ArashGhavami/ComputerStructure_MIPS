# 402106723 402106359

.text
.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $s0, 1 # capacity of current stack
	li $s1, 0 # number of elements currently in stack
	li $v0, 9
	li $a0, 4
	syscall
	move $s2, $v0 # points to the start of the stack
loop:
	li $v0, 8
	la $a0, buffer
	move $s3, $a0
	li $a1, 10
	syscall
	la $a1, psh_msg
	jal check_string_equality
	bne $v0, $zero, handle_push
	move $a0, $s3
	la $a1, pop_msg
	jal check_string_equality
	bne $v0, $zero, handle_pop
	move $a0, $s3
	la $a1, add_msg
	jal check_string_equality
	bne $v0, $zero, handle_add
	move $a0, $s3
	la $a1, sub_msg
	jal check_string_equality
	bne $v0, $zero, handle_sub
	move $a0, $s3
	la $a1, mul_msg
	jal check_string_equality
	bne $v0, $zero, handle_mul
	move $a0, $s3
	la $a1, ext_msg
	jal check_string_equality
	bne $v0, $zero, exit
handle_push:
	bne $s0, $s1, continue_push
	jal allocate_new_memory
continue_push:
	sll $t5, $s1, 2
	add $t5, $t5, $s2
	li $v0, 5
	syscall
	sw $v0, 0($t5)
	addi $s1, $s1, 1
	j loop
handle_pop:
	addi $s1, $s1, -1
	sll $t5, $s1, 2
	add $t5, $t5, $s2
	lw $t6, 0($t5)
	li $v0, 1
	move $a0, $t6
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	j loop
handle_add:
	sll $t5, $s1, 2
	add $t5, $t5, $s2
	addi $t5, $t5, -4
	lw $t6, 0($t5)
	addi $t5, $t5, -4
	lw $t7, 0($t5)
	add $t6, $t6, $t7
	sw $t6, 0($t5)
	addi $s1, $s1, -1
	j loop
handle_sub:
	sll $t5, $s1, 2
	add $t5, $t5, $s2
	addi $t5, $t5, -4
	lw $t6, 0($t5)
	addi $t5, $t5, -4
	lw $t7, 0($t5)
	sub $t6, $t7, $t6
	sw $t6, 0($t5)
	addi $s1, $s1, -1
	j loop
handle_mul:
	sll $t5, $s1, 2
	add $t5, $t5, $s2
	addi $t5, $t5, -4
	lw $t6, 0($t5)
	addi $t5, $t5, -4
	lw $t7, 0($t5)
	mul $t6, $t6, $t7
	sw $t6, 0($t5)
	addi $s1, $s1, -1
	j loop
exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall
	
check_string_equality: # addresses of buffers in $a0 and $a1
	move $t0, $a0
	move $t1, $a1
check_loop:
	lb $t3, 0($t0)
	lb $t4, 0($t1)
	beq $t3, $t4, continue
	li $v0, 0
	jr $ra
continue:
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	bne $t3, $zero, check_loop
	li $v0, 1
	jr $ra
	
allocate_new_memory: # doubles the capacity of stack
	sll $s0, $s0, 1 # capacity of stack is doubled
	li $v0, 9
	sll $a0, $s0, 2
	syscall
	move $t6, $v0 # newly allocated memory
	li $t5, 0
insert_loop:
	sll $t3, $t5, 2
	sll $t4, $t5, 2
	add $t3, $t3, $s2
	add $t4, $t4, $t6
	lw $t2, 0($t3)
	sw $t2, 0($t4)
	addi $t5, $t5, 1
	bne $t5, $s1, insert_loop
	move $s2, $t6 # pointer to the start of stack is updated
	jr $ra
.data
buffer: .space 10
psh_msg: .asciiz "psh\n"
pop_msg: .asciiz "pop\n"
add_msg: .asciiz "add\n"
sub_msg: .asciiz "sub\n"
mul_msg: .asciiz "mul\n"
ext_msg: .asciiz "ext\n"

#402106359
#402106723

.data
	array: .space 800
	format: .asciiz " "
.text
.globl main
main:
	li $v0, 5
	syscall
	move $t0, $v0 # $t0 = n
	li $t1, 0
	sll $t0, $t0, 2 # n = 4n
input:	
	beq $t0, $t1, continue
	li $v0, 5
	syscall
	la $s0,array
	add $s0, $s0, $t1
	sw $v0, 0($s0)
	addi $t1, $t1, 4
	j input
	
continue: 
	li $t1, -4
	la $s0, array
loop1:
	addi $t1, $t1, 4
	beq $t0, $t1, end_sort 
	move $t2, $t1
loop2:
	addi $t2, $t2, 4
	beq $t0, $t2,loop1
	add $t3, $s0, $t2
	add $t4, $s0, $t1
	lw $t6, 0($t3)
	lw $t7, 0($t4)
	slt $t5, $t7, $t6
	beq $zero, $t5, loop2
	sw $t6, 0($t4)
	sw $t7, 0($t3)
	j loop2

end_sort:
	li $t1, -4
	la $s2, format
print:
	addi $t1, $t1,4
	la $s0, array
	beq $t1, $t0, end
	add $s1, $s0, $t1
	lw $a0, 0($s1)
	li $v0, 1
	syscall
	li $v0, 4
	move $a0, $s2
	syscall
	j print
end:
	li $v0, 10
	syscall
	

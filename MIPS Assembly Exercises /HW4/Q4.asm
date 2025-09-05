#402106359
#402106723

.data
.align 0
	matrix: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
	rotated: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	format1: .asciiz " "
	format2: .asciiz "\n"
.text 
.globl main
main:
	li $t0, 4
	li $t1, -1
	la $s0, matrix
	la $s1, rotated
	la $s4, format1
	la $s5, format2
	
loop1: 
	move $a0, $s5
	li $v0, 4
	syscall
	addi $t1, $t1, 1
	beq $t1, $t0, end
	li $t2, -1
loop2:
	addi $t2, $t2, 1
	beq $t2, $t0, loop1
	sub $s2, $zero, $t2
	addi $s2, $s2, 3
	mul $s2, $s2, $t0
	add $s2, $s2, $t1
	add $s2, $s2, $s0
	lb $s2, 0($s2)
	mul $s3, $t0, $t1
	add $s3, $s3, $t2
	add $s3, $s3, $s1
	sb $s2, 0($s3)
	move $a0, $s2
	li $v0, 1
	syscall
	move $a0, $s4
	li $v0, 4
	syscall

	j loop2
	
end:
	li $v0, 10
	syscall
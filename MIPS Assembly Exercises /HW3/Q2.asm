#402106359
#402106723

.data
.text
.globl main
main:
	li $v0, 5
	syscall
	move $a0, $v0 #a
	li $v0, 5
	syscall 
	move $a1, $v0 #b
	
	sub $sp, $sp, 8
	sw $t0, 4($sp)
	sw $t1, 0($sp)
	jal power_calc
	lw $t0, 4($sp)
	lw $t1, 0($sp)
	add $sp, $sp, 4
	move $a0, $v0
	li $v0, 1
	syscall
	j end
	
power_calc:
	sub $sp, $sp, 12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	beq $zero, $a1, base
	li $s0, 1 #final result
	move $s1, $a0 #base
	
	loop:	slt $t0, $zero, $a1
		beq $t0, $zero, return_result
		andi $t0, $a1, 1
		li $t1, 1
		bne $t0, $t1, continue_loop
		mul $s0, $s0, $s1
		continue_loop:	
			mul $s1, $s1, $s1
			srl $a1, $a1, 1
			j loop
	
return_result:
	move $v0, $s0
	j exit

base:
	li $v0, 1
exit:
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	add $sp, $sp, 12
	jr $ra
	
end:
	li $v0, 10
	syscall 

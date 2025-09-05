# 402106723 402106359

.text
.globl main

main:
	sub $t0, $t1, $t2
	sub $t0, $t0, $t3 # $t1 - $t2 - $t3
	li $t4, 0x80000000	
	and $t4, $t4, $t0
	sub $t0, $t2, $t1
	sub $t0, $t0, $t3 # $t2 - $t1 - $t3
	and $t4, $t4, $t0
	sub $t0, $t3, $t1
	sub $t0, $t0, $t2 # $t3 - $t1 - $t2
	and $t4, $t4, $t0
	srl $t4, $t4, 31
	li $v0, 10
	syscall

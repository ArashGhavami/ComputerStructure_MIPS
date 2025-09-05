# 402106723 402106359

.macro convert_to_hex_byte %src
	addi $t9, %src, -10
	srl $t9, $t9, 31
	mul $t6, $t9, 48
	xori $t9, $t9, 1
	mul $t7, $t9, 97
	add $t6, $t6, $t7
	mul $t9, $t9, 10
	add $t6, $t6, %src
	sub $t6, $t6, $t9
.end_macro

.macro print_in_hex %src
	srl $t5, %src, 4
	convert_to_hex_byte $t5
	li $v0, 11
	add $a0, $zero, $t6
	syscall
	sll $t5, $t5, 4
	sub $t4, %src, $t5
	convert_to_hex_byte $t4
	li $v0, 11
	add $a0, $zero, $t6
	syscall
.end_macro

.macro receive_string
	lb $t0, 0($s0)
	subi $t0, $t0, 48
	sll $s1, $s1, 1
	or $s1, $s1, $t0
	addi $s0, $s0, 1
.end_macro

.macro print_binary_char 
	srlv $t0, $s0, $s1
	andi $t0, $t0, 1
	addi $t0, $t0, 48
	li $v0, 11
	add $a0, $zero, $t0
	syscall
	addi $s1, $s1, -1
.end_macro

.text
.globl main

main:
	la $a0, buffer
	li $a1, 8
	li $v0, 8
	syscall
	la $s0, buffer
	add $s1, $zero, $zero
	receive_string
	receive_string
	receive_string
	receive_string
	receive_string
	receive_string
	li $v0, 5
	syscall
	add $s0, $zero, $v0
	li $v0, 1
	add $a0, $zero, $s1
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	print_in_hex $s1
	li $v0, 11
	li $a0, 10
	syscall
	li $s1, 5
	print_binary_char
	print_binary_char
	print_binary_char
	print_binary_char
	print_binary_char
	print_binary_char
	li $v0, 11
	li $a0, 10
	syscall
	print_in_hex $s0
	li $v0, 10
	syscall
	
.data
buffer: .space 8

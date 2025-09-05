.macro enter size
	stmg	%r6, %r15, 48(%r15)
	lay	%r15, -(160+\size)(%r15)
.endm
.macro read_long
	enter	8
	larl	%r2, rif
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm
.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r15, 48(%r15)
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm
.macro read_string label
	enter	0
	larl	%r2, str_format
	larl	%r3, \label
	call	scanf
	leave	0
.endm
.macro check
	enter 0
	larl %r2, str_format
	larl %r3, hello
	call printf
	leave 0
.endm
.macro print_char
	enter	0
	larl	%r2, pcf
	call	printf
	leave	0
.endm
.macro print_str label
	enter 0	
	larl %r2, str_format
	larl %r3, \label
	call printf
	leave 0
.endm

.text
.global main
main:

loop:	
	read_string input_buffer
	
	larl %r2, input_buffer
	larl %r3, exit_command	
	enter 0
	call strcmp
	leave 0
	lgfi %r3, 0
	larl %r4, exit_func
	cgr %r2, %r3 
	bcr 8,%r4

	larl %r2, input_buffer
	larl %r3, create_command
	enter 0
	call strcmp
	leave 0
	larl %r4, create_func
	lgfi %r3, 0
	cgr %r2, %r3
	bcr 8, %r4
	
	larl %r2, input_buffer
        larl %r3, rename_command
        enter 0
        call strcmp
        leave 0
        larl %r4, rename_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4

	larl %r2, input_buffer
        larl %r3, read_command
        enter 0
        call strcmp
        leave 0
        larl %r4, read_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4

	larl %r2, input_buffer
        larl %r3, write_command
        enter 0
        call strcmp
        leave 0
        larl %r4, write_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4
	
	larl %r2, input_buffer
        larl %r3, mkdir_command
        enter 0
        call strcmp
        leave 0
        larl %r4, mkdir_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4

	larl %r2, input_buffer
        larl %r3, cd_command
        enter 0
        call strcmp
        leave 0
        larl %r4, cd_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4

	larl %r2, input_buffer
        larl %r3, time_command
        enter 0
        call strcmp
        leave 0
        larl %r4, time_func
        lgfi %r3, 0
        cgr %r2, %r3
        bcr 8, %r4


	larl %r2, loop
	br %r2

create_func:
	read_string input_buffer

	enter 160	
	larl %r2, current_address
	larl %r3, input_buffer
	call strcat
	leave 160

	enter 160
	larl %r3, file_mode_write
	larl %r2, current_address
	call fopen
	call fclose
	leave 160

	lghi %r10, 0
        larl %r8, current_address
length_finder:
        llc %r9, 0(%r8)
        ahi %r8,1
        ahi %r10, 1
        cgfi %r9, 0
        jne length_finder
        ahi %r10, -1

loop_find_last:
        larl %r11, current_address
        llc %r9, 0(%r11,%r10)
        lghi %r8, 47
        cr %r8, %r9
        je end_last
        lghi %r8, 0
	larl %r11, current_address
    	stc %r8, 0(%r10,%r11)
        cr %r8, %r10
        je end_last
	ahi %r10, -1
        j loop_find_last
end_last:
	print_str file_succession

	larl %r4, loop
	br %r4
rename_func:
	read_string input_buffer
	read_string input_buffer2	
	
	enter 160	
	larl %r2, current_address
	larl %r3, input_buffer
	call strcat
	leave 160
	enter 160
	larl %r2, second_address	
	larl %r3, input_buffer2
	call strcat	
	leave 160

	enter 0
	larl %r2, current_address
	larl %r3, second_address
	call rename
	leave 0

        lghi %r10, 0
        larl %r8, current_address
length_finder4:
        llc %r9, 0(%r8)
        ahi %r8,1
        ahi %r10, 1
        cgfi %r9, 0
        jne length_finder4
        ahi %r10, -1

loop_find_last4:
        larl %r11, current_address
        llc %r9, 0(%r11,%r10)
        lghi %r8, 47
        cr %r8, %r9
        je end_last4
        lghi %r8, 0
        larl %r11, current_address
        stc %r8, 0(%r10,%r11)
        cr %r8, %r10
        je end_last4
        ahi %r10, -1
        j loop_find_last4
end_last4:

        lghi %r10, 0
        larl %r8, second_address
length_finder5:
        llc %r9, 0(%r8)
        ahi %r8,1
        ahi %r10, 1
        cgfi %r9, 0
        jne length_finder5
        ahi %r10, -1

loop_find_last5:
        larl %r11, second_address
        llc %r9, 0(%r11,%r10)
        lghi %r8, 47
        cr %r8, %r9
        je end_last5
        lghi %r8, 0
        larl %r11, second_address
        stc %r8, 0(%r10,%r11)
        cr %r8, %r10
        je end_last5
        ahi %r10, -1
        j loop_find_last5
end_last5:

	print_str rename_succession
	
        larl %r4, loop
        br %r4
read_func:
	read_string input_buffer	
	read_long
	

	larl %r13, input_buffer2
	lgfi %r3, 0
	st %r2, 0(%r13, %r3)

	enter 160	
	larl %r2, current_address
	larl %r3, input_buffer
	call strcat
	leave 160
	
	enter 0
	larl %r2, current_address
	larl %r3, file_mode_read
	call fopen
	leave 0
	lr %r10, %r2
	
	larl %r3, input_buffer2
	lgfi %r13, 0
	l %r9, 0(%r13, %r3)	
	lgfi %r6, 1
	lgfi %r7, 0
	lgfi %r11, 0
	
	print_str read_succession	
	
	larl %r3, input_buffer2	 

 
loop_read:
	ahi %r11,1
	
	enter 160
	larl %r2, input_buffer2
	lr %r4, %r10
	lgfi %r3, 100
	call fgets
	leave 160

	enter 160
	larl %r2, str_format
	larl %r3, input_buffer2
	call printf
	leave 160
	cr %r11, %r9
	jne loop_read

	enter 160
	lr %r2, %r10
	call fclose
	leave 160

 	lghi %r10, 0
        larl %r8, current_address
length_finder1:
         llc %r9, 0(%r8)
         ahi %r8,1
         ahi %r10, 1
         cgfi %r9, 0
         jne length_finder1
         ahi %r10, -1

loop_find_last1:
        larl %r11, current_address
	llc %r9, 0(%r11,%r10)
        lghi %r8, 47
        cr %r8, %r9
         je end_last1
         lghi %r8, 0
         larl %r11, current_address
         stc %r8, 0(%r10,%r11)
         cr %r8, %r10
         je end_last1
         ahi %r10, -1
         j loop_find_last1
end_last1:
		

	larl %r4, loop
        br %r4
write_func:
        read_string input_buffer
	enter 0
	larl %r2, fgets_functionality
	larl %r3, input_buffer2
	call scanf
	leave 0

	enter 160	
	larl %r2, current_address
	larl %r3, input_buffer
	call strcat
	leave 160
	

        lghi %r10, 0
        larl %r8, input_buffer2
length_finder_write_input:
        llc %r9, 0(%r8)
        ahi %r8,1
        ahi %r10, 1
        cgfi %r9, 0
        jne length_finder_write_input
        ahi %r10, -1
	ahi %r10, -1	
	lgfi %r9, 0
	larl %r13, input_buffer2
	st %r9, 0(%r13, %r10)

	lghi %r9, 0
	larl %r7, input_buffer2
	ahi %r10, 1
remove_backslash_n:
	ahi %r9, 1
	llc %r8, 0(%r7, %r9)	
	cgfi %r8, 92
	jne cont
	llc %r8, 1(%r7, %r9)
	cgfi %r8, 110
	jne cont

	lghi %r13, 10
	stc %r13, 0(%r7, %r9)
	lghi %r13,0
	stc %r13, 1(%r7, %r9)	
	enter 0
	larl %r2, input_buffer2
	lr %r3, %r9
	ar %r3, %r7	
	aghi %r3, 2	
	call strcat
	leave 0	
cont:
	cr %r9, %r10
	jne remove_backslash_n

	enter 0	
	larl %r2, current_address
	larl %r3, file_mode_append
	call fopen
	leave 0
	lr %r6, %r2	
	
	enter 0
	larl %r3, input_buffer2	
	lgfi %r5, 1
	ar %r3, %r5
	call fprintf
	leave 0	
	
	enter 160
	lr %r2, %r6
	call fclose
	leave 160
	
	

        lghi %r10, 0
        larl %r8, current_address
length_finder2:
        llc %r9, 0(%r8)
        ahi %r8,1
        ahi %r10, 1
        cgfi %r9, 0
        jne length_finder2
        ahi %r10, -1

loop_find_last2:
        larl %r11, current_address
        llc %r9, 0(%r11,%r10)
        lghi %r8, 47
        cr %r8, %r9
        je end_last2
        lghi %r8, 0
        larl %r11, current_address
        stc %r8, 0(%r10,%r11)
        cr %r8, %r10
        je end_last2
        ahi %r10, -1
        j loop_find_last2
end_last2:

	print_str write_succession	
	
	larl %r4, loop
        br %r4
mkdir_func:
	read_string input_buffer
	
	larl %r2, mkdir
	lghi %r3, 0

	lghi %r4, 109
	stc %r4, 0(%r2, %r3)	
	lghi %r4, 107
	stc %r4, 1(%r2, %r3)
	lghi %r4, 100
	stc %r4, 2(%r2, %r3)	
	lghi %r4, 105
	stc %r4, 3(%r2, %r3)
	lghi %r4, 114
	stc %r4, 4(%r2, %r3)
	lghi %r4, 32
	stc %r4, 5(%r2, %r3)
	lghi %r4, 0
	stc %r4, 6(%r2, %r3)	
	enter 160
	
	larl %r2, mkdir
	larl %r3, current_address
	call strcat
	leave 160
	
	enter 160
        larl %r2, mkdir
        larl %r3, input_buffer
        call strcat
        leave 160
		

	enter 160
	larl %r2, mkdir
	call system
	leave 160


	print_str folder_succession


        larl %r4, loop
        br %r4
cd_func:
	read_string input_buffer

 	enter 160
        larl %r2, current_address
        larl %r3, input_buffer
        call strcat
        leave 160
	
	enter 160
	larl %r2, current_address
	larl %r3, slash
	call strcat
	leave 160

	enter 160
        larl %r2, second_address
        larl %r3, input_buffer
        call strcat
        leave 160

        enter 160
        larl %r2, second_address
        larl %r3, slash
        call strcat
        leave 160
	
	print_str cd_succession
	
        larl %r4, loop
        br %r4
time_func:
		
	print_str time_succession
	
	enter 160
	lghi %r2, 0
	call time
	leave 160
	
	lr %r10, %r2
	larl %r3, time_ptr
	lgfi %r4, 0
	stg %r10, 0(%r3, %r4)	



	enter 160
	lr %r3, %r10
	larl %r2, time_ptr
	call localtime
	leave 160
	lr %r11, %r2
	
	enter 160
	larl %r2, input_buffer	
	lgfi %r3, 100
	larl %r4, time_format
	lr %r5, %r11
	call strftime
	leave 160
	
	enter 0
	larl %r2, str_format
	larl %r3, input_buffer
	call printf 
	leave 0
	enter 0
	larl %r2, rif
	larl %r3, time_ptr
	leave 0

	print_str enter

        larl %r4, loop
        br %r4
exit_func:	
	lhi %r1, 93
        lhi %r2, 0
        svc 0
	
.data
        .align 8
        str_format: .asciz "%s"
        .align 8
        input_buffer: .space 100
        .align 8
	input_buffer2: .space 100
	.align 8
	create_command:	.asciz "create"
	.align 8
	rename_command: .asciz "rename"
	.align 8
	read_command: .asciz "read"
	.align 8
	write_command: .asciz "write"	
	.align 8
	mkdir_command: .asciz "mkdir"
	.align 8
	cd_command: .asciz "cd"
	.align 8
	time_command: .asciz "time"
	.align 8
	int_format: .asciz "%d"
	.align 8
	exit_command: .asciz "exit"
	.align 8
	hello: .asciz "hello\n"
	.align 8
	file_mode_write: .asciz "w"
	.align 8
	fgets_functionality: .asciz " %[^\n]"
	.align 8
	file_mode_append: .asciz "a"
	.align 8	
	pcf: .asciz "%c"
	.align 8
	rif: .asciz "%ld"
	.align 8
	file_mode_read: .asciz "r"
	.align 8
	.cur_address: .space 100
	.align 8
	mkdir: .asciz "mkdir "
	 .space 100
	.align 8
	null_amount: .asciz ""
	.align 8
	cd: .asciz "cd "
	.space 100
	.align 8
	pwd: .asciz "pwd"
	.align 8
	slash: .asciz "/"
	.align 8
	current_address: .asciz ""
	.align 8
	enter: .asciz "\n"
	.align 8
	char_format: .asciz "%c"
	.align 8	
	second_address: .space 100
	.align 8
	time_ptr: .quad 0
	.align 8
	time_format: .asciz "%H:%M:%S"
	.align 8
	file_succession: .asciz "File created successfuly!\n"
	.align 8
	folder_succession: .asciz "Directory created successfuly!\n"
	.align 8
	rename_succession: .asciz "File renamed successfuly!\n"
	.align 8	
	cd_succession: .asciz "Directory changed successfuly!\n"
	.align 8	
	read_succession: .asciz "Data in the file:\n"
	.align 8
	write_succession: .asciz "Data appended in the file successfuly!\n"
	.align 8
	time_succession: .asciz "Current time: "
	.align 8
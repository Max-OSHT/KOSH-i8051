varR equ 30h

org 00h
jmp main

org 30h
main:
	mov varR, #0
	;активация кнопок
	mov p1, #0
	mov p2, #0ffh
	mov p3, #03h
	
loop:
	jb p3.0, default
	jb p3.1, sswapp
	jb p3.2, input

	jmp loop
	
default:
	jb p3.0, $
	mov p1, #0
	mov varR, #0
	jmp loop
	
sswapp:
	jb p3.1, $
	mov a, varR
	swap a
	mov varR, a
	mov p1, #0
	mov p1, a
	jmp loop

input:
	jb p3.2, $
	mov a, p2
	mov varR, a
	mov p1, a
	jmp loop

sjmp $
end




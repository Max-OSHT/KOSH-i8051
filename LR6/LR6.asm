varX equ 30h
yl equ 31h
yh equ 32h
xl equ 33h
xh equ 34h
varYl equ 40h
varYh equ 41h

org 00h
jmp main

org 03h       ;прерывание int0
jmp input

org 13h       ;прерывание int1
jmp formula

org 30h
main:
        ;настройка
	mov dptr, #tab
	mov tcon, #5
	mov ie, #85h
	;активация
	mov p0, #0
 	mov p1, #0
  	mov p2, #0
   	mov p3, #0ffh

loop:
	mov a, p3
   	anl a, #243
    	add a, #0
    	jnz wheel
    	jmp loop

input:
	jb p3.2, $
	mov a, p3
	anl a, #243
	mov varX, a
	cpl f0
	reti

formula:
	jb p3.3, $
	;деление
	mov a, varX
	mov b, #2
	div ab
	mov xh, a
	mov xl, b
	;умножение
	mov a, yl
	mov b, #2
	mul ab
	mov yl, a
	mov a, yh
	mov b, #2
	mul ab
	mov yh, a
	;вычитание
	clr c
	mov a, xl
	subb a, yl
	mov varYl, a
	mov yl, a
        mov a, #0
	subb a, #0
	mov varYh, a
	;-------------
	clr c
	mov a, xh
	subb a, yh
	mov varYh, a
	mov yh, a
	;вывод
	mov a, varYl
	call stepOne
	call output
	mov a, varYh
	jz loop
	call stepOne
	call output
	reti

wheel:
	jb f0, loop
	mov r3, a
	call stepOne
	call output
	ljmp loop

output:
	;первый разряд
	mov a, r0
	movc a, @a+dptr
	mov p0, a
	;второй разряд
	mov a, r1
	movc a, @a+dptr
	mov p1, a
	;третий разряд
	mov a, r2
	movc a, @a+dptr
	mov p2, a
	ret

stepOne:
	mov b, #0ah
	div ab
	mov r0, b
	mov r1, a
	cjne r1, #0ah, point
point:  jnc stepTwo
	ret
stepTwo:mov a, r1
	mov b, #0ah
	div ab
	mov r2, a
	mov r1, b
	ret


sjmp $
tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h
;        0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
end




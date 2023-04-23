tx equ 30h

org 00h
jmp main

org 30h
main:
	;активация
	mov p0, #0
	mov p1, #0
	mov p2, #0
	mov p3, #0ffh
	;начальные значения
	mov r4, #50
	;настройка
	mov dptr, #tab
	mov sp, #100
	mov tmod, #1
	mov tl0, #low(7628h)
	mov th0, #high(7628h)
;---------------------------------
loop:
	jnb tr0, skip
	jnb tf0, $
	clr tf0
 	djnz r4, skip
 	mov r4, #50
        call timer
	jmp loop
;---------------------------------
skip:
	mov 24h, tcon
	jb p3.7, start
	jb p3.6, input
	jb f0, loop
	mov a, p3
	anl a, #0fh
	add a, #0
	jnz wheel
	jmp loop
;---------------------------------
timer:
	mov th0, #high(7628h)
	mov tl0, #low(7628h)
	mov a, tx
	jz loop
	dec a
	mov tx, a
	call stepOne
	ret
;---------------------------------
;пуск/стоп
start:
	jnb f0, loop
	jb p3.7, $
	cpl tr0
	jmp loop
;---------------------------------
;ввод
input:
	jb p3.6, $
	setb f0
	mov tx, r5
	jmp loop

;---------------------------------
;ацп
wheel:
	mov b, #7
	mul ab
	mov r5, a
	call stepOne
	mov r2, #0
	jmp loop

;---------------------------------
;индикация
stepOne:
	mov b, #0ah
	div ab
	mov r0, b
	mov r1, a
	cjne r1, #0ah, point
point:  jnc stepTwo
	jmp output
stepTwo:mov a, r1
	mov b, #0ah
	div ab
	mov r2, a
	mov r1, b
output:
	;первый разряд
	mov a, r0
	movc a, @a+dptr
	mov p0, a
	;второй разряд
	mov a, r1
	movc a, @a+dptr
	mov p1,a
	;третий разряд
	mov a, r2
	movc a, @a+dptr
	mov p2, a
	ret

tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh
;        0    1    2    3    4    5    6    7    8    9
end

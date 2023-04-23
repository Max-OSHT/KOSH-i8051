txl equ 30h
txh equ 31h

org 00h
jmp main

org 13h
jmp button

org 30h
main:
	mov sp, #100
	mov dptr, #tab
	;активация
	mov p0, #0
	mov p1, #0
	mov p2, #0
	mov p3, #00010000b
	;начальные значения
	mov r4, #7
	mov p0, #3fh
	mov p1, #3fh
	mov p2, #3fh
	mov tl0, #low(0FFF2EA6Bh)
	mov th0, #high(0FFF2EA6Bh)
        mov tl1, #low(0)
	mov th1, #high(0)
	;настройка
	mov tmod, #11h
	mov tcon, #44h
	mov ie, #84h

loop:
	setb tr0
	jnb tf0, $
	clr tf0
	clr tr0
	djnz r4, skip
	mov r4, #7
	call blink
	jmp loop
	
skip:
	jnb f0, loop
	call stepOne
	jmp loop
	
blink:
        mov tl0, #low(7828h)
	mov th0, #high(7828h)
	setb p3.0
	setb tr0
	setb tr1
	jnb tf0, $
	clr tf0
	clr tr0
	clr p3.0
	mov tl0, #low(0FFF2EA6Bh)
	mov th0, #high(0FFF2EA6Bh)
	ret
	
button:
        clr tr1
        mov txl, tl1
        mov txh, th1
       	mov tl1, #low(0)
	mov th1, #high(0)
	mov a, txh
	setb f0
	call stepOne
	clr f0
	ret
	
;индикация
stepOne:
	mov b, #10h
	div ab
	mov r0, b
	mov r1, a
	cjne r1, #10h, point
point:  jnc stepOne
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
	orl a, #80h
	mov p2, a
	ret

tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h, 80h
;        0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F    D
sjmp $
end

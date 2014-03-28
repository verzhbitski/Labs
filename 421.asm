include io.asm ;подключение операций ввода-вывода

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	X db 100 dup (?)
	Y db 26 dup (?)
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
; место для описания процедур

start:
	mov ax,data
	mov ds,ax
	
	mov bp, 0
L:	inch X[bp]	
	cmp x[bp], '.'
	je M				
	add bp, 1
	jmp L
M:	
	mov cx, bp
	mov bp, 0
G:  mov bl, x[bp]
	sub bl, 'a'
	add y[bx], 1
	inc bp
	loop G
	
	mov cx, 26
	mov dx, 0
	mov bx, 0
S:	cmp y[bx], 0
	je D
	inc dx
D:	inc bx
	loop S
	outint dx
    finish
code ends
    end start 

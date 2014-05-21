include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment

	nil equ 0
	heap_size equ 128
	two db 2

	list dw 8 dup (nil)
	
	buffer db 8 dup (' ')
	buffer_length dw (?)
	len dw 0
	
	f1 db '@       '
	f2 db '@@      '
	f3 db '@@@     '
	f4 db '@@@@    '
	f5 db '@@@@@   '
	f6 db '@@@@@@  '
	f7 db '@@@@@@@ '
	f8 db '@@@@@@@@'
	
data ends

node struc
	letter db 8 dup (' ')
	counter dw 1
	next dw (?)
node ends

heap segment
	heap_ptr dw (?)
			 db heap_size*(type node) dup (?)
heap ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

	
;-----------------------|Инициализация кучи(ССП)|-----------------------
init_heap proc far

	push SI
	push BX
	push CX
	
	mov CX, heap
	mov ES, CX
	
	mov CX, heap_size
	mov BX, nil
	mov SI, (heap_size - 1) * (type node) + 2
	
	init_heap_loop:
			mov ES:[SI].next, BX
			mov BX, SI
			sub SI, type node
			loop init_heap_loop
			
	mov ES:heap_ptr, BX
	
	pop CX
	pop BX
	pop SI
	
	ret
	
init_heap endp
;-----------------------------------------------------------------------


;--------------------|Выделение памяти|---------------------------------
new proc far

	mov DI, ES:heap_ptr
	cmp DI, nil
	je Empty_Heap
	push ES:[DI].next
	pop ES:heap_ptr
	ret
	
	Empty_Heap:
			lds DX, CS:aerr
			outstr
			newline
			finish
		aerr dd err
		err db 'Ошибка: исчерпание кучи!','$'
		
new endp
;-----------------------------------------------------------------------


;---------------------|Инициализация списков|---------------------------
init_list proc

	push BP
	push CX
	push BX
	
	mov BP, 0
	CLD
	
	irp f,<f1,f2,f3,f4,f5,f6,f7,f8>
		call new
		mov BX, DI
		mov CX, 8
		lea SI, f
		rep MOVSB
		mov AX, list[BP]
		mov ES:[BX].next, AX
		mov list[BP], BX
		add BP, 2
	endm
	
	pop BX
	pop CX
	pop BP

	ret
init_list endp
;-----------------------------------------------------------------------


;--------------------------|Сравнение слов|-----------------------------
compare proc
	
	push AX
	push BX
	push CX
	push SI
	
	mov CX, buffer_length
	mov BX, 0
	mov SI, 0
	compare_loop:
		mov AL, buffer[BX]
		cmp AL, ES:[BP].letter[SI]
		jg less
		jl great
		inc BX
		inc SI
		loop compare_loop
equal:
	mov DL, 0
	jmp end_compare
great:
	mov DL, 2
	jmp end_compare
less:
	mov DL, 1
end_compare:
	
	pop SI
	pop CX
	pop BX
	pop AX
	
	ret
compare endp
;-----------------------------------------------------------------------


;----------------------|Добавление слова в список|----------------------
add_word proc

	push AX
	push BX
	push BP
	push DX
	
	mov ax, buffer_length
	mul two
	sub ax, 2
	mov bx, ax
	mov BX, list[BX]
	mov BP, ES:[BX].next
add_start:
	cmp BP, nil
	je add_to
	mov SI, BP
	call compare
	cmp DL, 1
	jg add_to
	je no
	inc ES:[BP].counter
	jmp end_add
add_to:
	call new
	mov ES:[BX].next, DI
	mov ES:[DI].next, BP
	inc ES:[DI].counter
	mov CX, buffer_length
	lea SI, buffer
	rep MOVSB
	jmp end_add
no:
	mov BX, BP
	mov BP, ES:[BX].next
	jmp add_start
end_add:	
	pop DX
	pop BP
	pop DX
	pop AX

	ret
add_word endp
;-----------------------------------------------------------------------


;------------------------|Построения списка|----------------------------
build_list proc
	
	push AX
	push BX
	push CX

	mov BX, 0

build_list_cycle:
	push ES
	push DS
	pop ES
	lea DI, buffer
	mov AL, ' '
	mov CX, 8
	rep STOSB
	pop ES
	mov AX, 0
	mov buffer_length, AX
	mov BX, 0
	
new_letter:
	inch AL
	cmp AL, ','
	je addword
	cmp AL, '.'
	je addlastword
	inc buffer_length
	mov buffer[BX], AL
	inc BX
	jmp new_letter
	addword:
		call add_word
		jmp build_list_cycle
	addlastword:
		call add_word
		
	pop CX
	pop BX
	pop AX

	ret
build_list endp
;-----------------------------------------------------------------------


;-------------------------|Вывод списков|-------------------------------
print_list proc

	push DX
	
	mov DX, CX
	
start_print_list:
	mov BP, ES:[BP].next
	mov SI, 0
	mov CX, DX
	
	cmp BP, nil
	je end_print_list
print_list_loop:
	outch ES:[BP].letter[SI]
	inc SI
	loop print_list_loop
	outch ' '
	outch '('
	outint ES:[BP].counter
	outch ')'
	newline
	jmp start_print_list
end_print_list:	

	pop DX
	
	ret
print_list endp
;-----------------------------------------------------------------------


;-------------------------|Вывод|---------------------------------------
output proc

	push CX
	push BP
	
	mov CX, 0
output_cycle:
	inc CX
	mov BP, list[BX]
	add BX, 2
	call print_list
	cmp CX, 8
	jne output_cycle
	
	pop BP
	pop CX
	
	ret
output endp
;-----------------------------------------------------------------------
	
start:
	mov ax,data
	mov ds,ax
	
	mov ax,heap
	mov es,ax
	
	cld
	
	call init_heap
	call init_list
	call build_list
	call output
	
    finish
code ends
    end start 

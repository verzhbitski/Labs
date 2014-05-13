include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	
	input db 101 dup (?), '$'
	
	output db 101 dup (?), '$'
	
	StLength dw 0
	
	Message db 'Condition ', '$'
	
	condition dw (?)
	
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
	
	;////////////////////////////////////////////////
	; ��楤�� ����� ��ப� � ���ᨢ INPUT
	read proc
	
		push Ax
		push Bx
		
		mov Ax, 0
		mov Bx, 0
		
		STARTR:
			inch Al
			cmp Al, '.'
			je STOPR
			inc StLength
			mov input[Bx], Al
			inc Bx
			jmp STARTR
		STOPR:
			mov input[Bx], '$'
		
		pop Bx
		pop Ax
		
		ret
		
	read endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	;�஢�ઠ - ���� �� ���� ����让 ��⨭᪮� �㪢��
	isBigLatin proc
		
		cmp Al, 'Z'
		jg NotBig
		cmp Al, 'A'
		jl NotBig
		mov Al, 1
		jmp STOPC
	NotBig:
		mov Al, 0
	STOPC:	
		ret
		
	isBigLatin endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	; �஢�ઠ �᫮���
	; ������� �஢�ન �࠭���� � ��६����� CONDITION
	check proc
	
		push Ax
		push Bx
		push Cx
		
		mov Ax, 0
		mov Bx, StLength
		mov Cx, StLength
		dec Bx
		dec Cx
		
		mov Al, input[bx]
		call isBigLatin
		cmp Al, 1
		jne ChFalse
		mov Al, input[Bx]
		mov Bx, 0
	Cycle:
		cmp input[Bx], Al
		je ChFalse
		inc Bx
		loop Cycle
		
		mov condition, 1
		jmp StopCh
		
	ChFalse:
		mov condition, 2
	
	StopCh:
		
		pop Cx
		pop Bx
		pop Ax
		
		ret
	check endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	; �뢮� ���ᨢ� �� �ਬ������ �ࠢ��
	printB proc
		
		push Dx
		
		Lea Dx, input
		outstr
		newline
		
		pop Dx
		
		ret
	printB endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	; �뢮� ���ᨢ� ��᫥ �ਬ������ �ࠢ��
	printA proc
		
		push Dx
		
		Lea Dx, output
		outstr
		newline
		
		pop Dx
		
		ret
	printA endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	;	�८�ࠧ������ ���ᨢ� �� �ࠢ��� 1
	condition1 proc
		
		push Ax
		push Bx
		push Cx
		
		mov Ax, 0
		mov Bx, 0
		mov Cx, StLength
	
	ConCyc1:
		mov Al, input[bx]
		mov Ah, Al
		call isBigLatin
		cmp Al, 0
		je ConCyc1End
		sub Ah, 'A'
		neg Ah
		add Ah, 'Z'
	ConCyc1End:
		mov output[Bx], Ah
		inc Bx
		loop ConCyc1
		
		pop Cx
		pop Bx
		pop Ax
		ret
	condition1 endp
	;////////////////////////////////////////////////
	
	;////////////////////////////////////////////////
	;  	�८�ࠧ������ ���ᨢ� �� �ࠢ��� 2
	condition2 proc
		
		push Ax
		push Bx
		push Bp
		push Cx
		push Dx
		
		mov Bx, 0
		mov Bp, 0
		mov Cx, StLength
		dec Cx
		
		mov Al, input[Bx]
		mov output[Bp], Al
		mov Dl, input[Bx]
		inc Bx
		inc Bp
	ConCyc2:
		cmp Dl, input[Bx]
		je Equal
		mov Al, input[Bx]
		mov output[Bp], Al
		mov Dl, input[Bx]
		inc Bx
		inc Bp
		jmp Next
	Equal:
		inc Bx
	Next:	
		Loop ConCyc2
		
		pop Dx
		pop Cx
		pop Bp
		pop Bx
		pop Ax
		
		ret
	condition2 endp
	;////////////////////////////////////////////////
	
	
start:
	mov ax,data
	mov ds,ax
	
	call read
	call printB
	call check
	
	lea dx, message		;	��㦥���� ᮮ�饭��
	outstr				; 	
	outint condition	;	����� �᫮���
	newline				;
	
	cmp condition, 1
	jne Con2
	call condition1
	jmp Endr
Con2:
	call condition2
Endr:
	call printA
	
	
	
    finish
code ends
    end start 

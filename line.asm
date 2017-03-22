dseg segment
	startXSentence db "Please enter the line's starting X coordinate. Press Space when done.$"
	endXSentence db "Please enter the line's ending X coordinate. Press Space when done.$"
	startYSentence db "Please enter the line's starting Y coordinate. Press Space when done.$"
	endYSentence db "Please enter the line's ending Y coordinate. Press Space when done.$"
	ErrorMsg db "The coordinate you have entered is out of range, please enter a smaller number.$"
	verticalError db "Please enter a different ending X coordinate, the line cannot be vertical.$"
	startX dw ?
	endX dw ?
	startY dw ?
	endY dw ?
	deltaX dw ?
	deltaY dw ?
	lineError dw ?
	lineColor db 15
dseg ends

cseg segment
assume cs:cseg, ds:dseg

getValues proc
	mov bp, sp
	push bx ax cx

	mov cx, 0
	mov bl, 3
	WaitForInput:
		mov ah, 8
		int 21h
		cmp al, ' '
		jz endFunc
		cmp al, '9'+1
		jnc WaitForInput	;check if number inputted
		cmp al, '0'
		jc WaitForInput

		mov bh, al
		mov al, cl
		mov ah, 10
		mul ah
		mov cx, ax
		mov al, bh
		sub al, '0'
		add cl, al
		add al, '0'

		mov ah, 2
		mov dl, al
		int 21h

		dec bl
		jnz WaitForInput

	endFunc:
		cmp bl, 3
		jz WaitForInput
		mov [bp+4], cx
		pop cx ax bx
		ret 2
getValues endp

	Begin:
		mov ax, dseg
		mov ds, ax
	startDraw:
		mov ax, 3	;switch to text mode, for when drawing extra lines
		int 10h

		mov cx, 25
		mov ah, 2
		mov dl, 10

		ClearScreen:
			int 21h
			loop ClearScreen

		mov dl, 0
		mov dh, 0
		int 10h
		
		mov dx, offset startXSentence
	
	reqStartX:
		mov ah, 9
		int 21h
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		push 0
		call getValues
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		pop ax
		mov startX, ax
		mov dx, offset endXSentence
		cmp ax, 640
		jc reqEndX
		mov dx, offset ErrorMsg
		jmp reqStartX

	reqEndX:
		mov ah, 9
		int 21h
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		push 0
		call getValues
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		pop ax
		mov endX, ax
		mov dx, offset startYSentence
		cmp ax, 640
		jc reqStartY
		mov dx, offset ErrorMsg
		jmp reqEndX

	reqStartY:
		mov ah, 9
		int 21h
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		push 0
		call getValues
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		pop ax
		mov startY, ax
		mov dx, offset endYSentence
		cmp ax, 480
		jc reqEndY
		mov dx, offset ErrorMsg
		jmp reqStartY

	reqEndY:
		mov ah, 9
		int 21h
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		push 0
		call getValues
		mov dl, 10
		mov ah, 2
		int 21h
		mov dl, 13
		int 21h
		pop ax
		mov endY, ax
		cmp ax, 480
		jc startLine
		mov dx, offset ErrorMsg
		jmp reqEndY

	startLine:
		mov cx, endX
		cmp startX, cx
		jc noSwitchCoord	;draw the line from left to right, switch coords if endX > startX
		mov ax, startX
		mov startX, cx
		mov endX, ax
		mov cx, endY
		mov ax, startY
		mov startY, cx
		mov endY, ax

	noSwitchCoord:
		mov ax, 12h
		int 10h
		mov ax, endY
		mov deltaY, ax
		mov ax, startY
		sub deltaY, ax
		mov ax, endX
		mov deltaX, ax
		mov ax, startX
		sub deltaX, ax
		mov cx, startX
		mov dx, startY
		mov ax, deltaY
		add ax, deltaY
		sub ax, deltaX
		mov lineError, ax
		mov ah, 0ch
		mov al, lineColor
		mov di, deltaY
		mov si, deltaX
		cmp di, 0f000h
		jc downOct
		mov bx, startY
		sub bx, endY
		mov deltaY, bx
		mov di, bx
		add bx, di
		sub bx, deltaX
		mov lineError, bx
		cmp lineError, 0a000h
		jc cont1
		mov bx, 0
		sub bx, lineError
		mov lineError, bx
	cont1:
		mov bh, 0
		mov bl, lineColor
		cmp di, si
		jc drawLine_Oct2
		jmp drawLine_Oct1
	downOct:
		cmp lineError, 0a000h
		jc cont2
		mov bx, 0
		sub bx, lineError
		mov lineError, bx
	cont2:
		mov bh, 0
		mov bl, lineColor
		cmp di, si
		jc drawLine_Oct3
		jmp drawLine_Oct4 

	drawLine_Oct1:
		cmp lineError, 0a000h		
		jc decY_Oct1
		inc cx
		add lineError, di
		add lineError, di
		jmp drawLine_Oct1
	decY_Oct1:
		dec dx
		int 10h		
		sub lineError, si
		sub lineError, si
		cmp dx, endY
		jz Finish
		jmp drawLine_Oct1

	drawLine_Oct2:
		cmp lineError, 0a000h
		jc incX_Oct2
		dec dx
		add lineError, si
		add lineError, si
		jmp drawLine_Oct2
	incX_Oct2:
		inc cx
		int 10h
		sub lineError, di
		sub lineError, di
		cmp cx, endX
		jz Finish
		jmp drawLine_Oct2

	drawLine_Oct3:
		cmp lineError, 0a000h		;check if overflowed
		jc incX_Oct3
		inc dx						;inc y coordinate
		add lineError, si
		add lineError, si
		jmp drawLine_Oct3
	incX_Oct3:
		inc cx
		int 10h
		sub lineError, di
		sub lineError, di
		cmp cx, endX			;check if end of line
		jz Finish
		jmp drawLine_Oct3

	drawLine_Oct4:
		cmp lineError, 0a000h		
		jc incY_Oct4
		inc cx
		add lineError, di
		add lineError, di
		jmp drawLine_Oct4
	incY_Oct4:
		inc dx
		int 10h		
		sub lineError, si
		sub lineError, si
		cmp dx, endY
		jz Finish
		jmp drawLine_Oct4

	Finish:
		mov ah, 8
		int 21h
		cmp al, ' '
		jnz EndProg
		jmp startDraw
	EndProg:
		int 3
cseg ends
end Begin
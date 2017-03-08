dseg segment
	startXSentence db "Please enter the line's starting X coordinate. Press "Space" when done.$"
	endXSentence db "Please enter the line's ending X coordinate. Press "Space" when done.$"
	ErrorMsg db "The coordinate you have entered is out of range, please enter a smaller number.$"
	startX dw ?
	endX dw ?
	startY dw ?
	endY dw ?
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
		mov [bp+4], cx
		pop cx ax bx
		ret 2
getValues endp

	Begin:
		mov ax, dseg
		mov ds, ax
		mov cx, 25
		mov ah, 2
		mov dl, 10

		ClearScreen:
			int 21h
			loop ClearScreen

		mov dl, 0
		mov dh, 0
		int 10h

		mov ah, 9
		mov dx, offset startXSentence
		int 21h

		mov dh, 1
		mov ah, 2
		int 10h
	
	reqStartX:
		push 0
		call getValues
		pop ax
		mov startX, ax
		cmp ax, 640
		jc reqEndX
		mov dx, offset ErrorMsg
		int 21h
		jmp reqStartX

	reqEndX:
		mov ah, 9
		mov dx, offset endXSentence
		push 0
		call getValues
		pop ax
		mov endX, ax
		cmp ax, 640
		jc reqStartY
		mov dx, offset ErrorMsg
		int 21h
		jmp reqEndX

	reqStartY:

		int 3
cseg ends
end Begin
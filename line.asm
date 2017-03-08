dseg segment
	firstSentence db "Please enter the line's starting X coordinate:$"
dseg ends

proc getValues:
	push bx ax cx

	mov cx, 0
	mov bl, 3
	WaitForInput:
		mov ah, 8
		int 21h
		cmp al, ' '
		jz endFunc
		cmp al, '9'
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
		pop cx ax bx
		ret
end getValues

cseg segment
assume cs:cseg, ds:dseg
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
		mov dx, offset firstSentence
		int 21h

		mov dh, 1
		mov ah, 2
		int 10h

		int 3
cseg ends
end Begin
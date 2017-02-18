dseg segment
	checkers db 2,0,2,0,2,0,2,0
	len1	= $-checkers
		     db 0,2,0,2,0,2,0,2
		     db 2,0,2,0,2,0,2,0
			 db 0,1,0,1,0,1,0,1
			 db 1,0,1,0,1,0,1,0
			 db 0,3,0,3,0,3,0,3
		     db 3,0,3,0,3,0,3,0
		     db 0,3,0,3,0,3,0,3
	len0	= ($-checkers)/len1
	bxLeft dw 0ffh
	bxRight dw 0ffh
	siLeft dw 0ffh
	siRight dw 0ffh
	pressedBx dw 0ffh
	pressedSi dw 0ffh
	whiteCount db 12
	blackCount db 12
	tempBx dw ?
	tempSi dw ?
	currentChecker db 3
dseg ends

cseg segment
assume cs:cseg, ds:dseg
	Begin:
	mov ax,dseg
	mov ds, ax
	mov cx, 25
	mov si, 0
	mov bx, 0
	mov ah, 2
	mov dl, 10
	ClearScreen:
		int 21h
		loop ClearScreen

	mov dh, 0
	mov dl, 0
	int 10h

	mov cx, len0
	NextRow:
		mov dl, checkers[bx][si]
		add dl, '0'
		int 21h
		inc si
		cmp si, len1
		jnz NextRow
		mov dl, 10
		int 21h
		mov dl, 13
		int 21h
		add bx, len1
		mov si, 0
		loop NextRow

	mov dl, 0
	mov dh, 0
	int 10h
	mov ch, '3'
	mov bx, 0
	mov si, 0

	WaitForInput:
		mov ah, 8
		int 21h
		mov ah, 2
		cmp al, 'a'
		jz MoveLeft
		cmp al, 's'
		jz MoveDown
		cmp al, 'd'
		jz MoveRight
		cmp al, 'w'
		jz MoveUp
		cmp al, ' '
		jz CheckMove
		cmp al, 27
		jz gotoFinish
		jmp WaitForInput
	gotoFinish:
		jmp Finish
	MoveRight:
		cmp dl, len1-1
		jz WaitForInput
		inc dl
		int 10h
		inc bx
		jmp WaitForInput
	MoveDown:
		cmp dh, len0-1
		jz WaitForInput
		inc dh
		int 10h
		add si, len1
		jmp WaitForInput
	MoveUp:
		cmp dh, 0
		jz WaitForInput
		dec dh
		int 10h
		sub si, len1
		jmp WaitForInput
	MoveLeft:
		cmp dl, 0
		jz WaitForInput
		dec dl
		int 10h
		dec bx
		jmp WaitForInput

	gotoMakeMove:
		jmp MakeMove
	gotoWaitForInput:
		jmp WaitForInput

	CheckMove:
		mov ah, 8
		int 10h		
		cmp al, ch
		jnz gotoWaitForInput
		cmp ch, '4'
		jz gotoMakeMove
		mov bxLeft, 0ffh
		mov bxRight, 0ffh
		mov siLeft, 0ffh
		mov siRight, 0ffh
		cmp ch, '3'
		jz Check3
		jmp Check2

	Check3:
		cmp bx, len1-1		;check if on left side of board
		jz NoLeftMove3
		
		cmp checkers[bx+1][si-len1], 1		;check if neutral tile
		jnz EatLeft3
		mov checkers[bx+1][si-len1], 4   ;4 =moveable tile
		mov bxLeft, bx
		inc bxLeft		;bxLeft=bx+1
		mov siLeft, si
		sub siLeft, len1		;siLeft=si-len1
		mov pressedBx, bx
		mov pressedSi, si
		mov dl, bl
		inc dl		;dl=bxLeft
		mov ax, siLeft
		mov bl, len1-1
		div bl		; dh = row = (si-bx) % (len1-1)
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '4'
		int 21h
		inc dh		;return cursor to pressed tile
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		cmp bx, 0
		jz NoRightMove3
		jmp NoLeftMove3
	EatLeft3:

	NoLeftMove3:
		cmp checkers[bx-1][si-len1], 1
		jnz EatRight3
		mov checkers[bx-1][si-len1], 4
		mov bxRight, bx
		dec bxRight
		mov siRight, si
		sub siRight, len1	
		mov pressedBx, bx
		mov pressedSi, si
		mov dl, bl
		dec dl
		mov ax, siRight
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '4'
		int 21h
		inc dh
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		jmp NoRightMove3
	EatRight3:

	NoRightMove3:
		jmp WaitForInput
	
	NoMove:
		jmp WaitForInput

	Check2:
		cmp bx, len1-1
		jz NoLeftMove2
		
		cmp checkers[bx+1][si+len1], 1
		jnz EatLeft2
		mov checkers[bx+1][si+len1], 4
		mov bxLeft, bx
		inc bxLeft
		mov siLeft, si
		add siLeft, len1
		mov pressedBx, bx
		mov pressedSi, si
		mov dl, bl
		inc dl
		mov ax, siLeft
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '4'
		int 21h
		dec dh
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		cmp bx, 0
		jz NoRightMove2
		jmp NoLeftMove2
	EatLeft2:

	NoLeftMove2:
		cmp checkers[bx-1][si+len1], 1
		jnz EatRight2
		mov checkers[bx-1][si+len1], 4
		mov bxRight, bx
		dec bxRight
		mov siRight, si
		add siRight, len1	
		mov pressedBx, bx
		mov pressedSi, si
		mov dl, bl
		dec dl
		mov ax, siRight
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '4'
		int 21h
		dec dh
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		jmp NoRightMove2
	EatRight2:

	NoRightMove2:
		jmp WaitForInput

	MakeMove:
		mov tempBx, bx
		mov tempSi, si
		cmp bxRight, 0ffh
		jz SwitchOnlyLeft

		mov bx, bxRight		;switch possible move tiles back to neutral
		mov si, siRight
		mov checkers[bx][si], 1

		mov dl, bl
		mov ax, si
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h
		cmp bxLeft, 0ffh
		jz SwitchOnlyRight
	SwitchOnlyLeft:
		mov bx, bxLeft
		mov si, siLeft
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, siLeft
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

	SwitchOnlyRight:
		mov bx, pressedBx		;remove moved tile from previous position
		mov si, pressedSi
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, si
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		mov bx, tempBx		;update pressed tile
		mov si, tempSi
		mov al, currentChecker
		mov checkers[bx][si], al
		mov dl, bl
		mov ax, si
		mov bl, len1-1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, currentChecker
		add dl, '0'
		int 21h

		mov bx, tempBx		;move back to pressed tile
		mov dl, bl
		int 10h
				
		mov ch, currentChecker
		cmp ch, 3
		jz switchTo2
		mov ch, 4
	SwitchTo2:
		dec ch
		mov currentChecker, ch
		add ch, '0'
		jmp WaitForInput

	Finish:
		int 3
cseg ends
end begin
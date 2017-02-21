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
	bxDyingLeft dw 0ffh
	siDyingLeft dw 0ffh
	bxDyingRight dw 0ffh
	siDyingRight dw 0ffh
	eatTile = '5'
	blackCheckerGraphics db 60,255,60,255,60,255,26,9,25,255,22,17,21,255,19,23,18,255,17,7,13,7,16,255,16,5,19,5,15,255,14,5,23,5,13,255,13,4,27,4,12,255,12,4,29,4,11,255,11,3,33,3,10,255,10,3,35,3,9,255,9,3,37,3,8,255,5,1,2,3,39,3,7,255,8,3,39,3,7,255,7,3,41,3,6,255,6,3,43,3,5,255,6,3,43,3,5,255,5,3,45,3,4,255,5,3,45,3,4,255,5,2,47,2,4,255,4,3,47,3,3,255,4,3,47,3,3,255,4,2,49,2,3,255,4,2,49,2,3,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,4,2,49,2,3,255,4,2,49,2,3,255,4,3,47,3,3,255,4,3,47,3,3,255,5,2,47,2,4,255,5,3,45,3,4,255,5,3,45,3,4,255,6,3,43,3,5,255,6,3,43,3,5,255,7,3,41,3,6,255,8,3,39,3,7,255,8,3,39,3,7,255,9,3,37,3,8,255,10,3,35,3,9,255,11,3,33,3,10,255,12,4,29,4,11,255,13,4,27,4,12,255,14,5,23,5,13,255,16,5,19,5,15,255,17,7,13,7,16,255,19,23,18,255,22,17,21,255,26,9,25,255,60,255,60,254
	whiteCheckerGraphics db 60,255,60,255,60,255,26,9,25,255,22,17,21,255,19,23,18,255,17,27,16,255,16,29,15,255,14,33,13,255,13,35,12,255,12,37,11,255,11,39,10,255,10,41,9,255,9,43,8,255,8,45,7,255,8,45,7,255,7,47,6,255,6,49,5,255,6,49,5,255,5,51,4,255,5,51,4,255,5,51,4,255,4,53,3,255,4,53,3,255,4,53,3,255,4,53,3,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,4,53,3,255,4,53,3,255,4,53,3,255,4,53,3,255,5,51,4,255,5,51,4,255,5,51,4,255,6,49,5,255,6,49,5,255,7,47,6,255,8,45,7,255,8,45,7,255,9,43,8,255,10,41,9,255,11,39,10,255,12,37,11,255,13,35,12,255,14,33,13,255,16,29,15,255,17,27,16,255,19,23,18,255,22,17,21,255,26,9,25,255,60,255,60,254
	emptyTile db 60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,60,255,254
	currentGraphicsColor db ?
	currentRow dw 0
	currentCol dw 0
	graphicsIndex db 0
	tileLength = 60
	oppositeColor db 15
	currentColor db 0
dseg ends

cseg segment
assume cs:cseg, ds:dseg
	Begin:
	mov ah, 0
	mov al, 12h
	int 10h		;set to graphic mode
	mov ax,dseg
	mov ds, ax

	mov dx, 0
	mov bx, 0
	mov cx, 0	

	CreateTile:
		mov tempBx, bx
		mov ah, checkers[bx][si]
		cmp ah, 1
		jz gotoNextTile
		cmp ah, 0
		jz createEmptyTile
		cmp ah, 2
		jz createBlackTile
		jmp createWhiteTile

		gotoNextTile:
			jmp nextTile

		createEmptyTile:
			mov al, 15
			mov currentColor, 15
			mov oppositeColor, 0
			mov ah, 0ch
			mov cx, currentRow
			add cx, tileLength
			mov dx, currentCol
			add dx, tileLength
		contEmptyTile:
			int 10h
			dec dx
			cmp dx, currentCol			
			jnz contEmptyTile
			add dx, tileLength
			dec cx
			cmp cx, currentRow
			jnz contEmptyTile
			jmp nextTile

		createBlackTile:
			mov al, 0
			mov ah, 0ch
			mov di, 0
			mov bl, blackCheckerGraphics[di]
			mov cx, currentRow
			add cx, tileLength
			mov dx, currentCol
			add dx, tileLength
		contBlackTile:
			int 10h
			dec dx
			dec bl
			jnz contBlackTile
			inc di
			mov bl, blackCheckerGraphics[di]
			cmp bl, 255
			jnz switchColorBlackTile			
			inc di
			mov bl, blackCheckerGraphics[di]
			dec cx
			cmp dx, currentCol
			jnz contBlackTile
			add dx, tileLength
			jmp contBlackTile
		switchColorBlackTile:
			cmp bl, 254
			jz nextTile
			mov al, oppositeColor
			mov bh, currentColor
			mov oppositeColor, bh
			mov currentColor, al
			jmp contBlackTile
			

		createWhiteTile:
			mov al, 0
			mov ah, 0ch
			mov di, 0
			mov bl, whiteCheckerGraphics[di]
			mov cx, currentRow
			add cx, tileLength
			mov dx, currentCol
			add dx, tileLength
		contwhiteTile:
			int 10h
			dec dx
			dec bl
			jnz contWhiteTile
			inc di
			mov bl, whiteCheckerGraphics[di]
			cmp bl, 255
			jnz switchColorWhiteTile	
			inc di
			mov bl, whiteCheckerGraphics[di]
			dec cx
			cmp dx, currentCol
			jnz contWhiteTile
			add dx, tileLength
			jmp contWhiteTile
		switchColorWhiteTile:
			cmp bl, 254
			jz nextTile
			mov al, oppositeColor
			mov bh, currentColor
			mov oppositeColor, bh
			mov currentColor, al
			jmp contWhiteTile

	gotoCreateTile:
		jmp CreateTile

	nextTile:
		mov oppositeColor, 15
		mov currentColor, 0
		mov di, 0
		mov bx, tempBx
		inc bx
		add currentRow, tileLength
		cmp bx, len1
		jnz gotoCreateTile
		mov bx, 0
		mov currentRow, 0
		add currentCol, tileLength
		add si, len0
		cmp si, len0*len1
		jnz gotoCreateTile

	createBorder:
		mov bl, 3
		mov bh, 0
		mov dx, tileLength*len1
		mov cx, tileLength*len0
		mov al, 15
		mov ah, 0ch
	contCreateBorder:
		int 10h
		dec dx
		jnz contCreateBorder
		mov dx, tileLength*len1
		inc cx
		dec bl
		jnz contCreateBorder

	mov bx, 0
	mov si, 0
	mov al, 4
	mov dx, tileLength/4
	mov cx, tileLength/4
	createStartCursor:
		int 10h
		loop createStartCursor
		mov cx, tileLength/4
		dec dx
		jnz createStartCursor
	mov al, 0
	mov cx, 0

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
		cmp al, eatTile
		jz gotoCannibalMove
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

	gotoNoLeftMove3:
		jmp NoLeftMove3
	gotoCannibalMove:
		jmp CannibalMove

	Check3:
		cmp bx, len0-1		;check if on left side of board
		jz gotoNoLeftMove3
		
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
		mov bl, len1
		div bl		; dh = row = si % len1
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
		jz gotoNoRightMove3
		jmp NoLeftMove3

	EatLeft3:
		cmp checkers[bx+1][si-len1], 3
		jz NoLeftMove3
		cmp bx, len0-2		;check if there is space to eat
		jnc NoLeftMove3
		cmp si, 2*len0
		jc NoLeftMove3
		cmp checkers[bx+2][si-2*len1], 1
		jnz NoLeftMove3
		mov pressedBx, bx
		mov pressedSi, si
		inc bx
		mov bxDyingLeft, bx
		sub si, len1
		mov siDyingLeft, si
		inc bx
		mov bxLeft, bx
		sub si, len1
		mov siLeft, si
		mov checkers[bx][si], 5
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '5'
		int 21h
		add dh, 2
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		cmp bx, 0
		jz gotoNoRightMove3
		jmp NoLeftMove3

	gotoNoRightMove3:
		jmp NoRightMove3

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
		mov bl, len1
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
		cmp checkers[bx-1][si-len1], 3
		jz NoRightMove3
		cmp bx, 1
		jc NoRightMove3
		cmp si, 2*len0
		jc NoRightMove3
		cmp checkers[bx-2][si-2*len1], 1
		jnz NoRightMove3
		mov pressedBx, bx
		mov pressedSi, si
		dec bx
		mov bxDyingRight, bx
		sub si, len1
		mov siDyingRight, si
		dec bx
		mov bxRight, bx
		sub si, len1
		mov siRight, si
		mov checkers[bx][si], 5
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '5'
		int 21h
		add dh, 2
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'

	NoRightMove3:
		jmp WaitForInput

	Check2:
		cmp bx, len0-1
		jz gotoNoLeftMove2
		
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
		mov bl, len1
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
		jz gotoNoRightMove2
	gotoNoLeftMove2:
		jmp NoLeftMove2

	EatLeft2:
		cmp checkers[bx+1][si+len1], 2
		jz NoLeftMove2
		cmp bx, len0-2		;check if there is space to eat
		jnc NoLeftMove2
		cmp si, (len1-2)*len0
		jnc NoLeftMove2
		cmp checkers[bx+2][si+2*len1], 1
		jnz NoLeftMove2
		mov pressedBx, bx
		mov pressedSi, si
		inc bx
		mov bxDyingLeft, bx
		add si, len1
		mov siDyingLeft, si
		inc bx
		mov bxLeft, bx
		add si, len1
		mov siLeft, si
		mov checkers[bx][si], 5
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '5'
		int 21h
		sub dh, 2
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'
		cmp bx, 0
		jz gotoNoRightMove2
		jmp NoLeftMove2

	gotoNoRightMove2:
		jmp NoRightMove2

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
		mov bl, len1
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
		cmp checkers[bx-1][si+len1], 2
		jz NoRightMove2
		cmp bx, 1
		jc NoRightMove2
		cmp si, (len1-2)*len0
		jnc NoRightMove2
		cmp checkers[bx-2][si+2*len1], 1
		jnz NoRightMove2
		mov pressedBx, bx
		mov pressedSi, si
		dec bx
		mov bxDyingRight, bx
		add si, len1
		mov siDyingRight, si
		dec bx
		mov bxRight, bx
		add si, len1
		mov siRight, si
		mov checkers[bx][si], 5
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '5'
		int 21h
		sub dh, 2
		mov bx, pressedBx
		mov dl, bl
		int 10h
		mov si, pressedSi
		mov ch, '4'

	NoRightMove2:
		jmp WaitForInput
	
	CannibalMove:
		mov tempBx, bx
		mov tempSi, si
		mov ch, currentChecker
		add ch, '0'

		mov dl, currentChecker
		mov checkers[bx][si], dl
		mov dl, bl
		mov ax, si
		mov bl, len1		;move to new tile
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, ch
		int 21h

		mov bx, tempBx
		cmp bx, bxLeft
		jnz killRightTile		;check if right tile or left tile is killed
						
		mov bx, bxDyingLeft			;kill eaten tile
		mov si, siDyingLeft
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		mov bx, bxRight			;clear other tile
		mov si, siRight
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		jmp endCannibalTurn

	killRightTile:		
		mov bx, bxDyingRight
		mov si, siDyingRight
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		mov bx, bxLeft
		mov si, siLeft
		mov checkers[bx][si], 1
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		jmp endCannibalTurn

	endCannibalTurn:
		mov bxDyingRight, 0ffh
		mov bxDyingLeft, 0ffh
		mov siDyingRight, 0ffh
		mov siDyingLeft, 0ffh

		mov bx, pressedBx		;clear previous tile
		mov dl, bl
		mov si, pressedSi
		mov checkers[bx][si], 1
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, '1'
		int 21h

		mov bx, tempBx		;return to pressed tile
		mov si, tempSi
		mov dl, bl
		mov ax, si
		mov bl, len1
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov bx, tempBx

		cmp currentChecker, 3
		jnz SwitchTo3
		mov currentChecker, 2
		mov ch, '2'
		dec blackCount
		jmp WinCheck
	SwitchTo3:
		mov currentChecker, 3
		mov ch, '3'
		dec whiteCount
		jmp WinCheck

	MakeMove:
		mov bxDyingRight, 0ffh
		mov bxDyingLeft, 0ffh
		mov siDyingRight, 0ffh
		mov siDyingLeft, 0ffh
		mov tempBx, bx
		mov tempSi, si
		cmp bxRight, 0ffh
		jz SwitchOnlyLeft

		mov bx, bxRight		;switch possible move tiles back to neutral
		mov si, siRight
		mov checkers[bx][si], 1

		mov dl, bl
		mov ax, si
		mov bl, len1
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
		mov bl, len1
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
		mov bl, len1
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
		mov bl, len1
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
		jmp WinCheck

	WinCheck:
		mov bxLeft, 0ffh
		mov bxRight, 0ffh
		mov siLeft, 0ffh
		mov siRight, 0ffh
		cmp blackCount, 0
		jz Finish
		cmp whiteCount, 0
		jz Finish
		cmp dh, 0
		jz Finish
		cmp dh, len1-1
		jz Finish
		jmp WaitForInput

	Finish:
		int 3
cseg ends
end begin
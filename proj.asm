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
	cxLeft dw 0ffh
	cxRight dw 0ffh
	dxLeft dw 0ffh
	dxRight dw 0ffh
	pressedBx dw 0ffh
	pressedSi dw 0ffh
	pressedCx dw 0ffh
	pressedDx dw 0ffh
	whiteCount db 12
	blackCount db 12
	tempBx dw ?
	tempSi dw ?
	tempCx dw ?
	tempDx dw ?
	currentChecker db 3
	turnVal db 3
	bxDyingLeft dw 0ffh
	siDyingLeft dw 0ffh
	bxDyingRight dw 0ffh
	siDyingRight dw 0ffh
	cxDyingLeft dw 0ffh
	dxDyingLeft dw 0ffh
	cxDyingRight dw 0ffh
	dxDyingRight dw 0ffh
	eatTile = 5
	blackCheckerGraphics db 60,255,60,255,60,255,26,9,25,255,22,17,21,255,19,23,18,255,17,7,13,7,16,255,16,5,19,5,15,255,14,5,23,5,13,255,13,4,27,4,12,255,12,4,29,4,11,255,11,3,33,3,10,255,10,3,35,3,9,255,9,3,37,3,8,255,5,1,2,3,39,3,7,255,8,3,39,3,7,255,7,3,41,3,6,255,6,3,43,3,5,255,6,3,43,3,5,255,5,3,45,3,4,255,5,3,45,3,4,255,5,2,47,2,4,255,4,3,47,3,3,255,4,3,47,3,3,255,4,2,49,2,3,255,4,2,49,2,3,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,3,3,49,3,2,255,4,2,49,2,3,255,4,2,49,2,3,255,4,3,47,3,3,255,4,3,47,3,3,255,5,2,47,2,4,255,5,3,45,3,4,255,5,3,45,3,4,255,6,3,43,3,5,255,6,3,43,3,5,255,7,3,41,3,6,255,8,3,39,3,7,255,8,3,39,3,7,255,9,3,37,3,8,255,10,3,35,3,9,255,11,3,33,3,10,255,12,4,29,4,11,255,13,4,27,4,12,255,14,5,23,5,13,255,16,5,19,5,15,255,17,7,13,7,16,255,19,23,18,255,22,17,21,255,26,9,25,255,60,255,60,254
	whiteCheckerGraphics db 60,255,60,255,60,255,26,9,25,255,22,17,21,255,19,23,18,255,17,27,16,255,16,29,15,255,14,33,13,255,13,35,12,255,12,37,11,255,11,39,10,255,10,41,9,255,9,43,8,255,8,45,7,255,8,45,7,255,7,47,6,255,6,49,5,255,6,49,5,255,5,51,4,255,5,51,4,255,5,51,4,255,4,53,3,255,4,53,3,255,4,53,3,255,4,53,3,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,3,55,2,255,4,53,3,255,4,53,3,255,4,53,3,255,4,53,3,255,5,51,4,255,5,51,4,255,5,51,4,255,6,49,5,255,6,49,5,255,7,47,6,255,8,45,7,255,8,45,7,255,9,43,8,255,10,41,9,255,11,39,10,255,12,37,11,255,13,35,12,255,14,33,13,255,16,29,15,255,17,27,16,255,19,23,18,255,22,17,21,255,26,9,25,255,60,255,60,254
	moveTileGraphics db 60,255,60,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,5,50,5,255,60,255,60,254
	currentRow dw 0
	currentCol dw 0
	graphicsIndex db 0
	tileLength = 60
	cursorLength = 15
	oppositeColor db 15
	currentColor db 0
	prevBx dw ?
	prevSi dw ?
	prevCol dw ?
	prevRow dw ?
	arrCol db 0
	arrRow db ?
	moveTileColor = 4
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
			mov bh, 0
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
		contWhiteTile:
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
			mov bh, 0
			jmp contWhiteTile

	gotoCreateTile:
		jmp CreateTile

	nextTile:
		mov oppositeColor, 15
		mov currentColor, 0
		mov di, 0
		mov bx, tempBx
		inc bx
		mov bh, 0
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
		mov bx, 3
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
	mov al, 1
	mov dx, cursorLength
	mov cx, cursorLength
	createStartCursor:
		int 10h
		loop createStartCursor
		mov cx, cursorLength
		dec dx
		jnz createStartCursor
	mov al, 0
	mov cx, 0
	mov dx, 0
	mov currentCol, 0
	mov currentRow, 0

	WaitForInput:
		mov prevBx, bx
		mov prevSi, si
		mov prevCol, cx
		mov prevRow, dx
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
		jz gotoCheckMove
		cmp al, 27
		jz gotoFinish
		jmp WaitForInput
	gotoCheckMove:
		jmp CheckMove
	gotoFinish:
		jmp Finish
	MoveRight:
		cmp arrCol, len1-1
		jz WaitForInput
		add cx, tileLength
		mov currentCol, cx
		inc arrCol
		inc bx
		jmp updateCursor
	MoveDown:
		cmp arrRow, len0-1
		jz WaitForInput
		add dx, tileLength
		mov currentRow, dx
		inc arrRow
		add si, len1
		jmp updateCursor
	MoveUp:
		cmp arrRow, 0
		jz WaitForInput
		sub dx, tileLength
		mov currentRow, dx
		dec arrRow
		sub si, len1
		jmp updateCursor
	MoveLeft:
		cmp arrCol, 0
		jz gotoWaitForInput1
		sub cx, tileLength
		mov currentCol, cx
		dec arrCol
		dec bx
		jmp updateCursor

	gotoWaitForInput1:
		jmp WaitForInput

	updateCursor:
		mov tempBx, bx
		mov tempSi, si
		add dx, cursorLength
		add cx, cursorLength
		mov ah, 0ch
		mov al, 1
		mov bh, 0
		mov di, currentCol
		moveCursor:
			int 10h
			dec cx
			cmp cx, di
			jnz moveCursor
			add cx, cursorLength
			dec dx
			cmp dx, currentRow
			jnz moveCursor

		mov bx, prevBx
		mov si, prevSi
		mov ah, 0ch
		mov bh, checkers[bx][si]
		cmp bh, 0
		jz updateToWhiteTile
		cmp bh, 1
		jz updateToBlackTile
		cmp bh, 2
		jz gotoUpdateToBlackChecker
		cmp bh, 3
		jz updateToWhiteChecker
		cmp bh, 5
		jz updateToPossibleMoveTile
		jmp updateToMoveTile

		gotoUpdateToBlackChecker:
			jmp updateToBlackChecker

		updateToWhiteTile:
			mov al, 15
			jmp updateToEmptyTile			

		updateToBlackTile:
			mov al, 0
			jmp updateToEmptyTile

		updateToPossibleMoveTile:
			mov bh, 0
			mov al, moveTileColor
			mov currentColor, al
			mov oppositeColor, 0
			mov di, 0
			mov bl, moveTileGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdateToPossibleMoveTile:
				int 10h
				dec dx
				dec bl
				jnz contUpdateToPossibleMoveTile
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorPossibleMoveTile	
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp contUpdateToPossibleMoveTile
			switchColorPossibleMoveTile:
				cmp bl, 254
				jz gotoendCursorUpdate
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp contUpdateToPossibleMoveTile

		updateToWhiteChecker:
			mov bh, 0
			mov al, 0
			mov di, 0
			mov bl, whiteCheckerGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdateToWhiteChecker:
				int 10h
				dec dx
				dec bl
				jnz contUpdateToWhiteChecker
				inc di
				mov bl, whiteCheckerGraphics[di]
				cmp bl, 255
				jnz switchColorWhiteCheckerUpdate			
				inc di
				mov bl, whiteCheckerGraphics[di]
				dec cx
				add dx, tileLength
				jmp contUpdateToWhiteChecker
			switchColorWhiteCheckerUpdate:
				cmp bl, 254
				jz gotoendCursorUpdate
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp contUpdateToWhiteChecker

		gotoEndCursorUpdate:		
			jmp endCursorUpdate

		updateToBlackChecker:
			mov bh, 0
			mov al, 0
			mov di, 0
			mov bl, blackCheckerGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdateToBlackChecker:
				int 10h
				dec dx
				dec bl
				jnz contUpdateToBlackChecker
				inc di
				mov bl, blackCheckerGraphics[di]
				cmp bl, 255
				jnz switchColorBlackCheckerUpdate			
				inc di
				mov bl, blackCheckerGraphics[di]
				dec cx
				add dx, tileLength
				jmp contUpdateToBlackChecker
			switchColorBlackCheckerUpdate:
				cmp bl, 254
				jz gotoEndCursorUpdate
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp contUpdateToBlackChecker

		updateToMoveTile:
			mov bh, 0
			mov al, moveTileColor
			mov oppositeColor, 0
			mov currentColor, moveTileColor
			mov di, 0
			mov bl, moveTileGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdateToMoveTile:
					int 10h
					dec dx
					dec bl
					jnz contUpdateToMoveTile
					inc di
					mov bl, moveTileGraphics[di]
					cmp bl, 255
					jnz switchColorMoveTileUpdate			
					inc di
					mov bl, moveTileGraphics[di]
					dec cx
					add dx, tileLength
					jmp contUpdateToMoveTile
				switchColorMoveTileUpdate:
					cmp bl, 254
					jz endCursorUpdate
					mov al, oppositeColor
					mov bh, currentColor
					mov oppositeColor, bh
					mov currentColor, al
					mov bh, 0
					jmp contUpdateToMoveTile

		updateToEmptyTile:
			mov bh, 0
			mov cx, prevCol
			mov dx, prevRow
			add cx, cursorLength
			add dx, cursorLength
			contUpdateToEmpty:
				int 10h
				dec dx
				cmp dx, prevRow
				jnz contUpdateToEmpty
				add dx, cursorLength
				dec cx
				cmp cx, prevCol
				jnz contUpdateToEmpty		
			jmp endCursorUpdate

		endCursorUpdate:
			mov bx, tempBx
			mov si, tempSi
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, tempBx
			mov si, tempSi
			mov dx, currentRow
			mov cx, currentCol
			jmp WaitForInput

	gotoMakeMove:
		jmp MakeMove

	gotoWaitForInput:
		jmp WaitForInput

	CheckMove:
		mov al, checkers[bx][si]
		cmp al, eatTile
		jz gotoCannibalMove
		cmp al, currentChecker
		jnz gotoWaitForInput
		cmp currentChecker, 4
		jz gotoMakeMove
		mov bxLeft, 0ffh
		mov bxRight, 0ffh
		mov siLeft, 0ffh
		mov siRight, 0ffh
		cmp currentChecker, 3
		jz Check3
		jmp Check2

	gotoNoLeftMove3:
		jmp NoLeftMove3
	gotoCannibalMove:
		jmp CannibalMove
	gotoEatLeft3:
		jmp EatLeft3

	Check3:
		cmp bx, len0-1		;check if on left side of board
		jz gotoNoLeftMove3
		
		cmp checkers[bx+1][si-len1], 1		;check if neutral tile
		jnz gotoEatLeft3
		mov checkers[bx+1][si-len1], 4   ;4 =moveable tile
		mov bxLeft, bx
		inc bxLeft		;bxLeft=bx+1
		mov siLeft, si
		sub siLeft, len1		;siLeft=si-len1
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		add cx, 2*tileLength
		mov cxLeft, cx
		mov dxLeft, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, moveTileColor
		moveTileLeft3:
				int 10h
				dec dx
				dec bl
				jnz moveTileLeft3
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorMoveTileLeft3		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp moveTileLeft3
			switchColorMoveTileLeft3:
				cmp bl, 254
				jz endMoveTileLeft3
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp moveTileLeft3
		
		endMoveTileLeft3:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov currentChecker, 4
			add dx, tileLength
			sub cx, tileLength+1
			cmp bx, 0
			jz gotoNoRightMove3
			jmp NoLeftMove3

	gotoNoRightMove3:
		jmp NoRightMove3
	goto2NoLeftMove3:
		jmp NoLeftMove3

	EatLeft3:
		cmp checkers[bx+1][si-len1], 3
		jz goto2NoLeftMove3
		cmp bx, len0-2		;check if there is space to eat
		jnc goto2NoLeftMove3
		cmp si, 2*len0
		jc goto2NoLeftMove3
		cmp checkers[bx+2][si-2*len1], 1
		jnz goto2NoLeftMove3
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		inc bx
		mov bxDyingLeft, bx
		sub si, len1
		mov siDyingLeft, si
		inc bx
		sub si, len1
		mov bxLeft, bx
		mov siLeft, si
		mov checkers[bx][si], 5
		add cx, 2*tileLength
		mov cxDyingLeft, cx
		mov dxDyingLeft, dx
		add cx, tileLength
		sub dx, tileLength
		mov cxLeft, cx
		mov dxLeft, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, al
		eatTileLeft3:
				int 10h
				dec dx
				dec bl
				jnz eatTileLeft3
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorEatTileLeft3		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp eatTileLeft3
			switchColorEatTileLeft3:
				cmp bl, 254
				jz endEatTileLeft3
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp eatTileLeft3
		
		endEatTileLeft3:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov si, pressedSi
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
			cmp bx, 0
			jz goto2NoRightMove3
			jmp NoLeftMove3
	
	gotoEatRight3:
		jmp EatRight3
	goto2NoRightMove3:
		jmp NoRightMove3

	NoLeftMove3:
		cmp checkers[bx-1][si-len1], 1
		jnz gotoEatRight3
		mov checkers[bx-1][si-len1], 4
		mov bxRight, bx
		dec bxRight
		mov siRight, si
		sub siRight, len1	
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		mov dxRight, dx
		mov cxRight, cx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, moveTileColor
		moveTileRight3:
				int 10h
				dec dx
				dec bl
				jnz moveTileRight3
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorMoveTileRight3		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp moveTileRight3
			switchColorMoveTileRight3:
				cmp bl, 254
				jz endMoveTileRight3
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp moveTileRight3
		
		endMoveTileRight3:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
		NoRightMove3:
			jmp WaitForInput

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
		mov pressedCx, cx
		mov pressedDx, dx
		dec bx
		mov bxDyingRight, bx
		sub si, len1
		mov siDyingRight, si
		dec bx
		sub si, len1
		mov bxRight, bx
		mov siRight, si
		mov checkers[bx][si], 5
		mov cxDyingRight, cx
		mov dxDyingRight, dx
		sub cx, tileLength
		sub dx, tileLength
		mov cxRight, cx
		mov dxRight, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, al
		eatTileRight3:
				int 10h
				dec dx
				dec bl
				jnz eatTileRight3
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorEatTileRight3		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp eatTileRight3
			switchColorEatTileRight3:
				cmp bl, 254
				jz endEatTileRight3
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp eatTileRight3
		
		endEatTileRight3:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov si, pressedSi
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
			jmp WaitForInput

	gotoNoLeftMove2:
		jmp NoLeftMove2
	gotoEatLeft2:
		jmp EatLeft2

	Check2:
		cmp bx, len0-1
		jz gotoNoLeftMove2
		
		cmp checkers[bx+1][si+len1], 1
		jnz gotoEatLeft2
		mov checkers[bx+1][si+len1], 4
		mov bxLeft, bx
		inc bxLeft
		mov siLeft, si
		add siLeft, len1
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		add dx, 2*tileLength
		add cx, 2*tileLength
		mov cxLeft, cx
		mov dxLeft, dx
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, moveTileColor
		moveTileLeft2:
				int 10h
				dec dx
				dec bl
				jnz moveTileLeft2
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorMoveTileLeft2		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp moveTileLeft2
			switchColorMoveTileLeft2:
				cmp bl, 254
				jz endMoveTileLeft2
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp moveTileLeft2
		
		endMoveTileLeft2:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
			cmp bx, 0
			jz gotoNoRightMove2
			jmp NoLeftMove2

	gotoNoRightMove2:
		jmp NoRightMove2
	goto2NoLeftMove2:
		jmp NoLeftMove2

	EatLeft2:
		cmp checkers[bx+1][si+len1], 2
		jz goto2NoLeftMove2
		cmp bx, len0-2		;check if there is space to eat
		jnc goto2NoLeftMove2
		cmp si, (len1-2)*len0
		jnc goto2NoLeftMove2
		cmp checkers[bx+2][si+2*len1], 1
		jnz goto2NoLeftMove2
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		inc bx
		mov bxDyingLeft, bx
		add si, len1
		mov siDyingLeft, si
		inc bx
		add si, len1
		mov bxLeft, bx
		mov siLeft, si
		mov checkers[bx][si], 5
		add cx, 2*tileLength
		add dx, 2*tileLength
		mov cxDyingLeft, cx
		mov dxDyingLeft, dx
		add cx, tileLength
		add dx, tileLength
		mov cxLeft, cx
		mov dxLeft, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, al
		eatTileLeft2:
				int 10h
				dec dx
				dec bl
				jnz eatTileLeft2
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorEatTileLeft2		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp eatTileLeft2
			switchColorEatTileLeft2:
				cmp bl, 254
				jz endEatTileLeft2
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp eatTileLeft2
		
		endEatTileLeft2:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov si, pressedSi
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
			cmp bx, 0
			jz goto2NoRightMove2
			jmp NoLeftMove2

	gotoEatRight2:
		jmp EatRight2
	goto2NoRightMove2:
		jmp NoRightMove2

	NoLeftMove2:
		cmp checkers[bx-1][si+len1], 1
		jnz gotoEatRight2
		mov checkers[bx-1][si+len1], 4
		mov bxRight, bx
		dec bxRight
		mov siRight, si
		add siRight, len1	
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		add dx, 2*tileLength
		mov dxRight, dx
		mov cxRight, cx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, moveTileColor
		moveTileRight2:
				int 10h
				dec dx
				dec bl
				jnz moveTileRight2
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorMoveTileRight2		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp moveTileRight2
			switchColorMoveTileRight2:
				cmp bl, 254
				jz endMoveTileRight2
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp moveTileRight2
		
		endMoveTileRight2:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov currentChecker, 4
			sub dx, tileLength
			add cx, tileLength-1
		NoRightMove2:
			jmp WaitForInput

	EatRight2:
		cmp checkers[bx-1][si+len1], 2
		jz NoRightMove2
		cmp bx, 1
		jc NoRightMove2
		cmp si, (len1-2)*len0
		jnc NoRightMove2
		mov pressedBx, bx
		mov pressedSi, si
		mov pressedCx, cx
		mov pressedDx, dx
		dec bx
		mov bxDyingRight, bx
		add si, len1
		mov siDyingRight, si
		dec bx
		add si, len1
		mov bxRight, bx
		mov siRight, si
		mov checkers[bx][si], 5
		add dx, 2*tileLength
		mov cxDyingRight, cx
		mov dxDyingRight, dx
		sub cx, tileLength
		add dx, tileLength
		mov cxRight, cx
		mov dxRight, dx
		mov bh, 0
		mov al, moveTileColor
		mov ah, 0ch
		mov di, 0
		mov bl, moveTileGraphics[di]
		mov oppositeColor, 0
		mov currentColor, al
		eatTileRight2:
				int 10h
				dec dx
				dec bl
				jnz eatTileRight2
				inc di
				mov bl, moveTileGraphics[di]
				cmp bl, 255
				jnz switchColorEatTileRight2		
				inc di
				mov bl, moveTileGraphics[di]
				dec cx
				add dx, tileLength
				jmp eatTileRight2
			switchColorEatTileRight2:
				cmp bl, 254
				jz endEatTileRight2
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp eatTileRight2
		
		endEatTileRight2:
			mov oppositeColor, 15
			mov currentColor, 0
			mov bx, pressedBx
			mov si, pressedSi
			mov currentChecker, 4
			mov cx, pressedCx
			mov dx, pressedDx
			jmp WaitForInput
	
	CannibalMove:
		mov tempBx, bx
		mov tempSi, si
		add currentChecker, '0'

		mov dl, currentChecker
		mov checkers[bx][si], dl
		mov dl, bl
		mov ax, si
		mov bl, len1		;move to new tile
		div bl
		mov dh, al
		mov ah, 2
		int 10h
		mov dl, currentChecker
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
		mov currentChecker, '2'
		dec blackCount
		jmp WinCheck
	SwitchTo3:
		mov currentChecker, 3
		dec whiteCount
		jmp WinCheck

	MakeMove:
		mov bxDyingRight, 0ffh
		mov bxDyingLeft, 0ffh
		mov siDyingRight, 0ffh
		mov siDyingLeft, 0ffh
		mov arrCol, bl
		mov tempBx, bx
		mov tempSi, si
		mov tempCx, cx
		mov tempDx, dx
		mov al, 0
		mov ah, 0ch

		cmp bxRight, 0ffh
		jz SwitchOnlyLeft

		mov bx, bxRight		;switch possible move tiles back to neutral
		mov si, siRight
		mov checkers[bx][si], 1

		mov cx, cxRight
		mov dx, dxRight
		sub cxRight, tileLength
		sub dxRight, tileLength

		switchNeutralRight:
			mov bh, 0
			contSwitchNeutralRight:
				int 10h
				dec dx
				cmp dx, dxRight
				jnz contSwitchNeutralRight
				add dx, tileLength
				dec cx
				cmp cx, cxRight
				jnz contSwitchNeutralRight
		
		cmp bxLeft, 0ffh
		jz SwitchOnlyRight
	SwitchOnlyLeft:
		mov bx, bxLeft
		mov si, siLeft
		mov checkers[bx][si], 1
		mov cx, cxLeft
		mov dx, dxLeft
		sub cxLeft, tileLength
		sub dxLeft, tileLength

		switchNeutralLeft:
			mov bh, 0
			contSwitchNeutralLeft:
				int 10h
				dec dx
				cmp dx, dxLeft
				jnz contSwitchNeutralLeft
				add dx, tileLength
				dec cx
				cmp cx, cxLeft
				jnz contSwitchNeutralLeft
		
	SwitchOnlyRight:
		mov bx, pressedBx		;remove moved tile from previous position
		mov si, pressedSi
		mov checkers[bx][si], 1
		mov cx, pressedCx
		mov dx, pressedDx
		add cx, tileLength
		add dx, tileLength
		mov al, 0
		removeMovedTile:
			int 10h
			dec dx
			cmp dx, pressedDx
			jnz removeMovedTile
			add dx, tileLength
			dec cx
			cmp cx, pressedCx
			jnz removeMovedTile
		
		mov bx, tempBx		;update pressed tile
		mov si, tempSi
		mov al, turnVal
		mov checkers[bx][si], al
		cmp al, 2
		jz updatePressedToBlackChecker
		jmp updatePressedToWhiteChecker
		
		updatePressedToBlackChecker:
			inc arrRow
			mov bh, 0
			mov al, 0
			mov di, 0
			mov bl, blackCheckerGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdatePressedToBlackChecker:
				int 10h
				dec dx
				dec bl
				jnz contUpdatePressedToBlackChecker
				inc di
				mov bl, blackCheckerGraphics[di]
				cmp bl, 255
				jnz switchPressedColorBlackCheckerUpdate			
				inc di
				mov bl, blackCheckerGraphics[di]
				dec cx
				add dx, tileLength
				jmp contUpdatePressedToBlackChecker
			switchPressedColorBlackCheckerUpdate:
				cmp bl, 254
				jz updatePressedCursor
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp contUpdatePressedToBlackChecker

			updatePressedToWhiteChecker:
			dec arrRow
			mov bh, 0
			mov al, 0
			mov di, 0
			mov bl, whiteCheckerGraphics[di]
			mov cx, prevCol
			add cx, tileLength
			mov dx, prevRow
			add dx, tileLength
			contUpdatePressedToWhiteChecker:
				int 10h
				dec dx
				dec bl
				jnz contUpdatePressedToWhiteChecker
				inc di
				mov bl, whiteCheckerGraphics[di]
				cmp bl, 255
				jnz switchPressedColorWhiteCheckerUpdate			
				inc di
				mov bl, whiteCheckerGraphics[di]
				dec cx
				add dx, tileLength
				jmp contUpdatePressedToWhiteChecker
			switchPressedColorWhiteCheckerUpdate:
				cmp bl, 254
				jz updatePressedCursor
				mov al, oppositeColor
				mov bh, currentColor
				mov oppositeColor, bh
				mov currentColor, al
				mov bh, 0
				jmp contUpdatePressedToWhiteChecker
		
		UpdatePressedCursor:
		mov al, 1
		mov cx, prevCol
		mov dx, prevRow
		add cx, cursorLength
		add dx, cursorLength
		contUpdatePressedCursor:
			int 10h
			dec cx
			cmp cx, prevCol
			jnz contUpdatePressedCursor
			add cx, cursorLength
			dec dx
			cmp dx, prevRow
			jnz contUpdatePressedCursor

		mov cx, prevCol
		mov dx, prevRow
		mov bx, tempBx

		cmp turnVal, 3
		jz switchTo2
		mov turnVal, 4
	SwitchTo2:
		dec turnVal
		mov al, turnVal
		mov currentChecker, al
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
		cmp arrRow, 0
		jz Finish
		cmp arrRow, len1-1
		jz Finish
		jmp WaitForInput

	Finish:
		int 3
cseg ends
end begin
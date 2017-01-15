cseg segment
assume cs:cseg
	Begin:
			mov ah, 2
			mov cl, 25
	Clear:
			mov dl, 10
			int 21h
			dec cl
			jnz Clear

			mov bh, 0
			mov dh, 0
			mov dl, 0
			int 10h
						
			mov bl, 3 ;This Chooses the board size
			mov cl, bl
			mov ch, bl
			
	CreateBoard:
			mov dl, '#'
			mov cl, bl
	WriteLine:
			int 21h
			dec cl
			jnz WriteLine
			jz NewRow
	NewRow:
			mov dl, 10
			int 21h
			mov dl, 13
			int 21h
			dec ch
			jnz CreateBoard
			jz MoveInit
			
	MoveInit:
			mov ah, 2
			mov bh, 0
			mov dh, 0
			dec bl
			mov si, 0
			mov dl, 0
			int 10h		
				
			mov ah, 7
	WaitForKey:
			int 21h
			cmp al, 61h
			jz GoLeft
			cmp al, 77h
			jz GoUp
			cmp al, 73h
			jz GoDown
			cmp al, 64h
			jz GoRight			
			cmp al, 20h
			jz Switch
			cmp al, 1bh
			jz GoToFinish
			jmp WaitForKey
	GoToFinish:
			jmp Finish
	GoDown:
			cmp dh, bl
			jz WaitForKey
			inc dh
			mov ah, 2
			int 10h
			mov ah, 7
			jmp WaitForKey
	GoLeft:
			cmp dl, 0
			jz WaitForkey
			dec dl
			mov ah, 2
			int 10h
			mov ah, 7
			jmp WaitForKey
	GoRight:			
			cmp dl, bl
			jz WaitForKey
			inc dl
			mov ah, 2
			int 10h 
			mov ah, 7
			jmp WaitForKey
	GoUp:
			cmp dh, 0
			jz WaitForKey
			dec dh
			mov ah, 2
			int 10h
			mov ah, 7
			jmp WaitForKey
	BorderExcep:
			dec bl
			jmp WaitForKey
	Switch:	
			inc bl		
			cmp dl, bl
			jz BorderExcep
			dec bl
			mov ch, dl
			mov ah, 8
			int 10h
			cmp al, '#'
			jz MakeChar
			jmp WaitForKey
					
	MakeChar:
			cmp si, 1
			jz MakeO
			jmp MakeX
	MakeX:
			mov dl, 'X'
			mov ah, 2
			int 21h
			mov dl, ch
			inc dl
			mov ah, 7
			inc si
			mov cl, 'X'
			jmp VictoryCheck

	MakeO:
			mov dl, 'O'
			mov ah, 2
			int 21h
			mov dl, ch
			inc dl
			mov ah, 7
			dec si
			mov cl, 'O'
			jmp VictoryCheck

	VictoryCheck:
			mov bh, 0
			inc bl
			jmp RowCheck

	RowCheck:
			mov ch, dl
			mov dl, 0
			mov ah, 2
			int 10h
			mov ah, 8
			int 10h
			cmp al, cl
			jz CheckNextCol			
			mov dl, ch
			jmp ColCheck
			CheckNextCol:
				inc dl
				cmp bl, dl
				jz GoFinish
				mov ah, 2
				int 10h
				mov ah, 8
				int 10h
				cmp al, cl
				jz CheckNextCol
				mov dl, ch
				jmp ColCheck
	
	GoFinish:
	jmp Finish

	ColCheck:
		dec dl
		mov ch, dh
		mov dh, 0
		mov ah, 2
		int 10h
		mov ah, 8
		int 10h
		cmp al, cl
		jz CheckNextRow
		mov dh, ch
		jmp DiagonalCheck
		CheckNextRow:
			inc dh
			cmp bl, dh
			jz GoFinish
			mov ah, 2
			int 10h
			mov ah, 8
			int 10h
			cmp al, cl
			jz CheckNextRow
			mov dh, ch
			jmp DiagonalCheck

	DiagonalCheck:
		sub dh, dl
		jz MainDiagonal
		add dh, dl
		add dh, dl
		dec bl
		sub dh, bl
		jz SecondDiagonal
		sub dh, dl
		add dh, bl
		mov ah, 2
		int 10h
		mov ah, 7
		jmp WaitForKey

		MainDiagonal:
			mov ch, dl
			mov dl, 0
			mov dh, 0
			mov ah, 2
			int 10h
			mov ah, 8
			int 10h
			cmp al, cl
			jz MainDiagonalCheck
			mov dl, ch
			mov dh, ch
			mov ah, 2
			int 10h
			mov ah, 7
			dec bl
			jmp WaitForKey
			MainDiagonalCheck:
				inc dl
				inc dh
				cmp bl, dl
				jz Finish
				mov ah, 2
				int 10h
				mov ah, 8
				int 10h
				cmp al, cl
				jz MainDiagonalCheck
				mov dl, ch
				mov dh, ch
				mov ah, 2
				int 10h
				mov ah, 7
				dec bl
				jmp WaitForKey
			
			SecondDiagonal:				
			mov ch, dl
			mov dl, bl
			inc bl
			mov ah, 2
			int 10h
			mov ah, 8
			int 10h
			cmp al, cl
			jz SecondDiagonalCheck
			mov dl, ch
			mov dh, bl
			sub dh, dl
			mov ah, 2
			int 10h
			mov ah, 7
			dec bl
			jmp WaitForKey
			SecondDiagonalCheck:
				inc dh
				dec dl
				jz Finish
				mov ah, 2
				int 10h
				mov ah, 8
				int 10h
				cmp al, cl
				jz SecondDiagonalCheck
				mov dl, ch
				mov dh, bl
				sub dh, dl
				mov ah, 2
				int 10h
				mov ah, 7
				dec bl
				jmp WaitForKey

	Finish:
		int 3
cseg ends
end begin
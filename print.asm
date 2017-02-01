cseg segment
assume cs:cseg
	Begin:
	mov ax, 300h
	mov ds, ax
	mov si, 200h
	mov bl, 8
	mov ah, 2

	PrintFirst:
		mov dl, ds:[si] ;access memory
		mov dh, dl
		shr dl, 4
		cmp dl, 10
		jnc convertLetter
		add dl, 30h ;add to convert to number text value
		jmp printChar
	convertLetter:
		add dl, 37h  ;add to convert to letter text value
		jmp printChar
	printChar:
		int 21h
		jmp PrintSecond
		

		PrintSecond:
		mov dl, dh
		shl dl, 4
		shr dl, 4
		cmp dl, 10
		jnc convertLetter2
		add dl, 30h
		jmp printChar2
	convertLetter2:
		add dl, 37h
		jmp printChar2
	printChar2:
		int 21h
		inc si
		mov dl, ' '
		int 21h
		dec bl
		jnz PrintFirst

	int 3h
cseg ends
end begin
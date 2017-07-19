dseg segment
	firstNum dw 01000h
	secondNum dw 02000h
	addition dw ?
	subtraction dw ?
	multiplication dw ?
	division dw ?

	firstNumMsg db "The first number is:$"
	secondNumMsg db "The second number is:$"
	addMsg db "The addition of these numbers is:$"
	subMsg db "The subtraction of these numbers is:$"
dseg ends

printWord MACRO number
	local @@isPos
	local @@endMacro
	shl number, 1
	jnc @@isPos
	mov ah, 2
	mov dl, '-'
	int 21h
	neg number

	@@isPos:
	shr number, 1
	mov cx, number		;;firstDigit
	mov dl, ch
	shr dl, 4
	printByte dl

	mov dl, ch
	and dl, 0fh		;;secondDigit
	printByte dl

	mov dl, cl
	shr dl, 4			;;thirdDigit
	printByte dl

	mov dl, cl
	and dl, 0fh		;;fourthDigit
	printByte dl	
	@@endMacro:
ENDM


printByte MACRO byte
	local @@printByte
	local @@isDigit
	mov dl, byte

	cmp dl, 0ah
	jb @@isDigit
	add dl, 55			;;is letter
	jmp @@printByte

	@@isDigit:
	add dl, '0'

	@@printByte:
	mov ah, 2
	int 21h
ENDM

cseg segment
assume cs:cseg, ds:dseg

clearScreen proc
	push ax dx

	mov ah, 2
	mov dl, 10

	rept 50
		int 21h
	ENDM

	mov dl, 0
	mov dh, 0
	int 10h
	
	pop dx ax
	ret
clearScreen endP

dropLine proc
	push ax dx

	mov dl, 10
	mov ah, 2
	int 21h
	mov dl, 13
	int 21h

	pop dx ax
	ret
dropLine endP

	Begin:
		mov ax, dseg
		mov ds, ax

		call clearScreen

		mov ah, 9
		mov dx, offset firstNumMsg
		int 21h

		call dropLine
		
		mov di, firstNum
		printWord di

		call dropLine

		mov ah, 9
		mov dx, offset secondNumMsg
		int 21h
		
		call dropLine

		mov di, secondNum
		printWord di

		call dropLine

		mov di, firstNum
		add di, secondNum

		mov addition, di

		mov di, firstNum
		sub di, secondNum

		mov subtraction, di

		mov ah, 9
		mov dx, offset addMsg
		int 21h
		
		call dropLine

		mov di, addition
		printWord di

		call dropLine

		mov ah, 9
		mov dx, offset subMsg
		int 21h

		call dropLine

		mov di, subtraction
		printWord di

		call dropLine

	Finish:
		mov ah, 8
		int 21h
		int 3
cseg ends
end Begin
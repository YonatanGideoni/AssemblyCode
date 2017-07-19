locals

printWord MACRO number
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

dseg segment
	firstNum dw ?
	secondNum dw ?
	addition dw ?
	subtraction dw ?
	multiplication dw ?
	division dw ?
dseg ends

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

	
	Finish:
		mov ah, 8
		int 21h
		int 3
cseg ends
end Begin
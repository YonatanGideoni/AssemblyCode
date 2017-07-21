locals
float struc
	exponent db ?
	mantissa1 db ?
	mantissa2 dw ?
float ends

dseg segment
	firstFloat float <3+127,01110000b,0000000000000000b/2>	;9.5
	secondFloat float <2+127,10000000b,0000000000000000b>	;-4
	
	negThreshold = 10000000b
dseg ends

cseg segment
assume cs:cseg, ds:dseg

uprintWord MACRO number
	local @@endMacro
	mov ah, 2

	mov cx, number		;;firstDigit
	mov dl, ch
	shr dl, 4
	printNibble dl

	mov dl, ch
	and dl, 0fh		;;secondDigit
	printNibble dl

	mov dl, cl
	shr dl, 4			;;thirdDigit
	printNibble dl

	mov dl, cl
	and dl, 0fh		;;fourthDigit
	printNibble dl	
	@@endMacro:
ENDM


printNibble MACRO byte
	local @@printNibble
	local @@isDigit
	mov dl, byte

	cmp dl, 0ah
	jb @@isDigit
	add dl, 55			;;is letter
	jmp @@printNibble

	@@isDigit:
	add dl, '0'

	@@printNibble:
	mov ah, 2
	int 21h
ENDM

printFloat MACRO floatOffset
		mov ch, ds:[floatOffset].mantissa1
		mov si, ds:[floatOffset].mantissa2
		
		cmp ch, negThreshold
		jb @@isPos
		shl ch, 1
		shr ch, 1
		mov dl, '-'
		mov ah, 2
		int 21h	
		
	@@isPos:
		mov dl, '1'
		mov ah, 2
		int 21h
		mov dl, '.'
		int 21h
		
		mov cl, 0
		xchg cl, ch
		clc
		rcl si, 1
		rcl cx, 1
		
		mov ch, cl
		
		shr cl, 4
		printNibble cl
		
		and ch, 0fh
		printNibble ch
				
		uprintWord si

		mov cl, ds:[floatOffset].exponent
		
		mov dl,'x'
		int 21h
		mov dl,'2'
		int 21h
		mov dl, '^'
		int 21h
		
		sub cl, 127
		cmp cl, 0
		jnl @@isPosExp
		neg cl
		mov dl, '-'
		int 21h
		
	@@isPosExp:
		mov ch,cl
		shr ch, 4
		printNibble ch
		
		and cl, 0fh
		printNibble cl
	ENDM	

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
		
		mov di, offset firstFloat
		
		printFloat di
	
	Finish:
		int 3
cseg ends
end Begin
locals
float struc
	exponent db ?
	mantissa1 db ?
	mantissa2 dw ?
float ends

dseg segment
	;;variables
	firstFloat float <3+127,00011000b,0000000000000000b/2>	;9.5
	secondFloat float <2+127,10000000b,0000000000000000b/2>	;-4
	
	oneFloat float <0+127,0,0>	;1
	
	helperArr db (256+24)/8 dup(?)
	helperArrLEN = $-helperArr
	
	additionFloat float <?,?,?>
	
	;;misc. constants
	negThreshold = 10000000b
	
	;;text messages
	firstFloatMsg db "This is the first float:$"
	secondFloatMsg db "This is the second float:$"
	additionMsg db "This is the result of their addition:$"
dseg ends

cseg segment
assume cs:cseg, ds:dseg

addFloat MACRO float1Offset, float2Offset
	
ENDM

findBiggestFloat proc
	push ax bx cx bp
	mov bp, sp
	mov ax, ss:[bp+12]
	mov bx, ss:[bp+14]
	
	cmp ax.mantissa1, negThreshold
	ja firstIsNeg
	cmp bx.mantissa1, negThreshold
	jb bothSameSign
	mov cx, 0		;if first is pos and second is neg, then first>second
	jmp endFunc
	
firstIsNeg:
	cmp bx.mantissa1, negThreshold
	ja bothSameSign
	mov cx, 1	;if first is neg and second is pos then second>first
	jmp endFunc
	
bothSameSign:
	cmp ax.exponent, bx.exponent
	je bothSameExponent
	
	
bothSameExponent:
	
endFunc:
	mov ss:[bp+14], cx
	pop bp cx bx ax
	ret 2
endp findBiggestFloat

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
		local @@isPos
		local @@isPosExp
		
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
		
		mov ah, 9
		mov dx, offset firstFloatMsg
		int 21h
		
		call dropLine
		
		printFloat di
		
		call dropLine
		
		mov di, offset secondFloat
		
		mov ah, 9
		mov dx, offset secondFloatMsg
		int 21h
		
		call dropLine
		
		printFloat di
		
		call dropLine
		
		mov ah, 9
		mov dx, offset additionMsg
		int 21h
		
		call dropLine
	Finish:
		int 3
cseg ends
end Begin
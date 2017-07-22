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
	shiftNum db ?
	
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
	local @@firstIsBigger
	local @@firstIsNeg
	local @@startAdd
	local @@checkCond
	
	mov bx, float1Offset
	mov si, float2Offset
	push bx si
	call findBiggestFloat
	pop cx
	cmp cx, 0
	je @@firstIsBigger
	mov al, ds:[float2Offset].mantissa2
	rcl al, 1
	sign = cf
	jmp @@checkCond
	
@@firstIsBigger:
	mov al, ds:[float1Offset].mantissa1
	rcl al, 1
	sign = cf

@@checkCond:
	mov al, ds:[float1Offset].mantissa1
	rcl al, 1
	jnc @@firstIsPos
	jmp @@firstIsNeg
	
	
@@firstIsPos:
	mov bl, ds:[float2Offset].mantissa1
	rcl bl, 1
	jc @@secondIsNeg
	
	cmp sign,0
	je @@condIsAdd	;;if end-sign is positive and both are positive, then addition is needed between them
	cond=sub
	jmp @@startAdd
	
@@firstIsNeg:


@@secondIsNeg:
	
@@condIsAdd:
	cond=add
	
@@startAdd:
	mov bl, ds:[float1Offset].exponent
	rcr al, 1
	or al, negThreshold		;;add implicit 1
	mov ch, al
	mov ah, 0
	mov al, bl
	mov bl, helperArrLEN
	div bl
	mov bl, al	;;spot in array
	mov shiftNum, ah	;;bits to shift in array
	mov al, ch
	mov bh, 0
	mov al, helperArr[bx]
	mov ax, ds:[float1Offset].mantissa2
	mov ah, helperArr[bx+1]
	mov al, helperArr[bx+2]
	shiftInArr bx
ENDM

shiftInArr MACRO arrPos
	local @@shiftLoop
	mov cx, shiftNum
	clc
	
@@shiftLoop:
	rcl helperArr[arrPos+2],1
	rcl helperArr[arrPos+1],1
	rcl helperArr[arrPos],1
	rcl helperArr[arrPos-1],1
	clc
	loop @@shiftLoop
ENDM

findBiggestFloat proc
	push ax bx cx bp
	mov bp, sp
	mov bx, ss:[bp+12]
	mov al, ds:[bx].mantissa1
	mov bx, ss:[bp+10]
	mov bl, ds:[bx].mantissa1
	
	cmp al, negThreshold
	jae firstIsNeg
	cmp bl, negThreshold
	jbe bothSameSign
	mov cx, 0		;if first is pos and second is neg, then first>second
	jmp endFunc
	
firstIsNeg:
	cmp bl, negThreshold
	jae bothSameSign
	mov cx, 1	;if first is neg and second is pos then second>first
	jmp endFunc
	
bothSameSign:
	mov bx, ss:[bp+12]
	mov al, ds:[bx].exponent
	mov bx, ss:[bp+10]
	mov bl, ds:[bx].exponent
	cmp al, bl
	je bothSameExponent
	ja firstIsBiggerExponent
	mov cx, 1
	jmp endFunc
	
bothSameExponent:
	mov bx, ss:[bp+12]
	mov al, ds:[bx].mantissa1
	mov bx, ss:[bp+10]
	mov bl, ds:[bx].mantissa1
	cmp al,bl
	je bothSameMantissa1
	ja firstIsBigger
	mov cx, 1
	jmp endFunc
	
bothSameMantissa1:
	mov bx, ss:[bp+12]
	mov ax, ds:[bx].mantissa2
	mov bx, ss:[bp+10]
	mov bx, ds:[bx].mantissa2
	cmp ax,bx
	jae firstIsBigger
	mov cx, 1
	jmp endFunc
	
firstIsBiggerExponent:
	mov bx, ss:[bp+12]
	mov al, ds:[bx].mantissa1
	rcl al, 1
	jnc firstIsBigger	;if mantissa is positive, first>second
	
	mov cx, 1
	jmp endFunc
	
firstIsBigger:
	mov cx, 0
	
endFunc:
	mov ss:[bp+12], cx
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
		
		mov bx, offset firstFloat
		mov si, offset secondFloat
		addFloat bx, si
		
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
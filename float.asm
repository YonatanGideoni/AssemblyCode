locals
float struc
	exponent db ?
	mantissa1 db ?
	mantissa2 dw ?
float ends

dseg segment
	;;variables
	firstFloat float <3+127,00011000b,0000000000000000b/2>	;9.5
	secondFloat float <2+127,11000000b,0000000000000000b/2>	;-6
	
	oneFloat float <0+127,0,0>	;1
	helperFloat float <?,?,?>
	helperFloat2 float <?,?,?>
	
	helperArr db (256+24)/8 dup(?)
	helperArrLEN = $-helperArr
	helperArr2 db (256+24)/8 dup(?)
	shiftNum db ?
	sign db 0
	mulSign db 0
	cond db 0
	isBigger dw 0
	
	additionFloat float <?,?,?>
	multiplicationFloat float <?,?,?>
	
	;;misc. constants
	negThreshold = 10000000b
	
	;;text messages
	firstFloatMsg db "This is the first float:$"
	secondFloatMsg db "This is the second float:$"
	additionMsg db "This is the result of their addition:$"
	subtractionMsg db "This is the result of their subtraction:$"
dseg ends

cseg segment
assume cs:cseg, ds:dseg

mulFloat MACRO float1Offset, float2Offset
	local @@resultSignIsNeg
	local @@startMantissaMul
	local @@multiplyFloats
	local @@contLoop
	local @@resultIsPos
	local @@gotoContLoop
	local @@endLoop
	
	mov mulSign,0
	
	mov al, ds:[float1Offset].mantissa1
	mov ah, ds:[float2Offset].mantissa1
	mov bl,0
	rcl al,1
	adc bl,0	;;check if numbers have same sign
	rcl ah,1
	adc bl,0
	cmp bl,1
	je @@resultSignIsNeg
	mov mulSign, 0
	jmp @@startMantissaMul
	
@@resultSignIsNeg:
	mov mulSign,1
	
@@startMantissaMul:
	mov helperFloat.exponent, 127
	mov helperFloat2.exponent, 127
	mov al, ds:[float1Offset].mantissa1
	or al, negThreshold					;;isolate mantissa's in helper floats
	mov helperFloat.mantissa1, al
	mov ax, ds:[float1Offset].mantissa2
	mov helperFloat.mantissa2, ax
	mov al, ds:[float2Offset].mantissa1
	and al, 7fh
	mov helperFloat2.mantissa1, al
	mov ax, ds:[float2Offset].mantissa2
	mov helperFloat2.mantissa2, ax
	
	mov additionFloat.mantissa1,0
	mov additionFloat.mantissa2,0
	mov additionFloat.exponent, 127
	
	mov cx,24
	jmp @@multiplyFloats
	
@@gotoContLoop:
	jmp @@contLoop
	
@@multiplyFloats:
	clc
	rcr helperFloat.mantissa1,1
	rcr helperFloat.mantissa2,1
	jnc @@gotoContLoop
	
	push cx
	
	mov al, 127
	sub al,cl
	mov helperFloat2.exponent,al
	
	push si di
	
	mov si, offset additionFloat
	mov di, offset helperFloat2
	
	addFloat di, si
	
	pop di si
	
	pop cx
@@contLoop:
	loop @@gotoMultiplyFloats
	jmp @@endLoop
	
@@gotoMultiplyFloats:
	jmp @@multiplyFloats
	
@@endLoop:
	clc
	rcl additionFloat.mantissa2,1
	rcl additionFloat.mantissa1,1
	
	
	mov al, ds:[float1Offset].exponent
	add al, ds:[float2Offset].exponent
	sub al, 127
	sub additionFloat.exponent, 127
	add al, additionFloat.exponent	;;correct exponent if during mantissa multiplication exponent shifted
	mov multiplicationFloat.exponent, al
	
	mov al, additionFloat.mantissa1
	cmp mulSign,0
	je @@resultIsPos
	or al, negThreshold
	jmp @@getResult
	
@@resultIsPos:
	and al, 7fh
	
@@getResult:
	mov multiplicationFloat.mantissa1, al
	mov ax, additionFloat.mantissa2
	mov multiplicationFloat.mantissa2, ax
ENDM

addFloat MACRO float1Offset, float2Offset
	local @@firstIsBigger
	local @@firstIsNeg
	local @@startAdd
	local @@checkCond
	local @@sub1From2
	local @@sub2From1
	local @@contAddMantissa
	local @@condIsAdd
	local @@firstIsPos
	local @@noShiftExp
	local @@addExponent
	local @@addMantissa
	local @@lowerExponent
	local @@increaseExponent
	local @@convertToFloat
	local @@firstIsBiggerExponent
	local @@additionIsPos
	local @@addArrays
	local @@contShiftExp
	local @@contExponentCheck
	local @@shiftExpCheck
	
	mov sign,0
	mov cond,0
	mov isBigger,0
	
	mov bx, float1Offset
	mov si, float2Offset
	push bx si
	call findBiggestFloatAbs
	pop cx
	mov isBigger, cx
	cmp cx, 0
	je @@firstIsBigger
	mov al, ds:[float2Offset].mantissa1	;;because second is smaller, checks if it's pos or neg
	rcl al, 1
	adc sign,0
	jmp @@checkCond
	
@@firstIsBigger:
	mov al, ds:[float1Offset].mantissa1
	rcl al, 1
	adc sign,0

@@checkCond:
	mov al, ds:[float1Offset].mantissa1
	rcl al, 1
	jnc @@firstIsPos
	jmp @@firstIsNeg
	
	
@@firstIsPos:
	mov bl, ds:[float2Offset].mantissa1
	rcl bl, 1
	jnc @@condIsAdd
	mov cond,1
	jmp @@startAdd
	
@@firstIsNeg:
	mov bl, ds:[float2Offset].mantissa1
	rcl bl, 1
	jc @@condIsAdd
	mov cond,1
	jmp @@startAdd
	
@@condIsAdd:
	mov cond,0
	
@@startAdd:
	mov bl, ds:[float1Offset].exponent
	mov al, ds:[float1Offset].mantissa1
	or al, negThreshold		;;add implicit 1
	mov ch, al
	mov ah, 0
	mov al, bl
	mov bl, 8
	div bl
	mov bl, al	;;spot in array
	mov shiftNum, ah	;;bits to shift in array
	mov al, ch
	mov bh, 0
	mov helperArr[bx], al
	mov ax, ds:[float1Offset].mantissa2
	mov helperArr[bx+1], ah
	mov helperArr[bx+2], al
	shiftInArr bx, helperArr
	
	mov bl, ds:[float2Offset].exponent
	mov al, ds:[float2Offset].mantissa1
	or al, negThreshold		;;add implicit 1
	mov ch, al
	mov ah, 0
	mov al, bl
	mov bl, 8
	div bl
	mov bl, al	;;spot in array
	mov shiftNum, ah	;;bits to shift in array
	mov al, ch
	mov bh, 0
	mov helperArr2[bx], al
	mov ax, ds:[float2Offset].mantissa2
	mov helperArr2[bx+1], ah
	mov helperArr2[bx+2], al
	shiftInArr bx, helperArr2

	mov ax,0
	mov dx,0
	mov cx,0
	mov bx, helperArrLEN-1
	cmp cond, 0
	je @@addArrays
	mov ah, 1
	cmp isBigger, 0
	je @@sub2From1
	jmp @@sub1From2
	
@@sub2From1:
	mov dl, helperArr[bx]
	add cl, helperArr2[bx]
	add ax, dx
	sub ax, cx
	mov helperArr[bx], al
	not ah
	and ah, 1
	mov cl, ah
	mov ah, 1
	mov al, 0
	dec bx
	jnz @@sub2From1
	jmp @@convertToFloat

@@sub1From2:
	mov dl, helperArr2[bx]
	add cl, helperArr[bx]
	add ax, dx
	sub ax, cx
	mov helperArr[bx], al
	not ah
	and ah, 1
	mov cl, ah
	mov ah, 1
	mov al, 0
	dec bx
	jnz @@sub2From1
	jmp @@convertToFloat

@@addArrays:
	mov dl, helperArr[bx]
	mov cl, helperArr2[bx]
	add ax, dx
	add ax, cx
	mov helperArr[bx], al
	mov al,0
	xchg al, ah
	dec bx
	jnz @@addArrays
	jmp @@convertToFloat
	
@@convertToFloat:
	mov al, ds:[float1Offset].exponent
	mov ah, ds:[float2Offset].exponent
	cmp al, ah
	ja @@firstIsBiggerExponent
	mov al, ah
	
@@firstIsBiggerExponent:
	mov ch, al
	mov bl, 8
	mov ah, 0
	div bl
	mov bl, al	;;spot in array
	mov bh, 0
	mov shiftNum, ah	;;bits to shift in array
	mov al, 1
	mov dl, shiftNum
	dec dl
	cmp dl, 0
	jz @@noShiftExp
	
@@contShiftExp:
	shl al,1
	dec dl
	jnz @@contShiftExp
@@noShiftExp:
	dec bx
	cmp al, helperArr[bx]
	ja @@lowerExponent		;;normalize exponent
	shl al, 1
	cmp al, 0
	jne @@contExponentCheck
	mov al,1
	inc bx
	
@@contExponentCheck:
	cmp al, helperArr[bx]
	jbe @@increaseExponent
	jmp @@addExponent
	
@@increaseExponent:
	inc ch
	jmp @@addExponent
	
@@lowerExponent:
	dec ch
	shr al,1
	cmp al,0
	je @@shiftExpCheck
	cmp al, helperArr[bx]
	ja @@lowerExponent
	jmp @@addExponent
	
@@shiftExpCheck:
	inc bx
	cmp al, helperArr[bx]
	ja @@lowerExponent
	
@@addExponent:
	mov additionFloat.exponent, ch
	jmp @@addMantissa
	
@@addMantissa:
	alignArrBits helperArr
	findFirstBit helperArr
	mov al, helperArr[bx]
	shl al,1
	shr al,1
	cmp sign, 0
	je @@additionIsPos	;;turn result neg or pos
	or al, negThreshold
	jmp @@contAddMantissa
	
@@additionIsPos:
@@contAddMantissa:
	mov additionFloat.mantissa1, al
	
	mov ah, helperArr[bx-1]
	mov al, helperArr[bx-2]
	mov additionFloat.mantissa2, ax
	
	clearArr helperArr, helperArrLEN
	clearArr helperArr2, helperArrLEN
ENDM

findFirstBit MACRO arr
	local @@findBits
	local @@exitMacro
	
	mov bx, 0
	
@@findBits:
	cmp &arr[bx],0
	jne @@exitMacro
	inc bx
	jmp @@findBits
	
@@exitMacro:
ENDM

alignArrBits MACRO arr
	local @@startAligning
	findFirstBit arr
	
@@startAligning:
	clc
	rcl &arr[bx+3],1
	rcl &arr[bx+2],1
	rcl &arr[bx+1],1
	rcl &arr[bx],1
	rcl &arr[bx-1],1
	cmp &arr[bx-1], negThreshold
	jb @@startAligning
ENDM

shiftInArr MACRO arrPos, arr
	local @@shiftLoop
	mov cl, shiftNum
	mov ch,0
	clc
	
@@shiftLoop:
	rcl &arr[arrPos+2],1
	rcl &arr[arrPos+1],1
	rcl &arr[arrPos],1
	rcl &arr[arrPos-1],1
	rcl &arr[arrPos-2],1
	clc
	loop @@shiftLoop
ENDM

findBiggestFloatAbs proc
	push ax bx cx bp
	mov bp, sp
	
	mov bx, ss:[bp+12]
	mov al, ds:[bx].exponent
	mov bx, ss:[bp+10]
	mov bl, ds:[bx].exponent
	cmp al, bl
	je bothSameExponent
	ja firstIsBigger
	mov cx, 1
	jmp endFunc
	
bothSameExponent:
	mov bx, ss:[bp+12]
	mov al, ds:[bx].mantissa1
	shl al,1
	shr al,1
	mov bx, ss:[bp+10]
	mov bl, ds:[bx].mantissa1
	shl bl,1
	shr bl,1
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
	
firstIsBigger:
	mov cx, 0
	
endFunc:
	mov ss:[bp+12], cx
	pop bp cx bx ax
	ret 2
endp findBiggestFloatAbs

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

clearArr MACRO arr, arrLEN
	local @@cleanLoop

	mov bx, arrLEN
	dec bx
	mov cx, arrLEN
	dec cx
	
@@cleanLoop:
	mov &arr[bx],0
	dec bx
	loop @@cleanLoop
	
	mov &arr[0], 0
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
		
		mov di, offset firstFloat
		mov si, offset secondFloat
		addFloat di, si		
		
		mov di, offset additionFloat
		printFloat di
		
		call dropLine
		
		mov ah, 9
		mov dx, offset subtractionMsg
		int 21h
		
		call dropLine
		
		mov al, secondFloat.exponent
		mov ah, secondFloat.mantissa1
		mov bx, secondFloat.mantissa2
		
		xor ah, negThreshold		;change last bit to inverse in order to change sign
		
		mov helperFloat.exponent, al
		mov helperFloat.mantissa1, ah
		mov helperFloat.mantissa2, bx
		
		mov di, offset firstFloat
		mov si, offset helperFloat
		addFloat di, si		
		
		mov di, offset additionFloat
		printFloat di
		
		call dropLine
		
		
		call dropLine
		
		mov di, offset firstFloat
		mov si, offset secondFloat
		mulFloat di, si
		
		mov di, offset multiplicationFloat
		printFloat di
		
	Finish:
		int 3
cseg ends
end Begin
locals
tree struc
	Left	dw	?
	Info	db	?
	Right	dw	?
tree ends

dseg segment
	t1	tree	<t2,1,t3>
	t2	tree	<t4,2,t5>
	t3	tree	<t6,3,t7>
	t4	tree	<t8,4,t9>
	t5	tree	<t10,5,t11>	
	t6	tree	<t12,6,t13>
	t7	tree	<t14,7,t15>
	t8	tree	<null,8,null>
	t9	tree	<null,9,null>
	t10	tree	<null,10,null>
	t11	tree	<null,11,null>
	t12	tree	<null,12,null>
	t13	tree	<null,13,null>
	t14	tree	<null,14,null>
	t15	tree	<null,15,null>
	null dw 666

	deltaX dw ?
	deltaY dw ?
	lineError dw ?
	startY dw ?
	startX dw ?
	endY dw ?
	endX dw ?
	lineColor db 15
	windowLength = 640
	windowHeight = 480
dseg ends

cseg segment
assume cs:cseg, ds:dseg

drawLine MACRO
		mov cx, endX
		cmp startX, cx
		jc @@noSwitchCoord	;;draw the line from left to right, switch coords if endX > startX
		mov ax, startX
		mov startX, cx
		mov endX, ax
		mov cx, endY
		mov ax, startY
		mov startY, cx
		mov endY, ax

	@@noSwitchCoord:
		mov ax, endY
		mov deltaY, ax
		mov ax, startY
		sub deltaY, ax
		mov ax, endX
		mov deltaX, ax
		mov ax, startX
		sub deltaX, ax
		mov cx, startX
		mov dx, startY
		mov ax, deltaY
		add ax, deltaY
		sub ax, deltaX
		mov lineError, ax
		mov ah, 0ch
		mov al, lineColor
		mov di, deltaY
		mov si, deltaX
		cmp di, 0f000h
		jc @@downOct
		mov bx, startY
		sub bx, endY
		mov deltaY, bx
		mov di, bx
		add bx, di
		sub bx, deltaX
		mov lineError, bx
		cmp lineError, 0a000h
		jc @@cont1
		mov bx, 0
		sub bx, lineError
		mov lineError, bx
	@@cont1:
		add di, di
		add si, si
		mov bh, 0
		mov bl, lineColor
		cmp di, si
		jc @@drawLine_Oct2
		jmp @@drawLine_Oct1
	@@downOct:
		cmp lineError, 0a000h
		jc @@cont2
		mov bx, 0
		sub bx, lineError
		mov lineError, bx
	@@cont2:
		add di, di
		add si, si
		mov bh, 0
		mov bl, lineColor
		cmp di, si
		jc @@drawLine_Oct3
		jmp @@drawLine_Oct4 

	@@drawLine_Oct1:
		cmp lineError, 0a000h		
		jc @@decY_Oct1
		inc cx
		add lineError, di
		jmp @@drawLine_Oct1
	@@decY_Oct1:
		dec dx
		int 10h		
		sub lineError, si
		cmp dx, endY
		jz @@endMacro
		jmp @@drawLine_Oct1

	@@drawLine_Oct2:
		cmp lineError, 0a000h
		jc @@incX_Oct2
		dec dx
		add lineError, si
		jmp @@drawLine_Oct2
	@@incX_Oct2:
		inc cx
		int 10h
		sub lineError, di
		cmp cx, endX
		jz @@endMacro
		jmp @@drawLine_Oct2

	@@drawLine_Oct3:
		cmp lineError, 0a000h		;check if overflowed
		jc @@incX_Oct3
		inc dx						;inc y coordinate
		add lineError, si
		jmp @@drawLine_Oct3
	@@incX_Oct3:
		inc cx
		int 10h
		sub lineError, di
		cmp cx, endX			;check if end of line
		jz @@endMacro
		jmp @@drawLine_Oct3

	@@drawLine_Oct4:
		cmp lineError, 0a000h		
		jc @@incY_Oct4
		inc cx
		add lineError, di
		jmp @@drawLine_Oct4
	@@incY_Oct4:
		inc dx
		int 10h
		sub lineError, si
		cmp dx, endY
		jz @@endMacro
		jmp @@drawLine_Oct4
	@@endMacro:
	ENDM

printTree proc
		push ax bx cx dx bp

		mov bp, sp
		mov ax, ss:[bp+12]	;node
		mov bx, ss:[bp+14]	;startY
		mov cx, ss:[bp+16]	;startX
		
		mov startY, bx
		mov startX, cx

		mov bx, ss:[bp+18]	;endY
		mov cx, ss:[bp+20]	;endX

		mov endY, bx
		mov endX, cx

		mov bx, ss:[bp+12]
		mov al, ds:[bx].Info
		mov lineColor, al
		
		drawLine
		
		mov bx, ss:[bp+12]
		mov bx, ds:[bx].Left
		cmp bx, offset null
		jz @@checkRightBranch
		
		mov ax, ss:[bp+18]
		mov cx, ss:[bp+20]
		
		add ax, 30
		sub cx, 30

		push cx
		push ax

		mov ax, ss:[bp+18]
		mov cx, ss:[bp+20]

		push cx
		push ax

		push bx
		call printTree

	@@checkRightBranch:
		mov bx, ss:[bp+12]
		mov bx, ds:[bx].Right
		cmp bx, offset null
		jz @@endFunc

		mov ax, ss:[bp+18]
		mov cx, ss:[bp+20]
		
		add ax, 30
		add cx, 30

		push cx
		push ax

		mov ax, ss:[bp+18]
		mov cx, ss:[bp+20]

		push cx
		push ax

		push bx
		call printTree

	@@endFunc:
		pop bp dx cx bx ax
		ret 10
printTree endP

	Begin:
		mov ax, dseg
		mov ds, ax

	startDraw:
		mov ax, 12h	;switch to graphics mode
		int 10h

		mov ax, 10
		push ax
		mov ax, 10
		push ax
		mov ax, 1
		push ax
		mov ax, 1
		push ax
		mov ax, offset t15
		push ax

		call printTree
	Finish:
		int 3
cseg ends
end Begin
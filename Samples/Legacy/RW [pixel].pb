; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Read/write pixel'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")


;initialization
xAppTitle ("Read/Write Pixel")
xGraphics3D(640, 480, 32, #False, #False)

;enabling antialiasing
xAntiAlias(#True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPIC)

;loading tht image
img = xLoadImage("media/textures/stones_normal.tga")

;pixel array
Dim pix(xGraphicsWidth(), xGraphicsHeight()) 

;main loop
While Not(xKeyHit(1) Or xWinMessage("WM_CLOSE"))
	xRenderWorld()
	;clearing the screen
	xCls()
	
	;drawing the image
	xDrawImage(img, 0, 0)
	xText(10, 10, "Some text here...")
	
	;backbuffer locking
	xLockBuffer(xBackBuffer())
	
	;writing the pixels to the array
	For y = 0 To xGraphicsHeight() - 1
		For x = 0 To xGraphicsWidth() - 1
			pix(x, y) = xReadPixelFast(x, y)
		Next
	Next
	
	;clearing the screen
	xCls()
	
	;reading the pixels in descending order
	For y = 0 To xGraphicsHeight() - 1
		For x = 0 To xGraphicsWidth() - 1
			xWritePixelFast(x, y, pix(x, xGraphicsHeight() - y - 1))
		Next
	Next
	
	;unclocking the backbuffer
	xUnlockBuffer(xBackBuffer())
	
	;drawing the scene
	xFlip()
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Camera Viewport'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare Garbage(n.i = 100)

xCreateLog()

xGraphics3D(1024,768, 32, 0, 1)
xSetBuffer(xBackBuffer())

; Create first camera
Define cam1 = xCreateCamera()

; Set the first camera's viewport so that it fills the top half of the  camera
Define w = xGraphicsWidth()
Define h = xGraphicsHeight()/1.777
xCameraViewport(cam1, 0, (xGraphicsHeight() - h)/2, w, h)
xCameraViewport(cam1, 1025, 769, 1024, 768)

Define light = xCreateLight()
xRotateEntity(light,90,0,0)

Garbage()

back = xCreateCube()
xEntityColor(back, 255, 0, 0)
xFlipMesh(back)
xScaleEntity(back, 500, 500, 500)

While Not xKeyDown(1)
	xCls()
	If xKeyDown( 205 )=#True : xTurnEntity(cam1,0,-1,0)     : EndIf
	If xKeyDown( 203 )=#True : xTurnEntity(cam1,0,1,0)     : EndIf
	If xKeyDown( 208 )=#True : xMoveEntity(cam1,0,0,-0.05) : EndIf
	If xKeyDown( 200 )=#True : xMoveEntity(cam1,0,0,0.05)  : EndIf
	
	xRenderWorld()
	
	xText(10, 10, "Use cursor keys to move first camera")
	
	xFlip()
	
Wend

End

Macro Rnd(MinVal, MaxVal) ; Pseudo-procedure.
((Random((MaxVal - MinVal) * 1000.0) + MinVal * 1000.0) / 1000.0)
EndMacro

Procedure Garbage(n.i = 100)
	For i = 1 To n
		cube = xCreateCube()
		xPositionEntity(cube, Rnd(-20.0, 20.0), Rnd(-20.0, 20.0), Rnd(-20.0, 20.0))
		xTurnEntity(cube, Random(360), Random(360), Random(360))
		xEntityColor(cube, Rnd(127, 255), Rnd(127, 255), Rnd(127, 255))
	Next
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Overlay3D'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare Garbage(num.i = 40)
Declare CameraControl()
Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

xGraphics3d(1024, 768, 32, 0, 1)

xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
Global mousespeed.f       = 0.5
Global camerasmoothness.f = 4.5
Global camxa.f = 0
Global camya.f = 0

Global camera = xCreateCamera()
xCameraClsColor(camera, 64, 64, 64)
Define light = xCreateLight()

Global cube = xCreateCube(camera)
xRotateEntity(cube, 30.0, 15.0, 0.0)
xScaleEntity(cube, 0.25, 0.25, 0.25)
xPositionEntity(cube, -2.0, 1.35, 5.0)
xEntityColor(cube, 255, 128, 0)

Garbage()

Global drawOverlay = 1

While Not xKeyHit(#KEY_ESCAPE)
	
	If xKeyHit(57)
		drawOverlay = 1 - drawOverlay
	EndIf
	
	xTurnEntity(cube, 0.1, -0.1, 0.1)
	CameraControl()
	
	xRenderWorld()
	
	xColor(128, 0, 255)
	xRect(35, 35, 210, 210, 1)
	
	If drawOverlay
		xCameraClsMode(camera, #False, #True)
		xShowEntity(cube)
		xRenderEntity(camera, cube)
		xCameraClsMode(camera, #True, #True)
		xHideEntity(cube)
	EndIf
	
	xColor(255, 255, 255)
	
	xText(10, xGraphicsHeight() - 60, "WASD to move camera")
	xText(10, xGraphicsHeight() - 40, "Mouse to rotate camera")
	xText(950, 740, Str(xTrisRendered()))
	
	xFlip()
Wend

End

Macro Rnd(MinVal, MaxVal) ; Pseudo-procedure.
((Random((MaxVal - MinVal) * 1000.0) + MinVal * 1000.0) / 1000.0)
EndMacro

Procedure Garbage(num.i = 40)
	Define i.i
	
	For i = 1 To num
		Define r.i = Rnd(128, 255)
		Define g.i = Rnd(128, 255)
		Define b.i = 383 - r
		Define obj = xCreateCube()
		xPositionEntity(obj, Rnd(-25.0, 25.0), Rnd(-25.0, 25.0), Rnd(25.0, 45.0))
		xEntityColor(obj, r, g, b)
		xScaleEntity(obj, Rnd(0.75, 1.5), Rnd(0.75, 1.5), Rnd(0.75, 1.5))
	Next
EndProcedure

Procedure CameraControl()
	If xKeyDown(#KEY_W) : xMoveEntity(camera,  0,  0,  1.0) : EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(camera,  0,  0, -1.0) : EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(camera, -1.0,  0,  0) : EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(camera,  1.0,  0,  0) : EndIf
	Define mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	Define mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
  Define Tmp.i = mxs : Tmp % 360
  camxa.f = camxa - tmp
	camya.f = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
EndProcedure

Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Simple'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Simple sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 0, 0, -10)

; create cube
cube = xCreateCube()

; loading logo from file
logoTexture = xLoadTexture("media\textures\logo.jpg")

; texture cube
xEntityTexture(cube, logoTexture)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; main program loop
While Not xKeyDown(#KEY_ESCAPE)

	; camera control
	If xKeyDown(#KEY_W) : xMoveEntity(camera,  0,  0,  1) : EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(camera,  0,  0, -1) : EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(camera, -1,  0,  0) : EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(camera,  1,  0,  0) : EndIf
	mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	Fix = Int(mxs) % 360 + (mxs - Int(mxs))
	camxa.f = camxa - Fix
	camya.f = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
	
	; turn cube
	xTurnEntity(cube, 0, 1, 0)
	
	; render scene
	xRenderWorld()
	
	; switch back buffer
	xFlip()
	
Wend

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
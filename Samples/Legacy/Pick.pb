; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Pick'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)
xSetBuffer(xBackBuffer())

; create camera
camera=xCreateCamera() 
xPositionEntity(camera, 0, 2, -10)

; create light
light = xCreateLight() 
xRotateEntity(light, 45, 45, 45)

; create cube
cube = xCreateCube() 
xEntityPickMode(cube, 2) ; Make the cube entity 'pickable'. Use pick_geometry mode no.2 for polygon collision. 
xPositionEntity(cube, 0, 0, 0)
xRotateEntity(cube, 0, 45, 0)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; main loop
While Not xKeyhit( 1 ) 

; camera control
	If xKeyDown(#KEY_W) : xMoveEntity(camera,  0,  0,  1): EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(camera,  0,  0, -1): EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(camera, -1,  0,  0): EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(camera,  1,  0,  0): EndIf
	mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	Fix = Int(mxs) % 360 + (mxs - Int(mxs))
	camxa.f = camxa - Fix
	camya.f = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
		
	; If left mouse button is hitted then use CameraPick with mouse coordinates 
	; only three things can be picked in this example: the plane, the cube or nothing 
	If xMouseHit(1) : xCameraPick(camera, xMouseX(), xMouseY()) : EndIf
	
	; render scene
	xRenderWorld()
	
	; draw picking info
	xText(0, 20, "Use cursor keys to move")
	xText(0, 40, "Press left mouse button to use CameraPick with mouse coordinates")
	xText(0, 60, "PickedX: " + StrF(xPickedX()))
	xText(0, 80, "PickedY: " + StrF(xPickedY()))
	xText(0, 100, "PickedZ: " + StrF(xPickedZ()))
	xText(0, 120, "PickedNX: " + StrF(xPickedNX()))
	xText(0, 140, "PickedNY: " + StrF(xPickedNY()))
	xText(0, 160, "PickedNZ: " + StrF(xPickedNZ()))
	xText(0, 180, "PickedTime: " + Str(xPickedTime()))
	xText(0, 200, "PickedEntity: " + Str(xPickedEntity()))
	xText(0, 220, "PickedSurface: " + Str(xPickedSurface()))
	xText(0, 240, "PickedTriangle: " + Str(xPickedTriangle()))
	xText(0, 280, "xMouseX(): " + Str(xMouseX()))
	xText(0, 300, "xMouseY(): " + Str(xMouseY()))
	
	; draw scene
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
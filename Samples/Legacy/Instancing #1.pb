; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Instancing'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Instancing sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #False)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 13, 13, -50)

; create cube
cube = xCreateCube()

; loading logo from file
logoTexture = xLoadTexture("media\textures\logo.jpg")

; texture cube
xEntityTexture(cube, logoTexture)

; load instancing shader
If xHWInstancingAvailable()
	shader = xLoadFXFile("media\shaders\hwinstancing.fx")
	instancingType.s = "Hardware"
ElseIf xShaderInstancingAvailable()
	shader = xLoadFXFile("media\shaders\shaderinstancing.fx")
	instancingType.s = "Shaders emulation"
EndIf
xSetEntityEffect(cube, shader)
xSetEffectTechnique(cube, "Instancing")

; create cube instances
For x = 0 To 9
	For y = 0 To 9
		For z = 0 To 9
			clone = xCreateInstance(cube)
			xPositionEntity(clone, x * 3, y * 3, z * 3)
		Next
	Next
Next

; hide original entity
xHideEntity(cube)

; create light source
light = xCreateLight()
xRotateEntity(light, 45, 0, 0)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5
camerasmoothness.f = 4.5

; main program loop
While Not xKeyDown(#KEY_ESCAPE)

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
	
	; render scene
	xRenderWorld()

	; draw info
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 50, "DIP calls: " + Str(xDIPCounter()))
	xText(10, 70, "Instncing type: " + instancingType)
	
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
; EnableXP
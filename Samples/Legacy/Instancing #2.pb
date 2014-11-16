; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Instancing 2'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)
Declare Wave()

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Instancing sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #False)

; hide mouse pointer
;xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()
xCameraClsColor(camera, 192, 168, 132)

; position camera
xPositionEntity(camera, -90, 90, -40)
camxa.f = -60
camya.f = 25

; create object
;obj = xCreateCube()
obj = xCreateCylinder(32)
xEntityColor(obj, 0, 0, 0)

; loading logo from file
tex0 = xLoadTexture("Media\Textures\tex0.png")
tex1 = xLoadTexture("Media\Textures\tex1.png")

; texture object
xEntityTexture(obj, tex0)

; load instancing shader
If xHWInstancingAvailable()
	shader = xLoadFXFile("media\shaders\hwinstancing2.fx")
	instancingType.s = "Hardware"
ElseIf xShaderInstancingAvailable()
	shader = xLoadFXFile("media\shaders\shaderinstancing.fx")
	instancingType.s = "Shaders emulation"
EndIf
xSetEntityEffect(obj, shader)
xSetEffectTechnique(obj, "Instancing")


Global max_x = 20
Global max_y = 20
Global max_z = 20
Global tick  = 0

Global Dim clone(max_x, max_y, max_z)

; create instances
For x = 0 To max_x
	For y = 0 To max_y
		For z = 0 To max_z
			clone(x, y, z) = xCreateInstance(obj)
			xPositionEntity(clone(x, y, z), x * 3, y * 3, z * 3)
			xRotateEntity(clone(x, y, z), 90 / max_x * x, 90 / max_y * y, 90 / max_z * z)
	    xEntityColor(clone(x, y, z), 255 / max_x * x, 255 / max_y * y, 255 / max_z * z)
		Next
	Next
Next

; hide original entity
xHideEntity(obj)

; create light source
light = xCreateLight()
xRotateEntity(light, 45, 0, 0)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

waving = 1
; main program loop
While Not xKeyDown(#KEY_ESCAPE)
	
	If waving
		Wave()
	EndIf
	If xKeyhit(#KEY_SPACE)
		waving = 1 - waving
	EndIf
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
	xText(10, 70, "Entities: " + Str((max_x * max_y * max_z)))
	xText(10, 90, "Instancing type: " + instancingType)
	
	; switch back buffer
	xFlip()
	
Wend

End

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure

Procedure Wave()
	time.f = ElapsedMilliseconds()
	For x = 0 To max_x
		For y = 0 To max_y
			For z = 0 To max_z
				shift.f = (0.0 + x + y + z)/(0.0 + max_x + max_y + max_z) * 360
				scale.f = 1 + Pow(Sin(Radian(time/10 + shift)),4) / 2
				xScaleEntity(clone(x, y, z), scale, scale, scale)
			Next
		Next
	Next
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Army'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Army sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #False)
xSetEngineSetting("LoadMesh::RelativePaths", "false")

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 0, 2, -5)

; set this to true to use software skinning
#forceSoftware = #False

; if shaders are supported (their version is greater than or equal to 1.1)
; then use them for hardware skinning, else use software skinning
If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
	xSetSkinningMethod(#SKIN_HARDWARE)
Else
	xSetSkinningMethod(#SKIN_SOFTWARE)
EndIf

; if we use hardware skinning
If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
	; load shader
	shader = xLoadFXFile("media\shaders\skinning.fx")
EndIf

; create units
Dim units(300)
unitCnt = 0
lastx = 0
lasty = 0
For x = 0 To 9
	For y = 0 To 0
		If y * 10 + x = 0
			; loading skinned mesh
			units(0) = xLoadAnimMesh("media/meshes/hazar.b3d")
			; extract animation sequences
			xExtractAnimSeq(units(0), 2, 4)
			animIndle = 1
			xExtractAnimSeq(units(0), 20, 59)
			animRun = 2
			xExtractAnimSeq(units(0), 99, 129)
			animAttack = 3
		ElseIf y * 10 + x = 1
			; loading skinned mesh
			units(1) = xLoadAnimMesh("media/meshes/kuznec.b3d")
			; extract animation sequences
			xExtractAnimSeq(units(1), 2, 4)
			animIndle = 1
			xExtractAnimSeq(units(1), 20, 59)
			animRun = 2
			xExtractAnimSeq(units(1), 99, 129)
			animAttack = 3
		Else
			units(y * 10 + x) = xCopyEntity(units(Random(1)))
		EndIf
		xRotateEntity(units(y * 10 + x), 0, 180, 0)
		xPositionEntity(units(y * 10 + x), x * 2 - 9, 0, y * 2)
		speed.f = 1.0
		seq = Random(2) + 1
		If seq = 1 : speed = 0.1 : EndIf
		xAnimate(units(y * 10 + x), 1, speed, seq)
		; if we use hardware skinning
		If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
			; assign it to mesh
			xSetEntityEffect(units(y * 10 + x), shader)
			; setup constant name for bones matrices
			xSetBonesArrayName(units(y * 10 + x), "bonesMatrixArray")
			; setup technique
			xSetEffectTechnique(units(y * 10 + x), "Skinned")
		EndIf
		unitCnt = unitCnt + 1
		lastx = x
		lasty = y
	Next
Next

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
		
	; add a new unit
	If xKeyHit(#KEY_SPACE)
		unitCnt = unitCnt + 1
		lastx = lastx + 1
		If lastx > 9 : lastx = 0 : lasty = lasty + 1 : EndIf
		units(lasty * 10 + lastx) = xCopyEntity(units(Random(1)))
		xRotateEntity(units(lasty * 10 + lastx), 0, 180, 0)
		xPositionEntity(units(lasty * 10 + lastx), lastx * 2 - 9, 0, lasty * 2)
		speed.f = 1.0
		seq   = Random(2) + 1
		If seq = 1 : speed = 0.1 : EndIf
		xAnimate(units(lasty * 10 + lastx), 1, speed.f, seq)
		; if we use hardware skinning
		If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
			; assign it to mesh
			xSetEntityEffect(units(lasty * 10 + lastx), shader)
			; setup constant name for bones matrices
			xSetBonesArrayName(units(lasty * 10 + lastx), "bonesMatrixArray")
			; setup technique
			xSetEffectTechnique(units(lasty * 10 + lastx), "Skinned")
		EndIf
	EndIf
	
	; update animations
	xUpdateWorld()
	
	; render scene
	xRenderWorld()
	
	; draw text
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 50, "Units: " + Str(unitCnt))
	xText(10, 70, "SPACE - Add new unit")
	
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
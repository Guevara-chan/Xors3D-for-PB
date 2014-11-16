; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Skinning'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Skinning sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; force abolute path for textures
xSetEngineSetting("LoadMesh::RelativePaths", "false")

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 0, 2, -5)

; set this to true for using software skinning
#forceSoftware = #False

; if shaders are supported (their version is greater than or equal to 1.1)
; then use them for hardware skinning, else use software skinning
If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
	xSetSkinningMethod(#SKIN_HARDWARE)
Else
	xSetSkinningMethod(#SKIN_SOFTWARE)
EndIf

; loading skinned mesh
hazar = xLoadAnimMesh("media/meshes/hazar.b3d")
xRotateEntity(hazar, 0, 180, 0)

; if we use hardware skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	; load shader
	shader = xLoadFXFile("media\shaders\skinning.fx")
	; assign it to mesh
	xSetEntityEffect(hazar, shader)
	; setup constant name for bones matrices
	xSetBonesArrayName(hazar, "bonesMatrixArray")
	; setup technique
	xSetEffectTechnique(hazar, "Skinned")
EndIf

; we may load animation sequensec only for skinned mesh
skinnedHazar = xFindChild(hazar, "Box01")

; extract animation sequences
xExtractAnimSeq(hazar, 2, 4)
animIndle = 1 ; in fact xExtractAnimSeq() return sequence number, but
							; in model 2 animated meshes(man and sword), and we must
							; extract sequences for each of them for real number,
							; but sequences number always increments for next sequence ;)
xExtractAnimSeq(hazar, 20, 59)
animRun = 2
xExtractAnimSeq(hazar, 99, 129)
animAttack = 3
xExtractAnimSeq(hazar, 70, 87)
animDeath = 4

; play idle animation
xAnimate(hazar, 2, 0.1,animIndle)
curAnimation = animIndle

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
	
	; animation switch
	If xKeyHit(#KEY_1) : xAnimate(hazar, 2, 0.1, animIndle) : curAnimation = animIndle : EndIf
	If xKeyHit(#KEY_2) : xAnimate(hazar, 1, 1.0, animRun) : curAnimation = animRun : EndIf
	If xKeyHit(#KEY_3) : xAnimate(hazar, 1, 1.0, animAttack) : curAnimation = animAttack : EndIf
	If xKeyHit(#KEY_4) : xAnimate(hazar, 3, 1.0, animDeath) : curAnimation = animDeath : EndIf
	
	; update animations
	xUpdateWorld()
	
	; render scene
	xRenderWorld()
	
	; draw hints
	xText(10, 10, "Key 1 - Idle animation")
	xText(10, 30, "Key 2 - Run animation")
	xText(10, 50, "Key 3 - Attack animation")
	xText(10, 70, "Key 4 - Death animation")
	Select curAnimation
	Case animIndle
		xText(10, 90, "Now played - Idle animation")
	Case animRun
		xText(10, 90, "Now played - Run animation")
	Case animAttack
		xText(10, 90, "Now played - Attack animation")
	Case animDeath
		xText(10, 90, "Now played - Death animation")
	EndSelect
	
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
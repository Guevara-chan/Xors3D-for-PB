; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Pointing'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Pointing sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 0, 2, -10)

; set this to true for using software skinning
#forceSoftware = #False

; if shaders are supported (their version is greater than or equal to 1.1)
; : use them for hardware skinning, else use software skinning
If xGetMaxVertexShaderVersion() > -1 And #forceSoftware = #False
	xSetSkinningMethod(#SKIN_HARDWARE)
Else
	xSetSkinningMethod(#SKIN_SOFTWARE)
EndIf

; loading skinned mesh
kuznec = xLoadAnimMesh("media/meshes/kuznec.b3d")
head = xFindChild(kuznec, "Bone10")
xRotateEntity(kuznec, 0, 180, 0)

; if we use hardware skinning
If xGetMaxVertexShaderVersion() > -1 And forceSoftware = False
	; load shader
	shader = xLoadFXFile("media\shaders\skinning.fx")
	; assign it to mesh
	xSetEntityEffect(kuznec, shader)
	; setup constant name for bones matrices
	xSetBonesArrayName(kuznec, "bonesMatrixArray")
	; setup technique
	xSetEffectTechnique(kuznec, "Skinned")
EndIf

; extract animation sequences
xExtractAnimSeq(kuznec, 99, 129)

; play idle animation
xAnimate(kuznec, 1, 1.0, 1)
xAnimate(kuznec, 0, 1.0, 0, 0, "Bone10") ;disable animation for head

; create target sphere
target = xCreateSphere()
xScaleEntity(target, 0.1, 0.1, 0.1)
xPositionEntity(target, 3, 2, -2)
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)

; main program loop
While Not xKeyDown(#KEY_ESCAPE)

	; target control
	xMoveEntity(target, xMouseXSpeed() * 0.05, -(xMouseYSpeed() * 0.05), 0.0)
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)

	; check borders
	If (xEntityX(target) >  5.0) : xPositionEntity(target,  5, xEntityY(target), 0) : EndIf
	If (xEntityX(target) < -5.0) : xPositionEntity(target, -5, xEntityY(target), 0) : EndIf
	If (xEntityY(target) >  6.0) : xPositionEntity(target, xEntityX(target),  6, 0) : EndIf
	If (xEntityY(target) < -2.0) : xPositionEntity(target, xEntityX(target), -2, 0) : EndIf
	
	; point head
	xPointEntity(head, target)
	xTurnEntity(head, 0, -90, 90) ; fixing axis
	
	; update animations
	xUpdateWorld()
	
	; render scene
	xRenderWorld()

	; draw texts
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Move mouse")

	; switch back buffer
	xFlip()
	
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
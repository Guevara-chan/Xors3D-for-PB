; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Bump'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Bump-mapping sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()

; position camera
xPositionEntity(camera, 0, 0, -25)

; set this variable to true to use FFP DOT3 bump-mapping (for old video-cards)
#forceFFP = #False

; create cube
cube = xCreateCube()
xScaleEntity(cube, 5, 5, 5)
xEntityShininess(cube, 1.0)
xUpdateNormals(cube)

; load logo texture from file
diffuse = xLoadTexture("media\textures\blue_marble.jpg")
normal = xLoadTexture("media\textures\blue_marble_norm.jpg")

If #forceFFP = #False
	; texture cube
	xEntityTexture(cube, diffuse, 0, 0) ; layer0 - diffuse
	xEntityTexture(cube, normal, 0, 1) ; layer1 - normal-map
Else
	; texture cube
	xEntityTexture(cube, diffuse, 0, 1) ; layer0 - diffuse
	xEntityTexture(cube, normal, 0, 0) ; layer1 - normal-map
	
	; set DOT3 blend for FFP bump
	xTextureBlend(normal, 4)
	xTextureBlend(diffuse, 2)
EndIf

; create light
pivot = xCreatePivot()
light1 = xCreateLight(2)
xEntityParent(light1, pivot)
xPositionEntity(light1, 0, 0, -10)
sphere = xCreateSphere(12, light1)
xScaleEntity(sphere, 0.1, 0.1, 0.1)

If #forceFFP = #False
	; load bump shader
	bump = xLoadFXFile("media\shaders\bump.fx")
	
	; assing it to cube
	xSetEntityEffect(cube, bump)
	
	;set technique
	xSetEffectTechnique(cube, "Bump")
EndIf

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
	
	; turn cube
	xTurnEntity(pivot, 0, 1, 0)
	
	If #forceFFP = #False
		; pass camera position into shader
		xSetEffectVector(cube, "cameraPosition", xEntityX(camera), xEntityY(camera), xEntityZ(camera))
	EndIf
	; render scene
	xRenderWorld()
	
	; draw back buffer
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
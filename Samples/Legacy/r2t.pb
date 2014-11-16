; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Render to texture'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

;initialization
xAppTitle("Render to texture")
xGraphics3D(800, 600, 32, #False, #True)
xCreateDSS(1024, 1024)

;enabling antialiasing
xAntiAlias(#True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPIC)

;creating the camera
cam = xCreateCamera()
xPositionEntity(cam, 15, 10, -100)

;font loading
arial = xLoadFont("Arial", 12)

;light source creating
light1 = xCreateLight(#LIGHT_DIRECTIONAL)
xRotateEntity(light1, -45, 0, 0)

;creating the cube
cube = xCreateCube()
xScaleEntity(cube, 10, 10, 10)

;creating the texture and putting it on the cube
test = xCreateTexture(512, 512)
xEntityTexture(cube, test)

;creating the sphere and hiding it
sph = xCreateCube()
xScaleEntity(sph, 10, 10, 10)
xEntityShininess(sph, 1)
xEntityColor(sph, 255, 0, 0)
xHideEntity(sph)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

;main loop
While Not(xKeyDown(1) Or xWinMessage("WM_CLOSE"))

	;set the texture as a render target
	xSetBuffer(xTextureBuffer(test))
	
	;hiding the cube and unhiding the sphere
	xShowEntity(sph)
	xHideEntity(cube)
	
	;buffer clearing
	xCameraClsColor(cam, 192, 192, 192)
	xCls()
	
	;rendering the world
	xRenderWorld()
	
	;hiding the sphere and unhinding the cube
	xHideEntity(sph)
	xShowEntity(cube)
	
	;setting the backbuffer as a render target
	xSetBuffer(xBackBuffer())
	xCameraClsColor(cam, 0, 0, 0)
	
	; camera control
	If xKeyDown(#KEY_W) : xMoveEntity(cam,  0,  0,  1): EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(cam,  0,  0, -1): EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(cam, -1,  0,  0): EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(cam,  1,  0,  0): EndIf
	mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	Fix = Int(mxs) % 360 + (mxs - Int(mxs))
	camxa.f = camxa - Fix
	camya.f = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(cam, camya, camxa, 0.0)

	; turn cube
	xTurnEntity(cube,0,1,0)
	
	;updating and rendering the world
	xUpdateWorld()
	xRenderWorld()
	
	;fps and triangle counets
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Polygons: " + Str(xTrisRendered()))

	;drawing
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
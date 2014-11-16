; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'StretchBB'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

;initialization
xAppTitle("Stretch Back buffer")
xGraphics3D(800, 600, 32, #False, #True)

; create light
lit = xCreateLight()
xRotateEntity(lit, -40,40,40)

; set texture filtering 
xSetTextureFiltering(#TF_ANISOTROPIC)

; create camera
cam = xCreateCamera()
xCameraClsColor(cam, 192, 192, 192)
xPositionEntity(cam, 0, 10, -80)


; loading textures
load_tex = xLoadTexture("media\textures\bricks.jpg")
;create texture to copying back buffer
BB_tex = xCreateTexture(800,600)

; create cubes
cube1 = xCreateCube()
xScaleEntity(cube1, 10, 10, 10)
xPositionEntity(cube1, 20, 0, 0)
xEntityTexture(cube1, BB_tex)
cube2 = xCreateCube()
xScaleEntity(cube2, 10, 10, 10)
xPositionEntity(cube2, -20, 0, 0)
xEntityTexture(cube2, load_tex)
cu3 = xCreateCube()
xScaleEntity(cu3, 10, 10, 10)
xPositionEntity(cu3, 0, 30, 0)
xEntityTexture(cu3, load_tex)

; loading font
arial = xLoadFont("Arial", 12)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

;main loop
While Not xKeyDown(1)

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
	
	;turn cube
	xTurnEntity(cube1, 0, -1, 0)

	; render scene
	xCameraClsColor(cam, 0, 0, 0)
	xRenderWorld()
	
	; copy BB to texture "BB_tex"
	xStretchBackBuffer(BB_tex, 0, 0, 800, 600, 0)
	xCameraClsColor(cam, 192, 192, 192)
	
	;render and update world
	xUpdateWorld()
	xRenderWorld()

	;draw text
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Polygons: " + Str(xTrisRendered()))

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
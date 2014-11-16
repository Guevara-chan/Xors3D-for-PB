; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Clip Plane'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

;initialization
xAppTitle("Clipplane")
xGraphics3D(800, 600, 32, #False, #True)

;enabling antialiasing
xAntiAlias(#True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPIC)


;creating the camera
cam = xCreateCamera()
xPositionEntity(cam, 0, 20, 30)
xRotateEntity(cam,0,180,0)
xCameraClsColor(cam, 92, 192, 255)
xCameraRange(cam, 0.1, 1000)

;font loading
arial = xLoadFont("Arial", 12)

;light source creating
light1 = xCreateLight(#LIGHT_DIRECTIONAL)
xRotateEntity(light1, -45, 0, 0)

;skyBox = LoadSkyBox("sky")

level = xLoadMesh("media/Meshes/level.b3d")

;setting the clipplane
xCameraClipPlane(cam, 0, #True, 0, 1, 0, 0)
pivot = xCreatePivot()

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

;main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	; turn clipplane
	xTurnEntity(pivot, 0, 0, 0.1)
	xTFormPoint(0, 1, 0, pivot, 0)
	xCameraClipPlane(cam, 0, #True, xTFormedX(), xTFormedY(), xTFormedZ(), 30)
	 
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
	 
	;updating and rendering the world
	xUpdateWorld()
	xRenderWorld()
	 
	;fps and triangle counters
	xColor(255, 0, 0)
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Polygons: " + Str(xTrisRendered()))
	 
	;drawing the scene
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
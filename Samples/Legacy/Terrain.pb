; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Terrain'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; initialization
xSetAntiAliasType(xGetMaxAntiAlias())
xAppTitle("Terrain")
xGraphics3D(1024, 768, 32, #True, 0)

; enabling antialiasing
xAntiAlias(#True)

; setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPICX16)

; creating the cameta
cam = xCreateCamera()
xPositionEntity(cam, 2048, 0, 2048)
xCameraClsColor(cam, 192, 192, 192)
xCameraRange(cam, 0.1, 1000)
xCameraFogMode(cam, 1)
xCameraFogColor(cam, 130, 130, 150)
xCameraFogRange(cam, 500, 1000)

; loading the font
arial = xLoadFont("Arial", 12)

; light source creating
light1 = xCreateLight(#LIGHT_DIRECTIONAL)
xRotateEntity(light1, 45, 0, 0)

; creating the terrain
terr = xLoadTerrain("media/textures/terrain.png")
xScaleEntity(terr, 1, 200, 1)
grass = xLoadTexture("media/textures/IceTerrain.jpg")
xEntityTexture(terr, grass, 0, 0)
xEntityFX(terr, 1)

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
	
	;setting the camera above the terrain
	x.f = xEntityX(cam)
	y.f = xEntityY(cam)
	z.f = xEntityZ(cam)
	terra_y.f = xTerrainY(terr, x.f, y.f, z.f) + 5
	xPositionEntity(cam, x.f, terra_y.f, z.f)
	
	;updating and rendering the world
	xUpdateWorld()
	xRenderWorld()
	
	;fps and triangle counter
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Polygons on terrain: " + Str(xTerrainSize(terr) * xTerrainSize(terr) * 2))
	xText(10, 50, "Polygons rendered: " + Str(xTrisRendered()))

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
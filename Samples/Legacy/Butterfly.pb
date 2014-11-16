; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Butterfly'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

;initialization
xAppTitle("Butterfly")
xGraphics3D(800, 600, 32, #False, #True)

;creating the camera
cam = xCreateCamera()
xPositionEntity(cam, 0, 70, -120)
xRotateEntity(cam, 15, 0, 0)
xCameraClsColor(cam, 192, 192, 192)

;enabling antialiasing
xAntiAlias(#True)

;objects loading
wings = xLoadMesh("media/Meshes/ButterflyWings.b3d")
xRotateEntity(wings, 0, 0, -90)
body = xLoadMesh("media/Meshes/ButterflyBody.b3d")
xRotateEntity(body, 0, 0, -90)

;light source creating
light = xCreateLight()
xRotateEntity(light, -45, 0, 0)

;loading effect from file
butterfly = xLoadFXFile("media/shaders/IridescentButterfly.fx")

;checking if this technique is supported by hardware
If xValidateEffectTechnique(butterfly, "IridescentButterfly") = #False
	MessageRequester("Runtime error:", "Technique is not supported!")
	End
EndIf

;loading textures
tex1 = xLoadTexture("media/textures/gradientMap.bmp")
tex2 = xLoadTexture("media/textures/baseOpacityMap.tga")
tex3 = xLoadTexture("media/textures/bumpGlossMap.tga")

;setting the effect and constants
xSetEntityEffect(wings, butterfly)
xSetEffectTechnique(wings, "IridescentButterfly")
xSetEffectMatrixSemantic(wings, "world_view_proj_matrix", #WORLDVIEWPROJ)
xSetEffectMatrixSemantic(wings, "inv_view_matrix", #VIEWINVERSE)
xSetEffectTexture(wings, "baseOpacityMap_Tex", tex2)
xSetEffectTexture(wings, "bumpGlossMap_Tex", tex3)
xSetEffectTexture(wings, "gradientMap_Tex", tex1)
xEntityAlpha(wings, 0.5)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

While Not(xKeyDown(1) Or xWinMessage("WM_CLOSE"))

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
	
	;setting the spectator's position
	xSetEffectVector(wings, "view_position", xEntityX(cam), xEntityY(cam), xEntityZ(cam))
	
	;rendering the world
	xRenderWorld()
	
	;fps output
	xColor(0, 0, 0)
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	
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
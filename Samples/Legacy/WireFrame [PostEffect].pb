; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Wireframe posteffect'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; create camera
cam=xCreateCamera() 
xPositionEntity(cam, 0, 10, -20)
xRotateEntity(cam, 10, 0, 0)

; load teapot mesh
teapot = xLoadMesh("media/meshes/teapot.b3d")
xPositionEntity(teapot, 0, 0, 5)
xScaleMesh(teapot, 0.3, 0.3, 0.3)

; create post effect polygon
poly = xCreatePostEffectPoly(cam, 1)

; create textures
tex = xCreateTexture(800, 600)
tex2 = xCreateTexture(800, 600) 

; load post effect shader
postEffect = xLoadFXFile("media/shaders/WireFrame_postEffect.fx")

xSetEntityEffect(poly, postEffect)
xSetEffectTechnique(poly, "Diffuse")
xSetEffectMatrixSemantic(poly, "MatWorldViewProj", #WORLDVIEWPROJ)
xSetEffectTexture(poly, "tDiffuse", tex)
xSetEffectTexture(poly, "tEmissive", tex2)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; main loop
While Not(xKeyHit(1) Or xWinMessage("WM_CLOSE"))

	;enable wireframe
	xWireFrame(#True)

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

	; turn teaport
	xTurnEntity(teapot, 0,1,0)
	
	; render scene
	xEntityColor(teapot, 0, 255, 0)
	xRenderWorld()
	; strech BB to texture
	xStretchBackBuffer(tex, 0, 0, 800, 600, 0)
	
	; isable wireframe
	xCls()
	xWireFrame(#False)
	; render world
	xEntityColor(teapot, 200, 0, 0)
	xRenderWorld()
	; strech BB to texture
	xStretchBackBuffer(tex2, 0, 0, 800, 600, 0)
	
	; render post effect
	xRenderPostEffect(poly)
	xColor(255,0,0)

	; draw text
	xText(40,30,"FPS: "+Str(xGetFPS()))
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
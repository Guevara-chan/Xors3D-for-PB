; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Glass'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; set graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; create pivot
piv = xCreatePivot()

; create camera
cam = xCreateCamera(piv)
xCameraRange(cam, 0.9, 3000)
xPositionEntity(cam, 0, 0, -120)
xRotateEntity(cam, 0, 0, 0)

; create scene
teapot = xLoadMesh("media/meshes/teapot.b3d")
xPositionEntity(teapot, 30, -15, 0)

sphere = xCreateSphere(30)
xPositionEntity(sphere, -30, 0, 0)
xScaleEntity(sphere, 20, 20, 20)

; load cube texture
cubeTex = xLoadTexture("media/textures/Snow.dds", 128)

; create posteffect poly
poly = xCreatePostEffectPoly(cam, 1)

; create textures
lowresTex = xCreateTexture(256, 256)
tempTex   = xCreateTexture(256, 256)
BBtex     = xCreateTexture(800, 600) 

; load glass shader
glassFX = xLoadFXFile("media/shaders/Glass.fx")

; create sky
sky = xCreateSphere()
xFlipMesh(sky)
xScaleEntity(sky, 500, 500, 500)
xSetEntityEffect(sky, glassFX)
xSetEffectTechnique(sky, "Sky")
xSetEffectMatrixSemantic(sky, "MatWorldViewProj", #WORLDVIEWPROJ)
xSetEffectMatrixSemantic(sky, "MatWorld", #WORLD)
xSetEffectTexture(sky, "tDiffuse", cubeTex)

; setup glass shader
xSetEntityEffect(teapot, glassFX)
xSetEffectTechnique(teapot, "Diffuse")
xSetEffectMatrixSemantic(teapot, "MatWorldViewProj", #WORLDVIEWPROJ)
xSetEffectMatrixSemantic(teapot, "MatWorld", #WORLD)
xSetEffectTexture(teapot, "tDiffuse", cubeTex)

xSetEntityEffect(sphere, glassFX)
xSetEffectTechnique(sphere, "Diffuse")
xSetEffectMatrixSemantic(sphere, "MatWorldViewProj", #WORLDVIEWPROJ)
xSetEffectMatrixSemantic(sphere, "MatWorld", #WORLD)
xSetEffectTexture(sphere, "tDiffuse", cubeTex)

; params
enable       = 1
r.f          = 0
g.f          = 0
b.f          = 0.2
FallOffPow.f = 3

; main loop
While Not(xKeyHit(1) Or xWinMessage("WM_CLOSE"))

	; camera controll
	If xKeyDown(#KEY_UP)    : xTurnEntity(Piv,  1.0,  0.0, 0.0, #True) : EndIf
	If xKeyDown(#KEY_DOWN)  : xTurnEntity(Piv, -1.0,  0.0, 0.0, #True) : EndIf
	If xKeyDown(#KEY_LEFT)  : xTurnEntity(Piv,  0.0,  1.0, 0.0, #True) : EndIf
	If xKeyDown(#KEY_RIGHT) : xTurnEntity(Piv,  0.0, -1.0, 0.0, #True) : EndIf

	; glass color controll
	cl.f = 0.01
	If xKeyDown(#KEY_Q) : r + cl : EndIf
	If xKeyDown(#KEY_A) : r - cl : EndIf
	If xKeyDown(#KEY_W) : g + cl : EndIf
	If xKeyDown(#KEY_S) : g - cl : EndIf
	If xKeyDown(#KEY_E) : b + cl : EndIf
	If xKeyDown(#KEY_D) : b - cl : EndIf
	If (r > 1.0) : r = 1.0 : EndIf
	If (r < 0.0) : r = 0.0 : EndIf
	If (g > 1.0) : g = 1.0 : EndIf
	If (g < 0.0) : g = 0.0 : EndIf
	If (b > 1.0) : b = 1.0 : EndIf
	If (b < 0.0) : b = 0.0 : EndIf
	
	; falloff controll
	cl.f = 0.03
	If xKeyDown(#KEY_R) : FallOffPow = FallOffPow + cl : EndIf
	If xKeyDown(#KEY_F) : FallOffPow = FallOffPow - cl : EndIf
	
	; update shader params
	xSetEffectVector(teapot,	"view_position", xEntityX(cam, True), xEntityY(cam, True), xEntityZ(cam, True))
	xSetEffectVector(teapot,	"FallOffCol", r, g, b, 1.0)
	xSetEffectFloat(teapot,	"FallOffPow", FallOffPow)
	
	; turn teapot
	xTurnEntity(teapot, 0, 1, 0)
	
	; render world
	xRenderWorld()
	
	; draw texts
	xText(10, 30, "FPS: " + Str(xGetFPS()))
	xText(10, 60, "r (Q\A)  " + Str(r) + " g (W\S)  " + Str(g) + " b (E\D)  " + Str(b))
	xText(10, 80, "FallOffPow (R\F)  " + Str(FallOffPow))
	xText(10, 100, "Control: arrows  ")
	
	; draw scene
	xFlip()
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
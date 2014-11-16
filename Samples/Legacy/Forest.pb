; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Forest'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)
Declare UpdateParticles()
Declare CreateParticle(x.f, y.f, z.f, texture)
Declare CreateSkyBox(skyPath.s)

; for particles
Structure TParticle
*entity
speed.f
alpha.f
EndStructure

Global NewList Particles.TParticle()

; setup maximum supported AntiAlias Type
xSetAntiAliasType(0) ;xGetMaxAntiAlias()

; set application window caption
xAppTitle("Forest sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #False)
xCreateDSS(1024, 1024)

; set texture filtring
xSetTextureFiltering(#TF_ANISOTROPICX16)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; force abolute path for textures
xSetEngineSetting("LoadMesh::RelativePaths", "false")

; create camera
camera = xCreateCamera()
xCameraRange(camera, 0.1, 1000)
xCameraEnableShadows(camera)
cameraDist = 50

;create a terrain
terrain = xLoadTerrain("media/textures/height_map.bmp")
xTerrainShading(terrain, #True)
xScaleEntity(terrain, 10, 70, 10)
; load grass texture
grass = xLoadTexture("media/textures/gras_diffuse_1a.jpg")
xScaleTexture(grass, 0.01, 0.01)
xEntityTexture(terrain, grass, 0, 0)

; create forest
bereza = xLoadMesh("media/meshes/bereza2.b3d")
shader = xLoadFXFile("media/shaders/shaderinstancing.fx")
xSetEntityEffect(bereza, shader)
xSetEffectTechnique(bereza, "Instancing")
amount = 300
For i = 0 To amount
	copy = xCreateInstance(bereza)
	x.f =  Random(2000)
	z.f =  Random(2000)
	yf = xTerrainY(terrain, x.f, y.f, z.f) - 1
	xPositionEntity(copy, x, y, z)
	xRotateEntity(copy, (Random(6) - 3) / 10.0, Random(90), (Random(6) - 3) / 10.0)
	xScaleEntity(copy, 20, 20, 20)
Next

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; create light
light = xCreateLight()
xRotateEntity(light, 45, 0, 0)

; create skybox
skybox = xLoadMesh("media/meshes/skydome.b3d")
xEntityFX(skybox, 1)
xScaleEntity(skybox, 0.5, 0.5, 0.5)
xEntityColor(skybox, 255, 255, 255)
xEntityOrder(skybox, 1)

; warrior
warrior = xLoadAnimMesh("media/meshes/kuznec.b3d")
xEntityColor(warrior, 255, 255, 255)
x =  1000
z =  1000
y = xTerrainY(terrain, x, y, z)
xPositionEntity(warrior, x, y, z)
xScaleEntity(warrior, 5, 5, 5)
xExtractAnimSeq(warrior, 14, 18)
animIdle = 1
xExtractAnimSeq(warrior, 20, 59)
animRun = 2
currAnim = animIdle
lastAnim = 0
xAnimate(warrior, 2, 0.1, currAnim)

; shadows
xInitShadows(1024, 0, 0)

; set shadows params
enableShadows = 1
xEntityCastShadows(terrain, light, #False)
xLightEnableShadows(light, 1)
xSetShadowParams(2, 0.6, #True, 300)
xLightShadowEpsilons(light, 0.0001, 0.20)

; fire
koster = xLoadAnimMesh("Media/Meshes/koster.b3d")
xEntityColor(koster, 255, 255, 255)
xScaleEntity(koster, 0.07, 0.07, 0.07)
x = 1010
z = 1000
y = xTerrainY(terrain, x, y, z)
xPositionEntity(koster, x, y, z)
flameEmiter = koster ;xFindChild(koster, "flame")
flame = xLoadTexture("Media/Textures/fire.jpg", 1 + 2)
xTextureBlend(flame, 5)

; main program loop
While Not xKeyDown(#KEY_ESCAPE)

	; warrior control
	lastAnim = currAnim
	currAnim = animIdle
	lastMoveZ = movez
	movez = 0
	If xKeyDown(#KEY_W)
		xMoveEntity(warrior,  0,  0,  1)
		currAnim = animRun
		movez =  1
	EndIf
	If xKeyDown(#KEY_S)
		If lastMoveZ = 0 Or lastMoveZ = 1
			move = -1
		ElseIf lastMoveZ = -1
			move = 1
		EndIf
		xMoveEntity(warrior,  0,  0,  1)
		currAnim = animRun
		movez = -1
	EndIf
	
	; camera look
	If xMouseDown(2)
		cameraDist = cameraDist + (xMouseYSpeed() * mousespeed)
		If cameraDist < 10 : cameraDist = 10 : EndIf
		If cameraDist > 100 : cameraDist = 100 : EndIf
		xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	Else
		mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
		mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
		Fix = Int(mxs) % 360 + (mxs - Int(mxs))
	  camxa.f = camxa - Fix
	  camya.f = camya + mys
		If camya < 0 : camya = 0 : EndIf
		If camya > 45 : camya = 45 : EndIf
		cameraDist = cameraDist + (xMouseZSpeed() * 3)
		xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
		xRotateEntity(camera, camya, camxa, 0.0)
		If cameraDist < 10 : cameraDist = 10 : EndIf
		If cameraDist > 100 : cameraDist = 100 : EndIf
	EndIf
	
	;setting the warrior above the terrain
	x = xEntityX(warrior)
	y = xEntityY(warrior)
	z = xEntityZ(warrior)
	terra_y.f = xTerrainY(terrain, x, y, z)
	xPositionEntity(warrior, x, terra_y, z)
	xPositionEntity(camera, xEntityX(warrior), xEntityY(warrior) + 10, xEntityZ(warrior))
	If movez <> 0 Or movex <> 0
		If movez = -1
			xRotateEntity(warrior, 0, xEntityYaw(camera) + 180, 0)
		Else
			xRotateEntity(warrior, 0, xEntityYaw(camera), 0)
		EndIf
	EndIf
	xMoveEntity(camera, 0, 0, -cameraDist)
	
	; position skybox
	xPositionEntity(skybox, xEntityX(camera), xEntityY(camera), xEntityZ(camera))
	
	; switch animation
	If currAnim <> LastAnim
		If currAnim = animRun
			xAnimate(warrior, 1, 1.7, currAnim, 10)
		ElseIf currAnim = animIdle
			xAnimate(warrior, 2, 0.1, currAnim, 1)
		EndIf
	EndIf
	
	; update flame
	If ElapsedMilliseconds() > lastCreated
		px.f = xEntityX(flameEmiter, #True) + (Random(2) - 1) / 10.0
		py.f = xEntityY(flameEmiter, #True)
		pz.f = xEntityZ(flameEmiter, #True) + (Random(2) - 1) / 10.0
		CreateParticle(px, py, pz, flame)
		lastCreated = ElapsedMilliseconds() + 25
	EndIf
	UpdateParticles()
	
	; switch shadows on/off
	If xKeyHit(#KEY_Q) : enableShadows = 1 - enableShadows : EndIf
	
	; update animations
	xUpdateWorld()
	
	; render scene
	xRenderWorld(1.0, enableShadows)
	
	; draw text
	xColor(200,0,0)
	xText(10, 10, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 30, "FPS: " + Str(xGetFPS()))
	xText(10, 50, "DIP calls: " + Str(xDIPCounter()))
	shadowsState.s = "enabled"
	If enableShadows = 0 : shadowsState = "disabled" : EndIf
	xText(10, 70, "Q - enable\disable shadows (" + shadowsState + " now)")
	
	; switch back buffer
	xFlip()
	
Wend

; for particles
Procedure UpdateParticles()
	Define *Particle.TParticle
	ForEach Particles() : *Particle = Particles()
		If *Particle\entity
			xTranslateEntity(*particle\entity, 0.0, *particle\speed, 0.0)
			*particle\alpha = *particle\alpha - 0.05
			xEntityAlpha(*particle\entity, *particle\alpha)
			If *particle\alpha < 0.001
				xFreeEntity(*particle\entity)
				DeleteElement(Particles())
			EndIf
		EndIf
	Next
EndProcedure

Procedure CreateParticle(x.f, y.f, z.f, texture)
	Define *NewParticle.TParticle
	AddElement(Particles())
	*NewParticle = Particles()
  *newParticle\entity = xCreateSprite()
	xEntityTexture(*newParticle\entity, texture)
	xEntityFX(*newParticle\entity, 1)
	xEntityBlend(*newParticle\entity, 3)
	xPositionEntity(*newParticle\entity, x, y, z)
	xScaleSprite(*newParticle\entity, Random(5) + 2, Random(5) + 2)
	*newParticle\speed = (Random(3) + 2) / 10.0
	*newParticle\alpha = 1.0
EndProcedure

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure

; Function for sky box creating
Procedure CreateSkyBox(skyPath.s)
	skybox = xCreateMesh()
	; Left
	texture = xLoadTexture(skyPath + "sky_left.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0,  1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0,  1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; Front
	texture = xLoadTexture(skyPath + "sky_front.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0,  1.0, 1.0, 0.0, 0.0)
	v1 = xAddVertex(surface,  1.0,  1.0, 1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, 1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, -1.0, 1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; Right
	texture = xLoadTexture(skyPath + "sky_right.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, 1.0,  1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, 1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, 1.0, -1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, 1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; Back
	texture = xLoadTexture(skyPath + "sky_back.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface,  1.0,  1.0, -1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0,  1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface, -1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; Bottom
	texture = xLoadTexture(skyPath + "sky_down.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0, -1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface,  1.0, -1.0,  1.0, 1.0, 0.0)
	v2 = xAddVertex(surface, -1.0, -1.0, -1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, -1.0, -1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; Top
	texture = xLoadTexture(skyPath + "sky_up.jpg", 49)
	brush = xCreateBrush()
	xBrushTexture(brush, texture)
	surface = xCreateSurface(skybox, brush)
	v0 = xAddVertex(surface, -1.0, 1.0,  1.0, 0.0, 0.0)
	v1 = xAddVertex(surface, -1.0, 1.0, -1.0, 1.0, 0.0)
	v2 = xAddVertex(surface,  1.0, 1.0,  1.0, 0.0, 1.0)
	v3 = xAddVertex(surface,  1.0, 1.0, -1.0, 1.0, 1.0)
	xAddTriangle(surface, v2, v1, v0)
	xAddTriangle(surface, v1, v2, v3)
	; set FX flags
	xEntityFX(skybox, 1)
	xFlipMesh(skybox)
	xUpdateNormals(skybox)
	; return skybox handle
	ProcedureReturn skybox
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
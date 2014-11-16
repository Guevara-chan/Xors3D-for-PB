; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Shadows'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)
Declare UpdateParticles()
Declare CreateParticle(x.f, y.f, z.f, texture)

; for particles
Structure TParticle
*entity
speed.f
alpha.f
EndStructure

Global NewList Particles.TParticle()

; disable AntiAlias
xSetAntiAliasType(0)

; set application window caption
xAppTitle("Shadows sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, 1)
xCreateDSS(1024, 1024)

; set texture filtring
xSetTextureFiltering(#TF_ANISOTROPICX16)

; hide mouse pointer
xHidePointer()

; create camera
camera = xCreateCamera()
xCameraRange(camera, 0.1, 1000)
xPositionEntity(camera, -50, 10, -50)
xCameraEnableShadows(camera)
camxa.f = -45
camya.f = 5

; create a terrain
terrain = xCreateCube()
xScaleEntity(terrain, 200, 0.1, 200)
; load grass texture
grass = xLoadTexture("media/textures/gras_diffuse_1a.jpg")
xScaleTexture(grass, 0.1, 0.1)
xEntityTexture(terrain, grass, 0, 0)

; create forest
bereza = xLoadMesh("media/meshes/bereza.b3d")
xScaleEntity(bereza, 7, 7, 7)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; create light
light = xCreateLight()
xRotateEntity(light, 45, 0, 0)
xLightColor(light, 25, 25, 25)

; create skybox
skybox = xLoadMesh("media/meshes/skydome.b3d")
xEntityFX(skybox, 1)
xScaleEntity(skybox, 0.5, 0.5, 0.5)
xEntityColor(skybox, 15, 15, 15)
xEntityOrder(skybox, 1)

; warrior
warrior = xLoadAnimMesh("media/meshes/kuznec.b3d")
xEntityColor(warrior, 255, 255, 255)
xPositionEntity(warrior, 10, 0, -5)
xScaleEntity(warrior, 5, 5, 5)
xExtractAnimSeq(warrior, 20, 59)
xAnimate(warrior, 1, 1.2, 1)

; assing point light to fire
light2 = xCreateLight(2)
xLightRange(light2, 30)
xLightColor(light2, 255, 0, 0)
fire = xLoadMesh("media/meshes/koster.b3d")
xPositionEntity(fire, -10, 0, -10)
xPositionEntity(light2, -10, 10, -10)
xScaleEntity(fire, 0.07, 0.07, 0.07)
flame = xLoadTexture("media/Textures/fire.jpg", 1 + 2)
xTextureBlend(flame, 5)

; shadows
xInitShadows(1024, 0, 512)

; set shadows params
xLightEnableShadows(light, 1)
xSetShadowParams(4, 0.85, #True, 300)
xLightShadowEpsilons(light, 0.0001, 0.16)
xLightEnableShadows(light2, 1)
xLightShadowEpsilons(light2, 0.01, 0.0)

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
	
	; update flame
	If ElapsedMilliseconds() > lastCreated
		px.f = xEntityX(fire, #True) + (Random(2) - 1) / 10.0
		py.f = xEntityY(fire, #True)
		pz.f = xEntityZ(fire, #True) + (Random(2) - 1) / 10.0
		CreateParticle(px, py, pz, flame)
		lastCreated = ElapsedMilliseconds() + 25
	EndIf
	UpdateParticles()
	
	; move warrior
	xMoveEntity(warrior, 0, 0, 0.3)
	xTurnEntity(warrior, 0, 1, 0)
	
	; position skybox
	xPositionEntity(skybox, xEntityX(camera), xEntityY(camera) - 1, xEntityZ(camera))
	
	; update animations
	xUpdateWorld()
		
	; render scene
  xRenderWorld(1.0, #True)
	
	; draw text
	xText(10, 10, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 30, "FPS: " + Str(xGetFPS()))
	xText(10, 50, "DIP calls: " + Str(xDIPCounter()))
	
	; switch back buffer
	xFlip()
	
Wend

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure

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
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
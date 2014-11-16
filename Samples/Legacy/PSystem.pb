; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Particle system'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; initialization
xAppTitle("Particle System")
xGraphics3D(800, 600, 32, #False, #True)

; texture loading
texture = xLoadTexture("media/textures/particle.bmp", 1 + 2 + 8)

; creating the pasrticle system
psystem = xCreatePSystem(#True)
xPSystemSetTexture(psystem, texture, 1, 0)
xPSystemSetParticleLifetime(psystem, 10000)
xPSystemSetMaxParticles(psystem, 3000)
xPSystemSetCreationInterval(psystem, 30)
xPSystemSetCreationFrequency(psystem, 5)
xPSystemSetVelocity(psystem, -3, -3, -3, 3, 3, 3)
xPSystemSetParticleSize(psystem, 1, 1, 5, 5)
xPSystemSetScaleSpeed(psystem, -0.1, -0.1, 1, 1)
xPSystemSetColors(psystem, 0, 255, 0, 255, 0, 0)
xPSystemSetColorMode(psystem, 1)

; create emitter
emitter = xCreateEmitter(psystem)

; creating the camera
camera = xCreateCamera()
xMoveEntity(camera, 0, 0, -50)

; main loop
While Not (xKeyDown(1) Or xWinMessage("WM_CLOSE"))

	; turn emitter
	xTurnEntity(emitter, 1, 1, 1)

	; updating and rendering the scene
	xUpdateWorld()
	xRenderWorld()
	
	; fps and particles counter
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Particles: " + Str(xEmitterCountParticles(emitter)))
	
	; drawing the scene
	xFlip()

Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Animetex'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

;initialization
xAppTitle("Animation texture")
xGraphics3D(800, 600, 32, #False, #True)

;enabling antialiasing
xAntiAlias(#True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPIC)

;camera creating
camera = xCreateCamera()
xPositionEntity(camera, 0, 10, -170)

;light source creating
light = xCreateLight()
xRotateEntity(light, -45, 0, 0)

;creating of the cube
cube = xCreateCube()
xScaleEntity(cube, 20, 20, 20)

;animated texture loading
anim_tex = xLoadAnimTexture("media/textures/boomstrip.bmp", 1, 64, 64, 0, 39)

;setting the colour of camera clearing
xCameraClsColor(camera, 192, 192, 192)

;font loading
arial = xLoadFont("Arial", 12)

;main loop
While Not(xKeyDown(1) Or xWinMessage("WM_CLOSE"))

	;counting for changing texture frame
	frame = (ElapsedMilliseconds() / 50) % 39
	
	;putting texture on the cube
	xEntityTexture(cube, anim_tex, frame)
	
	;cube rotation
	pitch.f = 0
	yaw.f   = 0
	roll.f  = 0
	If xKeyDown(208) : pitch.f = -1 : EndIf
	If xKeyDown(200) : pitch.f =  1 : EndIf
	If xKeyDown(203) : yaw.f   = -1 : EndIf
	If xKeyDown(205) : yaw.f   =  1 : EndIf
	If xKeyDown(45)  : roll.f  = -1 : EndIf
	If xKeyDown(44)  : roll.f  =  1 : EndIf
	xTurnEntity(cube, pitch.f, yaw.f, roll.f)
	
	;rendering of the world
	xRenderWorld()
	
	;fps counter and debug info
	xColor(0, 0, 0)
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "Up\Down\Left\Right\Z\X - rotate cube")
	
	;drawing the scene
	xFlip()

Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Deltatime'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; initialization
xAppTitle("Deltatime")
xGraphics3D(800, 600, 32, #False, #False)

; create camera
camera = xCreateCamera()
xPositionEntity(camera, 0, 0, -20)

; create scene
cube = xCreateCube()
xPositionEntity(cube, -10, 0, 0)
cone = xCreateCone()
xRotateEntity(cone, 180, 0, 0)
xPositionEntity(cone, 10, 2, 0)
xEntityColor(cone, 255, 0, 0)

; cetch first frame time
lastFrame = xMillisecs()

; main loop
While Not xKeyDown(1) Or xWinMessage("WM_CLOSE")

	; move cube with deltatimed value (cube move at 5 point per second)
	xMoveEntity(cube, xDeltaValue(5.0, lastFrame), 0, 0)
	
	; catch frame time
	lastFrame = xMillisecs()
	
	; render world
	xUpdateWorld()
	xRenderWorld()
	
	; draw info
	xText(10, 10, "FPS: " + Str(xGetFPS())) 
	xText(10, 30, "Cube will arive within 4 seconds. Always.")
	xText(10, 50, "Time from last frame: " + Str(xDeltaTime(#False)) + " msec")
	xText(10, 70, "Time from application start: " + Str(xDeltaTime(#True)) + " msec")
	
	; swap buffers
	xFlip()

Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
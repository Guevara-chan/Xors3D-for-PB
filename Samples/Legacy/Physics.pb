; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Physics'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

; /!\ Warning: current directory was set to ..\..\DLL\ in Compiler Options.

#impulse = 50

; Include header file
IncludeFile "..\..\xors3d.pbi"
Declare.f CurveValue(newvalue.f, oldvalue.f, increments)
Declare ShootSphere(*camera)
Declare ResetWall()


xCreateLog()

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application window caption
xAppTitle("Physics sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #False)

; hide mouse pointer
xHidePointer()

; enable antialiasing
xAntiAlias(#True)

; create camera
*camera = xCreateCamera()

; position camera
;xPositionEntity camera, 0, 60, -200
xPositionEntity(*camera, 0, 20, -100)

; create ground
ground = xCreateCube()
xPointEntity(*camera, ground)
xScaleEntity(ground, 100, 1, 100)
xEntityAddBoxShape(ground, 0.0)

; loading logo from file
logoTexture = xLoadTexture("\..\media\textures\logo.jpg")

; texture cube
xEntityTexture(ground, logoTexture)

; create wall
#wallSize = 4
Global Dim wallBlocks(#wallSize, #wallSize, #wallSize)
For x = 0 To #wallSize
	For y = 0 To #wallSize
		For z = 0 To #wallSize
		  If x = 0 And y = 0 And z = 0
				wallBlocks(x, y, z) = xCreateCube()
			Else
				wallBlocks(x, y, z) = xCopyEntity(wallBlocks(0, 0, 0))
			EndIf
			xPositionEntity(wallBlocks(x, y, z), (x - #wallSize / 2) * 2.0, 2 + y * 2.0, (z - #wallSize / 2) * 2.0)
			xEntityAddBoxShape(wallBlocks(x, y, z), 1.0)
			xEntityTexture(wallBlocks(x, y, z), logoTexture)
		Next
	Next
Next

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

; create light
light = xCreateLight()
xRotateEntity(light, 45, 0, 0)

; main program loop
While Not xKeyDown(#KEY_ESCAPE)

	; camera control
	If xKeyDown(#KEY_W) : xMoveEntity(*camera,  0,  0,  1): EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(*camera,  0,  0, -1): EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(*camera, -1,  0,  0): EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(*camera,  1,  0,  0): EndIf
	mxs.f = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.f = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	Fix = Int(mxs) % 360 + (mxs - Int(mxs))
	camxa.f = camxa - Fix
	camya.f = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(*camera, camya, camxa, 0.0)
	
	; shoot sphere
	If xMouseHit(1) : ShootSphere(*camera) : EndIf
	If xMouseHit(2) : xEntityApplyTorqueImpulse(wallBlocks(Random(#wallSize), Random(#wallSize), Random(#wallSize)), 0.0, Random(100), 0.0) 
  EndIf
	
	; reset wall
	If xKeyHit(#KEY_SPACE) : ResetWall() : EndIf
	
	; render scene
	xUpdateWorld()
	xRenderWorld()
	
	; FPS & rendered triangles counters
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 50, "Left mouse button to shoot, right mouse button to add torque for random cube, space to reset wall")
	
	; switch back buffer
	xFlip()
	
Wend

; function to reset cubes positions
Procedure ResetWall()
	For x = 0 To #wallSize
		For y = 0 To #wallSize
			For z = 0 To #wallSize
				xPositionEntity(wallBlocks(x, y, z), (x - #wallSize / 2) * 2.0, 2 + y * 2.0, (z - #wallSize / 2) * 2.0)
				xRotateEntity(wallBlocks(x, y, z), 0.0, 0.0, 0.0)
				xEntityReleaseForces(wallBlocks(x, y, z))
			Next
		Next
	Next
EndProcedure

; Procedure to shoot sphere
Procedure ShootSphere(*camera)
	sphere = xCreateSphere()
	xPositionEntity(sphere, xEntityX(*camera, #True), xEntityY(*camera, #True), xEntityZ(*camera, #True))
	xEntityColor(sphere, 255, 0, 0)
	xEntityAddSphereShape(sphere, 1.0, 1.0)
	xTFormNormal(0.0, 0.0, 1.0, *camera, 0)
	xEntityApplyCentralImpulse(sphere, xTFormedX() * #impulse, xTFormedY() * #impulse, xTFormedZ() * #impulse)
EndProcedure

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 6
; Folding = -
; EnableXP
; CurrentDirectory = ..\..\DLL\
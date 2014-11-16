; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Editor'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f ComputeMove(camera, x.f, y.f, z.f)

; setup maximum supported AntiAlias Type
xSetAntiAliasType(xGetMaxAntiAlias())

; set application's title
xAppTitle("Editor sample")

; initialize graphics mode
xGraphics3D(800, 600, 32, #False, #True)

; enable antialiasing
xAntiAlias(#True)

; create camera
camera = xCreateCamera()
xCameraClsColor(camera, 192, 192, 192)
xPositionEntity(camera, 10, 10, 10)

; create light
light = xCreateLight()

; create cube
cube = xCreateCube()
xPointEntity(camera, cube)

; loading logo from file
logoTexture = xLoadTexture("media\textures\logo.jpg")

; texture cube
xEntityTexture(cube, logoTexture)

; gizmos' data
controlType   = 0 ;/ 0 - move, 1 - rotate, 2 - scale 
selectMask    = 0
deltaX.f       = 1.0
deltaY.f       = 1.0
deltaZ.f       = 1.0
scaleXInit.f   = 1.0
scaleYInit.f   = 1.0
scaleZInit.f   = 1.0
Global controllPosX.f = 0.0
Global controllPosY.f = 0.0
Global controllPosZ.f = 0.0
Global mouseSpeedX   = 0
Global mouseSpeedY   = 0
Global used_controller.s = ""

; main program loop
While Not xKeyDown(#KEY_ESCAPE)
	xColor(100, 0, 0)
	mouseSpeedX = xMouseXSpeed()
	mouseSpeedY = xMouseYSpeed()
	
	; camera control
	If xKeyDown(#KEY_W) : xMoveEntity(camera,  0,  0,  1) : EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(camera,  0,  0, -1) : EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(camera, -1,  0,  0) : EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(camera,  1,  0,  0) : EndIf
	If xKeyHit(#KEY_1)  : controlType = 0 : EndIf
	If xKeyHit(#KEY_2)  : controlType = 1 : EndIf
	If xKeyHit(#KEY_3)  : controlType = 2 : EndIf

	; render scene
	xRenderWorld()
	
	; draw grid
	xDrawGrid(0, 0, 5, 100)
	
	; draw gizmos
	x.f = xEntityX(cube)
	y.f = xEntityY(cube)
	z.f = xEntityZ(cube)
	Select controlType
	Case 0
		mask = xCheckMovementGizmo(x.f, y.f, z.f, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1)
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
		EndIf
		xDrawMovementGizmo(x.f, y.f, z.f, selectMask)
		used_controller.s = "Used move controler"
	Case 1
		mask = xCheckRotationGizmo(x.f, y.f, z.f, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1) 
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
			deltaX.f      = 0.0
			deltaY.f      = 0.0
			deltaZ.f      = 0.0
		EndIf
		xDrawRotationGizmo(x.f, y.f, z.f, selectMask, deltaX, deltaY, deltaZ)
		used_controller.s = "Used rotate controler"
	Case 2
		mask = xCheckScaleGizmo(x.f, y.f, z.f, camera, xMouseX(), xMouseY())
		If Not xMouseDown(1) 
			selectMask   = mask
			controllPosX = x
			controllPosY = y
			controllPosZ = z
			deltaX       = 1.0
			deltaY       = 1.0
			deltaZ       = 1.0
			scaleXInit   = xEntityScaleX(cube)
			scaleYInit   = xEntityScaleY(cube)
			scaleZInit   = xEntityScaleZ(cube)
		EndIf
		xDrawScaleGizmo(x.f, y.f, z.f, selectMask, deltaX, deltaY, deltaZ)
		used_controller.s = "Used scale controler"
	Default
		used_controller = ""
	EndSelect
	
	; object control
	If xMouseDown(1) And selectMask <> 0
		useX     = (selectMask >> 0) & 1
		useY     = (selectMask >> 1) & 1
		useZ     = (selectMask >> 2) & 1
		useG     = (selectMask >> 3) & 1
		factorX.f = 0.7 / xGraphicsWidth()
		factorY.f = 0.7 / xGraphicsHeight()
		Select controlType
		; if movement gizmo is used
		Case 0
			; move controlled entity
			dx.f   = controllPosX - xEntityX(camera, #True)
			dy.f   = controllPosY - xEntityY(camera, #True)
			dz.f   = controllPosZ - xEntityZ(camera, #True)
			dist.f = Sqr(dx * dx + dy * dy + dz * dz)
			; x-axis
			If useX
				move.f = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				xTranslateEntity(cube, move, 0.0, 0.0, #False)
			EndIf
			; y-axis
			If useY
				move.f = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				xTranslateEntity(cube, 0.0, move, 0.0, #False)
			EndIf
			; z-axis
			If useZ
				move.f = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				xTranslateEntity(cube, 0.0, 0.0, move, #False)
			EndIf
		; if scaling gizmo is used
		Case 2
			; scale controlled entity
			dx.f   = controllPosX - xEntityX(camera, true)
			dy.f   = controllPosY - xEntityY(camera, true)
			dz.f   = controllPosZ - xEntityZ(camera, true)
			dist.f = Sqr(dx * dx + dy * dy + dz * dz)
			; x-axis
			If useX
				move.f      = ComputeMove(camera, 10.0, 0.0, 0.0) * factorX * dist
				deltaX     = deltaX     + move
				scaleXInit = scaleXInit + move
				xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit)
			EndIf
			; y-axis
			If useY
				move.f      = ComputeMove(camera, 0.0, 10.0, 0.0) * factorY * dist
				deltaY     = deltaY     + move
				scaleYInit = scaleYInit + move
				xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit)
			EndIf
			; z-axis
			If useZ
				move.f      = ComputeMove(camera, 0.0, 0.0, 10.0) * factorX * dist
				deltaZ     = deltaZ     + move
				scaleZInit = scaleZInit + move
				xScaleEntity(cube, scaleXInit, scaleYInit, scaleZInit)
			EndIf
		; if rotation gizmo is used
		Case 1
			; rotate controlled entity
			; x-axis
			If useX
				move.f  = ComputeMove(camera, 0.0, -10.0, 0.0)
				deltaX = deltaX + move
				xTurnEntity(cube, move, 0.0, 0.0, #True)
			EndIf
			; y-axis
			If useY
				move.f  = ComputeMove(camera, -10.0, -10.0, 0.0);
				deltaY = deltaY + move
				xTurnEntity(cube, 0.0, move, 0.0, #True)
			EndIf
			; z-axis
			If useZ
				move.f  = ComputeMove(camera, -10.0, 0.0, 0.0);
				deltaZ = deltaZ + move
				xTurnEntity(cube, 0.0, 0.0, move, #True)
			EndIf
		EndSelect
	EndIf
	
	; draw info
	xText(10, 10, "Use WSAD to move camera around scene")
	xText(10, 30, "Use 1, 2, 3 to change object controler")
	xText(10, 50, used_controller)
	
	; switch back buffer
	xFlip()
	
Wend

Procedure.f ComputeMove(camera, x.f, y.f, z.f)
	If mouseSpeedX = 0 And mouseSpeedY = 0 : ProcedureReturn 0.0 : EndIf
	; project axis on the screen
	xCameraProject(camera, controllPosX, controllPosY, controllPosZ)
	x1 = xProjectedX()
	y1 = xProjectedY()
	xCameraProject(camera, controllPosX + x, controllPosY + y, controllPosZ + z)
	x2 = xProjectedX()
	y2 = xProjectedY()
	; compute angle between our vectors
	dx1.f    = x2 - x1
	dy1.f    = y2 - y1
	dx2.f    = mouseSpeedX
	dy2.f    = mouseSpeedY
	len1.f  = Sqr(dx1 * dx1 + dy1 * dy1)
	len2.f  = Sqr(dx2 * dx2 + dy2 * dy2)
  angle.f = ACos((dx1 * dx2 + dy1 * dy2) / (len1 * len2))
	; compute distance
	radii.f = Sqr(dx2 * dx2 + dy2 * dy2)
	; compute a new vector's x-component
	ProcedureReturn radii * Cos(angle)
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
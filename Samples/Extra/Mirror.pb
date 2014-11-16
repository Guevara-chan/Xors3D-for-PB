; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D extra sample: 'Mirror'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CreateCheckerTexture(size.I = 256)
Declare MouseLookAndFly(speed.F = 1.0)
Declare Garbage(num.I = 40)
Declare CraftMirror()
Declare UpdateMirror(mirrorEnt.I, mirrorCamera.I, viewCamera.I)
Declare.f CurveValue(newvalue.F, oldvalue.F, increments)

xCreateLog(#LOG_HTML, #LOG_INFO, "Mirror.html")
xAppTitle("Mirror")

; mirror camera
Global mCamera.I

; mirror texture
Global tTextureReflection

xGraphics3D(1024, 768, 32, #False, #True)

; mirror texture dimensions
Global reflSizeX = xGraphicsWidth() ;1024
Global reflSizeY = xGraphicsHeight() ;1024

xCreateDSS(reflSizeX, reflSizeY)

; mouse stuff
Global mousespeed.F = 0.5, camerasmoothness.F = 4.5
Global camxa.F = 0, camya.F = 0, mxs.F = 0, mys.F = 0
Global center_x = xGraphicsWidth() / 2
Global center_y = xGraphicsHeight() / 2
xMoveMouse(center_x, center_y)
xHidePointer()

; some color cubes
Garbage()

Global mirror = CraftMirror()
xRotateEntity(mirror, 0.0, 135.0, 45.0)
xPositionEntity(mirror, 80.0, 0.0, 80.0)

light         = xCreateLight(2)
xPositionEntity(light,16,8,0)
xRotateEntity(light, 0,0,0)
pivLight      = xCreatePivot()
xEntityParent(light, pivLight)
lightSource   = xCreateSphere(16)
xEntityFX(lightSource, 1+8)
xPositionEntity(lightSource, xEntityX(light,1), xEntityY(light,1), xEntityZ(light,1))
xEntityParent(lightSource, pivLight)

; main camera
Global Cam     = xCreateCamera()
xCameraClsColor(Cam,100,100,255)
xPositionEntity(Cam, 0,24,-32)

; a debug cube which shows the reflection texture
dc = xCreateCube(Cam)
xEntityOrder(dc, -1)
xEntityFX(dc, #FX_FULLBRIGHT)
xScaleEntity(dc, 1, 1, 0.01)
xMoveEntity(dc, -4.2, 3.0, 10)
xEntityTexture(dc, tTextureReflection)

; a debug cone showing the mirror camera
fake = xCreateCone(16, #True, mCamera)
xRotateMesh(fake, 90, 0, 0)
xScaleMesh(fake, 5, 5, 10)
xEntityColor(fake, 255, 0, 0)

checker = CreateCheckerTexture()
xScaleTexture(checker, 0.125, 0.125)

back = xCreateCube()
xScaleEntity(back, 500, 500, 1)
xPositionEntity(back, 0, 0, -300)
xEntityTexture(back, checker)
xEntityColor(back, 0, 255, 0)

Global cracked = 0

While Not xKeyDown(#KEY_ESCAPE) Or xWinMessage("WM_CLOSE")
	
	If xKeyHit(#KEY_SPACE)
		cracked = 1 - cracked
		If Not cracked
			xSetEffectTechnique(mirror, "Mirror")
		Else
			xSetEffectTechnique(mirror, "Mirror_Broken")
		EndIf
	EndIf
	
	xTurnEntity(PivLight, 0, 1, 0)
	
	MouseLookAndFly()
	
	xHideEntity(dc)
	UpdateMirror(mirror, mCamera, Cam)
	xShowEntity(dc)
	
	xRenderWorld()
	xText(10, xGraphicsHeight() - 55, "WASD to move camera")
	xText(10, xGraphicsHeight() - 40, "Drag mouse to rotate camera")
	If Not cracked
		xText(10, xGraphicsHeight() - 25, "Press <SPACE> to break the mirror")
	Else
		xText(10, xGraphicsHeight() - 25, "What have you done?! Fix it immediately! <SPACE>")
	EndIf
	xFlip()	
Wend

Macro Rnd(MinVal, MaxVal) ; Pseudo-procedure.
((Random((MaxVal - MinVal) * 1000.0) + MinVal * 1000.0) / 1000.0)
EndMacro

Procedure.F CurveValue(newvalue.F, oldvalue.F, increments)
	If increments >  1 : oldvalue.F = oldvalue.F - (oldvalue.F - newvalue.F) / increments : EndIf
	If increments <= 1 : oldvalue.F = newvalue.F : EndIf
	ProcedureReturn oldvalue.F
EndProcedure

Procedure MouseLookAndFly(speed.F=1.0)
	movx.F = (xKeyDown(#KEY_D) - xKeyDown(#KEY_A)) * speed
	movz.F = (xMouseDown(1) - xMouseDown(2)) * speed
	movz.F = movz.F + (xKeyDown(#KEY_W) - xKeyDown(#KEY_S)) * speed
	xMoveEntity(Cam, movx, 0, movz)
	mxs.F = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.F = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
	Define Tmp = mxs : Tmp % 360
  camxa = camxa - Tmp
	camya = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xRotateEntity(Cam, camya, camxa, 0)
	xMoveMouse(center_x, center_y)
EndProcedure

Procedure Garbage(num.I = 40)
	Protected mesh.I
	Protected r.I, g.I, b.I
	Protected lmx.F, lmy.F, lmz.F
	For i = 0 To num - 1
		mesh = xCreateCube()
		xScaleEntity(mesh, Rnd(3.0, 5.0), Rnd(3.0, 5.0), Rnd(3.0, 5.0))
		lmx = Rnd(-40.0, 40.0)
		lmy = Rnd(-40.0, 40.0)
		lmz = Rnd(-40.0, 40.0)
		xPositionEntity(mesh, lmx, lmy, lmz)
		r = (lmx + 40.0) / 80.0 * 255
		g = (lmy + 40.0) / 80.0 * 255
		b = (lmz + 40.0) / 80.0 * 255
		xEntityColor(mesh, r, g, b)
	Next
	
EndProcedure

Procedure CraftMirror()
	
	Protected mesh.I    = xCreateMesh   ()
	Protected surf.I    = xCreateSurface(mesh)
	
	; simple quad
	xAddVertex(surf, -1.0, 1.0, 0.0)
	xAddVertex(surf, 1.0, 1.0, 0.0)
	xAddVertex(surf, 1.0, -1.0, 0.0)
	xAddVertex(surf, -1.0, -1.0, 0.0)
	
	xVertexTexCoords(surf, 0, 0.0, 0.0, 1.0)
	xVertexTexCoords(surf, 1, 1.0, 0.0, 1.0)
	xVertexTexCoords(surf, 2, 1.0, 1.0, 1.0)
	xVertexTexCoords(surf, 3, 0.0, 1.0, 1.0)
	
	xAddTriangle(surf, 0, 2, 1)
	xAddTriangle(surf, 0, 3, 2)
	
	xUpdateNormals(mesh)
	xScaleEntity(mesh, 40, 40, 40)
	
	; reflection texture
	tTextureReflection = xCreateTexture(reflSizeX, reflSizeY, 1)
	
	; crack textures
	tCrackNorm = xLoadTexture("Media\Textures\broken-glass_normal.jpg")
	tCrackDiff = xLoadTexture("Media\Textures\broken-glass_diffuse.jpg")
	
	xEntityTexture(mesh, tTextureReflection, 0, 0)
	xEntityTexture(mesh, tCrackNorm, 0, 1)
	xEntityTexture(mesh, tCrackDiff, 0, 2)
	
	tShader.I = xLoadFXFile("Media\Shaders\mirror.fx")
	xSetEntityEffect(mesh, tShader)
	xSetEffectTechnique(mesh, "Mirror")
	
	; creating the mirror camera
	mCamera.I = xCreateCamera()
	xCameraClsColor(mCamera,100,100,255)
	xHideEntity(mCamera)
	
	; mirror frame
	Protected frame = xCreateCube(mesh)
	xScaleEntity(frame, 1.1, 1.1, 0.01)
	xMoveEntity(frame, 0, 0, -0.02)
	xEntityColor(frame, 64, 64, 64)
	
	ProcedureReturn mesh
EndProcedure

Procedure UpdateMirror(mirrorEnt.I, mirrorCamera.I, viewCamera.I)
	Protected mX.F, mY.F, mZ.F
	Protected vX.F, vY.F, vZ.F
	Protected d.F
	
	; reflecting the position of the main camera and put the mirror camera at that position
	xTFormPoint(0.0, 0.0, 0.0, viewCamera, mirrorEnt)
	xTFormPoint(xTFormedX(), xTFormedY(), -xTFormedZ(), mirrorEnt, 0)
	xPositionEntity(mirrorCamera, xTFormedX(), xTFormedY(), xTFormedZ())
	
	; the normal vector of the mirror plane
	xTFormNormal(0.0, 0.0, 1.0, mirrorEnt, 0)
	mX = xTFormedX()
	mY = xTFormedY()
	mZ = xTFormedZ()
	; view vector of the main camera
	xTFormVector(0.0, 0.0, 1.0, viewCamera, 0)
	vX = xTFormedX()
	vY = xTFormedY()
	vZ = xTFormedZ()
	
	d = 2 * (mX*vX + mY*vY + mZ*vZ) / (mX*mX + mY*mY + mZ*mZ)
	vX = vX - mX * d
	vY = vY - mY * d
	vZ = vZ - mZ * d

	; reflecting the view vector of the main camera
	xAlignToVector(mirrorCamera, vX, vY, vZ, #AXIS_Z)
	
	; here we have a trouble with the Roll - it causes a wrong texture if the mirror is not vertical
	; TODO: fix that!
	xRotateEntity(mirrorCamera, xEntityPitch(mirrorCamera, #True), xEntityYaw(mirrorCamera, #True), xEntityRoll(viewCamera, #True))
	
	xHideEntity(viewCamera)
	xShowEntity(mirrorCamera)
	
	; clipping the objects behind the mirror to avoid wrong reflection
	xCameraClipPlane(mirrorCamera, 0, #True, mX, mY, mZ, -mX * xEntityX(mirrorEnt, #True) - mY * xEntityY(mirrorEnt, #True) - mZ * xEntityZ(mirrorEnt, #True))
	xSetBuffer(xTextureBuffer(tTextureReflection))
	; turning the clipping plane off
	xCameraViewport(mirrorCamera, 0, 0, reflSizeX, reflSizeY)
	xHideEntity(mirror)
	xRenderWorld(1, #False)
	xShowEntity(mirror)
	xSetBuffer(xBackBuffer())
	xHideEntity(mirrorCamera)
	xShowEntity(viewCamera)
EndProcedure

Procedure CreateCheckerTexture(size.I = 256)
	Protected lTex = xCreateTexture(size, size)
	xSetBuffer(xTextureBuffer(lTex))
	xColor(222, 222, 222)
	xRect(0, 0, size, size, 1)
	xColor(255, 255, 255)
	xRect(0, 0, size / 2, size / 2, 1)
	xRect(size / 2, size / 2, size / 2, size / 2, 1)
	xSetBuffer(xBackBuffer())
	ProcedureReturn lTex
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = --
; EnableXP
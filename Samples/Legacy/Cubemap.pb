; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Cubemap'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)
Declare UpdateCubemap(tex, camera, entity)

;initialization
xAppTitle("CubeMap")
xGraphics3D(800, 600, 32, #False, #True)

;creating the camera
cam = xCreateCamera()
xPositionEntity(cam, 0, 30, -150)
cube_cam = xCreateCamera()
xCameraZoom(cube_cam, 0)

;enabling antialiasing
xAntiAlias(#True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPICX16)

;light source creating
light = xCreateLight()
xRotateEntity(light, -45, 0, 0)

;objects loading
teapot = xLoadMesh("media/meshes/teapot.b3d")
xPositionEntity(teapot, 0, 10, -50)
xEntityFX(teapot, 1)
scene = xLoadMesh("media/meshes/level.b3d")

;creating the texture and putting it on the teapot
tex = xCreateTexture(256, 256, 1 + 128)
xEntityTexture(teapot, tex)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

While Not(xKeyDown(1) Or xWinMessage("WM_CLOSE"))

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

	xTurnEntity(teapot,0,1,0)
	
	;if we can't see teapot then we won't update its texture
	If xEntityInView(teapot, cam)
		;turning the main camera off 
		xHideEntity(cam)
		;updating the texture
		UpdateCubemap(tex, cube_cam, teapot)
		;turning the main camera on
		xShowEntity(cam)
	EndIf
	
	;rendering the world
	xRenderWorld()
	
	;fps output
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 60, "Up\Down\Letf\Right - rotate camera")
	xText(10, 80, "W\A\S\D - move camera")
	;drawing
	xFlip()

Wend

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure

;function of texture updating
Procedure UpdateCubemap(tex, camera, entity)
	
	;getting size of the texture
	tex_sz = xTextureWidth(tex)

	;turning camera on
	xShowEntity(camera)
	
	;hiding the object so it won't be rendered to its own texture
	xHideEntity(entity)

	;moving camera to the position of the object
	xPositionEntity(camera, xEntityX(entity, #True), xEntityY(entity, #True), xEntityZ(entity, #True))

	xCameraClsMode(camera, #False, #True)
	
	;changing the size of viewport according to the size of the texture
	xCameraViewport(camera, 0, 0, tex_sz, tex_sz)

	;rendering to the texture

	;left plane
	xSetCubeFace(tex, 0)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, 0, 90, 0)
	xRenderWorld()
	
	;front plane
	xSetCubeFace(tex, 1)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, 0, 0, 0)
	xRenderWorld()
	
	;right plane
	xSetCubeFace(tex, 2)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, 0, -90, 0)
	xRenderWorld()
	
	;back plane
	xSetCubeFace(tex, 3)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, 0, 180, 0)
	xRenderWorld()
	
	;top plane
	xSetCubeFace(tex, 4)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, -90, 0, 0)
	xRenderWorld()
	
	;bottom plane
	xSetCubeFace(tex, 5)
	xSetBuffer(xTextureBuffer(tex))
	xRotateEntity(camera, 90, 0, 0)
	xRenderWorld()
	
	;unhiding the object
	xShowEntity(entity)
	
	;hiding the camera
	xHideEntity(camera)
	
	;setting the render to backbuffer
	xSetBuffer(xBackBuffer())
	
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
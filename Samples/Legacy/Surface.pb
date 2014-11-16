; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Surface'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare.f CurveValue(newvalue.f, oldvalue.f, increments)

;initialization
xAppTitle("Surface")
xGraphics3D(800, 600, 32, #False, #True)

;setting texture filtering mode
xSetTextureFiltering(#TF_ANISOTROPIC)

;enabling antialiasing
xAntiAlias(#True)

;loading the texture and creating the brush
tex = xLoadTexture("media/textures/radiation_box.tga")
;brush = xCreateBrush()
;xBrushTexture brush, tex

;creating the mesh and its surface
mesh = xCreateMesh()
surf = xCreateSurface(mesh, brush)

;creating 4 vertices
v0 = xAddVertex(surf, -5, -5, 0, 0, 1)
v1 = xAddVertex(surf, -5,  5, 0, 0, 0)
v2 = xAddVertex(surf,  5,  5, 0, 1, 0)
v3 = xAddVertex(surf,  5, -5, 0, 1, 1)

;creating 2 triangles
tri1 = xAddTriangle(surf, v0, v1, v2)
tri2 = xAddTriangle(surf, v3, v0, v2)

;generating the normals
xUpdateNormals(mesh)
xEntityTexture(mesh,tex)

;light source creating
light1 = xCreateLight(#LIGHT_DIRECTIONAL)
xRotateEntity(light1, -45, 0, 0)

;creating the camera
cam = xCreateCamera()
xMoveEntity(cam, 0, 0, -15)

; for mouse look
xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
mousespeed.f       = 0.5 
camerasmoothness.f = 4.5

;main loop
While Not xKeyDown(1)

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
	
	;updating and rendering the scene
	xUpdateWorld()
	xRenderWorld()
	
	;fps and traingle counters
	xText(10, 10, "FPS: " + Str(xGetFPS()))
	xText(10, 30, "TrisRendered: " + Str(xTrisRendered()))
	xText(10, 50, "Vertices: " + Str(xCountVertices(surf)))
	xText(10, 70, "Triangles: " + Str(xCountTriangles(surf)))
	
	;drawing the scene
	xFlip()

Wend

; for camera mouse look
Procedure.f CurveValue(newvalue.f, oldvalue.f, increments)
	If increments >  1 : oldvalue.f = oldvalue.f - (oldvalue.f - newvalue.f) / increments : EndIf
	If increments <= 1 : oldvalue.f = newvalue.f : EndIf
	ProcedureReturn oldvalue.f 
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
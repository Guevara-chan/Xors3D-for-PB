; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Aspect Ratio'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CreateCheckerTexture(size.i = 256)

xCreateLog()

xGraphicsAspectRatio(16.0 / 9.0)
xGraphics3D(1024,768, 32, 0, 1)
xGraphicsBorderColor(48, 64, 32)
xGraphicsBorderColor(255, 0, 0)
xSetBuffer(xBackBuffer())

Define cam1 = xCreateCamera()
xcameraclscolor(cam1, 32, 48, 64)
;xCameraViewport(cam1, 0, 0, xGraphicsWidth() >> 1, xGraphicsHeight())
xCameraViewport(cam1, 0, 0, xGraphicsWidth(), xGraphicsHeight() >> 1)
Define cam2 = xCreateCamera()
xcameraclscolor(cam2, 64, 48, 32)
xCameraViewport(cam2, xGraphicsWidth() >> 1, 0, xGraphicsWidth() >> 1, xGraphicsHeight())
xCameraViewport(cam2, 0, xGraphicsHeight() >> 1, xGraphicsWidth(), xGraphicsHeight() >> 1)
xRotateEntity(cam2, 180, 0, 0)

Define light = xCreateLight()
xRotateEntity(light, 90, 0, 0)

Define tex = CreateCheckerTexture()
cube1 = xCreateCube()
xRotateEntity(cube1, 45, 45, 0)
xEntityColor(cube1, 255, 127, 64)
xPositionEntity(cube1, 0, 0, 4)
xEntityTexture(cube1, tex)

Define cube2 = xCreateCube()
xRotateEntity(cube2, 45, 45, 0)
xEntityColor(cube2, 64, 127, 255)
xPositionEntity(cube2, 0, 0, -4)
xEntityTexture(cube2, tex)

xViewport(0, 0, xGraphicsWidth() >> 1, xGraphicsHeight() >> 1)

While Not xKeyHit(#KEY_ESCAPE)
	xTurnEntity(cube1, 0.05, 0.05, 0.05)
	xTurnEntity(cube2, -0.05, 0.05, -0.05)
	If xKeyDown( 205 )= #True : xTurnEntity(cam1,0,-1,0)    : xTurnEntity(cam2, 0, -1, 0)    : EndIf
	If xKeyDown( 203 )= #True : xTurnEntity(cam1,0,1,0)     : xTurnEntity(cam2, 0, 1, 0)     : EndIf
	If xKeyDown( 208 )= #True : xMoveEntity(cam1,0,0,-0.05) : xMoveEntity(cam2, 0, 0, 0.05)  : EndIf
	If xKeyDown( 200 )= #True : xMoveEntity(cam1,0,0,0.05)  : xMoveEntity(cam2, 0, 0, -0.05) : EndIf
	
	If xKeyHit(#KEY_F1) : xGraphicsAspectRatio(5.0 / 4.0)   : EndIf
	If xKeyHit(#KEY_F2) : xGraphicsAspectRatio(4.0 / 3.0)   : EndIf
	If xKeyHit(#KEY_F3) : xGraphicsAspectRatio(16.0 / 10.0) : EndIf
	If xKeyHit(#KEY_F4) : xGraphicsAspectRatio(16.0 / 9.0)  : EndIf
	If xKeyHit(#KEY_F5) : xGraphicsAspectRatio(13.0 / 7.0)  : EndIf
	
	xRenderWorld()
	
	xText(10, 50, "Real aspect ratio of monitor " + xVideoAspectRatioStr())
	xText(10, 100, "F1 for 5:4")
	xText(10, 120, "F2 for 4:3")
	xText(10, 140, "F3 for 16:10")
	xText(10, 160, "F4 for 16:9")
	xText(10, 180, "F5 for 13:7 (something insane)")
	xRect(0, 0, 1024, 768)
	xRect(2, 2, 1020, 764)
	
	xLine(0, 0, xGraphicsWidth(), xGraphicsHeight())
	xLine(0, xGraphicsWidth(), 0, xGraphicsHeight())
	
	xFlip()
	
Wend


Procedure CreateCheckerTexture(size.i = 256)
Define lTex = xCreateTexture(size, size)
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
; Folding = -
; EnableXP
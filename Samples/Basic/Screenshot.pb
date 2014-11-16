; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Screenshot'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare GenerateCubes(num.i = 100)
Declare UpdateCubes()
Declare PrintTime()

#fade_time = 1500*2

#ext_png$ = "png"
#ext_jpg$ = "jpg"
#ext_bmp$ = "bmp"
#ext_tga$ = "tga"
#ext_dds$ = "dds"

#file_ext$ = #ext_png$
#file_name$ = "screenshot." + #file_ext$

Global screen_time.i = 0

Structure TCube
*Entity
EndStructure

Global NewList Cubes.TCube()

xSetAntiAliasType(xGetMaxAntiAlias())
xGraphics3d(1280, 720, 32, 0, 1)
xAntiAlias(#True)

Global camera = xCreateCamera()
xCameraClsColor(camera, 128, 196, 32)

GenerateCubes()

While Not xKeyHit(#KEY_ESCAPE)
	UpdateCubes()
	If xKeyHit(#KEY_SPACE)
		screen_time = xMillisecs()
		xSaveBuffer(xBackBuffer(), #file_name$)
	EndIf
	xRenderWorld()
	PrintTime()
	xFlip()
Wend
End

Macro Rnd(MinVal, MaxVal) ; Pseudo-procedure.
((Random((MaxVal - MinVal) * 1000.0) + MinVal * 1000.0) / 1000.0)
EndMacro

Procedure GenerateCubes(num.i = 100)
	Define r.i, g.i, b.i
	Define lmx.f, lmy.f, lmz.f
	Define gx.f = xGraphicsWidth() * 0.05
	Define gy.f = xGraphicsHeight() * 0.05
	For i = 0 To num - 1
		AddElement(Cubes())
    Define *cube.TCube = Cubes()
		*cube\entity = xCreateCube()
		xScaleEntity(*cube\entity, Rnd(3.0, 5.0), Rnd(3.0, 5.0), Rnd(3.0, 5.0))
		lmx = Rnd(-gx, gx)
		lmy = Rnd(-gy, gy)
		lmz = Rnd(100.0, 150.0)
		xPositionEntity(*cube\entity, lmx, lmy, lmz)
		r = (lmx + 40.0) / 80.0 * 255
		g = (lmy + 40.0) / 80.0 * 255
		b = (lmz + 40.0) / 80.0 * 255
		xEntityColor(*cube\entity, r, g, b)
	Next
EndProcedure

Procedure UpdateCubes()
	Define *cube.TCube
	Define cnt.i = 0
	ForEach Cubes() : *cube = Cubes()
		Define p.i = (cnt % 2) * 2 - 1
		Define y.i = (cnt % 3) * 2 - 1
		Define r.i = (cnt % 4) * 2 - 1
		xTurnEntity(*cube\entity, 0.1 * p, 0.1 * y, 0.1 * r)
		cnt = cnt + 1
	Next
EndProcedure

Procedure PrintTime()
	Define dT.i = xMillisecs() - screen_time
	If (dT < #fade_time)
		xColor(0, 0, 0, 255 * (1.0 - dT / #fade_time))
		xText(10, 10, "Screenshot saved to: '" + #file_name$ + "'")
	EndIf
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
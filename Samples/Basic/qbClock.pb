; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'qbClock'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CreateMasterCube()
Declare CreateClock()
Declare UpdateClock(time.S)
Declare UpdateCubes()

Global gSpeed.F = 8.0
Global Dim digitMasks.S(15)
digitMasks.S(0) = "111101101101111"
digitMasks.S(1) = "110010010010111"
digitMasks.S(2) = "111001111100111"
digitMasks.S(3) = "111001111001111"
digitMasks.S(4) = "101101111001001"
digitMasks.S(5) = "111100111001111"
digitMasks.S(6) = "111100111101111"
digitMasks.S(7) = "111001010010010"
digitMasks.S(8) = "111101111101111"
digitMasks.S(9) = "111101111001001"
digitMasks.S(10) = "000010000010000"
digitMasks.S(11) = "111111111111111"
digitMasks.S(12) = "000000000000000"
digitMasks.S(13) = "101101010101101"
digitMasks.S(14) = "111101111110101"
digitMasks.S(15) = "110101101101110"

Structure Digits
pivot.I
currentState.I
targetState.I
factor.F
time.I
EndStructure

Structure Cubes
currentState.i
targetState.i
*digit.Digits
entity.I
pos.I
EndStructure

Global NewList Digital.Digits()
Global NewList Qubix.Cubes()

xSetAntiAliasType(xGetMaxAntiAlias())
xGraphics3D(1280, 720, 32, 0, 1)
;xGraphics3D(0, 0, 0, 1, 1)

xAntiAlias(#True)

cam = xCreateCamera()
xCameraRange(cam, 1.0, 100.0)
xCameraClsColor(cam, 32, 96, 192)
xPositionEntity(cam, -25, 55, -25)

Global gCube = CreateMasterCube()
xPositionEntity(gCube, -5, 0, 0)
xPointEntity(cam, gCube, 20)

CreateClock()

Global appRun = #True
Global appFade = #False
Global appFadeTime = 0

While appRun
	
	If xGetKey()
		appFade = #True
		appFadeTime = ElapsedMilliseconds()
		gSpeed = 2.0
	EndIf
	If appFade
		UpdateClock(" X0R53D ")
		If (ElapsedMilliseconds() - appFadeTime) > 3000
			appRun = #False
		EndIf
	Else
		UpdateClock(FormatDate("%hh:%ii:%ss", Date()))
	EndIf
	UpdateCubes()
	xRenderWorld()
	xFlip()
	Wend
End

Procedure CreateMasterCube()
	Define ny
	Define lCube = xCreateCube()
	Define lSurf = xGetSurface(lCube, 0)
	For i = 0 To xCountVertices(lSurf) - 1
		ny = xVertexNY(lSurf, i)
		If ny = 1
			xVertexColor(lSurf, i, 32, 96, 192, 1)
			xVertexCoords(lSurf, i, xVertexX(lSurf, i), xVertexY(lSurf, i) + 0.001, xVertexZ(lSurf, i))
		Else
			xVertexColor(lSurf, i, 255, 255, 255, 1)
		EndIf
	Next
	xEntityFX(lCube, #FX_FULLBRIGHT + #FX_VERTEXCOLOR)
	xHideEntity(lCube)
	ProcedureReturn lCube
EndProcedure

Procedure CreateClock()
	For i = -4 To 3 : AddElement(Digital())
		Define *d.Digits = Digital()
		*d\pivot = xCreatePivot()
		*d\currentState = 11
		*d\targetState = 11
		*d\factor = 0.0
		    For z = -2 To 2
			For x = -1 To 1 : AddElement(Qubix())
				Define *cube.Cubes = Qubix()
				*cube\currentState = 0
				*cube\targetState = 0
        *cube\digit = Digital()
				*cube\entity = xCopyEntity(gCube, *cube\digit\pivot)
				*cube\pos = (x + 2) + (z + 2) * 3
				xPositionEntity(*cube\entity, x*2, 0, -z*2)
			Next
		Next
		xPositionEntity(*d\pivot, (i + 0.5) * 7.0, 0, 0)
	Next
EndProcedure

Procedure UpdateClock(time.S)
	If Len(time) <> 8
		ProcedureReturn
	EndIf
	Define dI.I, dPI.I
	Define dS.S
	Define pos.I = 1
	ForEach Digital() : Define *d.Digits = Digital()
		dS = Mid(time, pos, 1)
		If (Asc(dS) > 47) And (Asc(dS) < 58)
			dI = Val(dS)
		Else
			If dS = ":"
				dI = 10
			ElseIf LCase(dS) = "x"
				dI = 13
			ElseIf LCase(dS) = "r"
				dI = 14
			ElseIf LCase(dS) = "d"
				dI = 15
			Else
				dI = 12
			EndIf
		EndIf
		pos + 1
		If dI = 10
			If ElapsedMilliseconds() % 1000 > 850
				dI = 12
			EndIf
		EndIf
		If *d\currentState <> dI
			*d\factor = 0.0
			*d\time = ElapsedMilliseconds()
		Else
			*d\factor = (ElapsedMilliseconds() - *d\time) / 1000.0 * gSpeed
		EndIf
		*d\currentState = dI
		If dI < 9
			*d\targetState = dI + 1
		Else
			If dI = 9
				*d\targetState = 0
			Else
				*d\targetState = *d\currentState
			EndIf
		EndIf
		If dI < 10
			;xPositionEntity(*d\pivot, xEntityX(*d\pivot), dI * 0.5, xEntityZ(*d\pivot))
			xPositionEntity(*d\pivot, xEntityX(*d\pivot), dI * 0.25, xEntityZ(*d\pivot))
			xScaleEntity(*d\pivot, 1, dI * 0.5 + 1.0, 1)
		EndIf
	Next
EndProcedure

Procedure UpdateCubes()
	Define s1.F, s2.F
	Define factor.F
	ForEach Qubix() : Define *c.Cubes = Qubix()
		s1 = *c\currentState
		s2 = Val(Mid(digitMasks(*c\digit\currentState), *c\pos, 1))
		factor = *c\digit\factor
		If factor >= 1.0
			*c\currentState = s2
			factor = 1.0 + Abs(Sin(Radian((factor - 1.0) * 100))) * 0.5
    EndIf
		scale.F = s1 * (1.0 - factor) + s2 * factor
		xScaleEntity(*c\entity, scale, scale, scale)
	Next
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
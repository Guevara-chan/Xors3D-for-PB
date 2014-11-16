; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D extra sample: 'Hexagons (single surface)'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CreateHexagon(surf.I, startIndex.I, radius.F, cx.F, cy.F, cz.F)
Declare GenerateCells(aspectRatio.F = 1.33333)
Declare UpdateControl()
Declare UpdateFrame()
Declare PrintInfo(x.I = 10, y.I = 10)
EnableExplicit

#camZoom = 1.0
#zPlane = 1.0
#mouseRadius = 160.0

Global mode.I = 0
Global distort.I = 1
Global FOV.F = Degree(ATan(1.0 / #CamZoom)) / 2.0
Global mainCell.I = 0
Global lastFrame.I = xMillisecs()
Global screenRadius.F = 160.0
Global deltaRad.F = 180.0
Global vertCount.I = 20
Global cellCount.I = 0

xCreateLog(#LOG_HTML, #LOG_INFO, "Hexagons_singlesurf.html")

xAppTitle("Hexagons (Single Surface)")
xGraphics3d(1024, 768, 32, 0, 0)

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
xCameraZoom(camera, #CamZoom)

;Global backTexture = xLoadTexture("Media\textures\merkava.jpg")
Global backTexture = xLoadTexture("Media\textures\copperhead.jpg")
xSetTextureFilter(backTexture, #TF_NONE)
Global poly = xCreatePoly(#False)
xEntityTexture(poly, backTexture)
xScaleEntity(poly, 1.33333, 1.0, 1.0)
xPositionEntity(poly, 0.0, 0.0, 1.0 / Tan(Radian(FOV)))
xEntityOrder(poly, 1)
xEntityFX(poly, #FX_FULLBRIGHT)

Global shader = xLoadFXFile("Media\Shaders\hexagons_singlesurf.fx")
Global normalTexture = xCreateTexture(xGraphicsWidth(), xGraphicsHeight(), #FLAGS_COLOR + #FLAGS_ALPHA )
Global PostEffect_Offset = xLoadPostEffect("Media\shaders\hexagons_posteffect_offset.fx")
xSetPostEffect( 0, PostEffect_Offset)
xSetPostEffectTexture (PostEffect_Offset, "offsetTexture", normalTexture)

Global cellPiv = xCreatePivot()
mainCell = GenerateCells()

While Not (xKeyHit(#KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
 	UpdateFrame()
	If (distort = 1)
		xSetBuffer(xTextureBuffer(normalTexture))
		xCameraClsColor(camera, 0, 0, 0)
		xShowEntity(cellPiv)
		xRenderEntity(camera, mainCell)
	Else
		xRenderWorld()
	EndIf
	
	If (distort = 1)
		xSetBuffer(xBackBuffer())
		xCameraClsColor(camera, 32, 64, 128)
		xHideEntity(cellPiv)
		xRenderWorld()
		xRenderPostEffects()
	EndIf
	PrintInfo()
	xFlip()
Wend

End

Procedure CreateHexagon(surf.I, startIndex.I, radius.F, cx.F, cy.F, cz.F)
	Protected i.I
	xAddVertex(surf, cx, cy, cz, 0.0, 0.0)
	For i = 0 To 5
		Protected angle.F = i * 60.0
		Protected x.F = radius * Cos(Radian(angle))
		Protected y.F = radius * Sin(Radian(angle))
		xAddVertex(surf, x + cx, y + cy, cz, x, y)
	Next
	For i = 1 To 5
		xAddTriangle(surf, startIndex + 0, startIndex + i+1, startIndex + i)
	Next
	xAddTriangle(surf, startIndex + 0, startIndex + 1, startIndex + 6)
EndProcedure

Procedure GenerateCells(aspectRatio.F = 1.33333)
	Protected cellRadius.F = #zPlane * Tan(Radian(FOV)) / Sin(Radian(60.0)) / vertCount
	Protected horCount.I = Round(vertCount * aspectRatio / Sin(Radian(60.0)), #PB_Round_Up)
	Protected offsetX.F = cellRadius * (1.0 + Cos(Radian(60.0))); + 0.25
	Protected offsetY.F = cellRadius * Sin(Radian(60.0)) * 2.0; + 0.25
	Protected cell.I = xCreateMesh(cellPiv)
	Protected surf.I = xCreateSurface(cell)
	Protected x, y, index.I = 0
	cellCount = 0
  For x = -Round(horCount / 2, #PB_Round_Up) To Round(horCount / 2, #PB_Round_Down)
		For y = -Round(vertCount / 2, #PB_Round_Up) To Round(vertCount / 2, #PB_Round_Down)
			Protected ProtectedOffset.F = 0.0
			      If X & 1 = 1
				ProtectedOffset = offsetY * 0.5
			EndIf
			CreateHexagon(surf, index, cellRadius, x * offsetX, y * offsetY + ProtectedOffset, #zPlane)
			index = index + 7
			cellCount = cellCount + 1
		Next
	Next
	xSetEntityEffect(cell, shader)
	xSetEffectTechnique(cell, "Main")
	ProcedureReturn cell
EndProcedure

Procedure UpdateControl()
	Protected newVertCount.I
	If xKeyHit(#KEY_SPACE)
		mode = 1 - mode
	EndIf
	If xKeyHit(#KEY_ENTER)
		distort = 1 - distort
		If distort = 0
			xShowEntity(cellPiv)
		EndIf
	EndIf
	newVertCount = vertCount + xMouseZSpeed()
	If newVertCount > 76
		newVertCount = 76
	EndIf
	If newVertCount < 2
		newVertCount = 2
	EndIf
	If (newVertCount <> vertCount)
		xFreeEntity(mainCell)
		mainCell = GenerateCells()
	EndIf
	vertCount = newVertCount
EndProcedure

Procedure UpdateFrame()
	Protected x.F, y.F, z.F, radius.F
	Protected screenX.F
	Protected screenY.F
	If mode = 0
		screenX = xGraphicsWidth()* 0.5
		screenY = xGraphicsHeight()* 0.5
		If (screenRadius <= -2.0 * xGraphicsHeight() / vertCount) ; to show the central cell
			screenRadius = -2.0 * xGraphicsHeight() / vertCount
			deltaRad = -deltaRad
		EndIf
		If (screenRadius >= xGraphicsWidth())
			screenRadius = xGraphicsWidth()
			deltaRad = -deltaRad
		EndIf
	Else
		screenX = xMouseX()
		screenY = xMouseY()
		screenRadius = #mouseRadius
	EndIf
	
	x = (screenX * 2.0 / xGraphicsWidth() - 1.0) * Tan(Radian(FOV)) * #zPlane * xGraphicsWidth() / xGraphicsHeight()
	y = (-screenY * 2.0 / xGraphicsHeight() + 1.0)  * Tan(Radian(FOV)) * #zPlane
	radius.F = screenRadius * Tan(Radian(FOV)) * #zPlane / xGraphicsHeight()
	
	xSetEffectVector(mainCell, "clipPoint", x, y, #zPlane, radius)
	If mode = 0
		screenRadius = screenRadius + xDeltaValue(deltaRad, lastFrame)
	EndIf
	lastFrame = xMillisecs()
EndProcedure

Procedure PrintInfo(x.I = 10, y.I = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 240 + x, 110 + y, #True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 240 + x, 110 + y, #False)
	xColor(255, 144, 32, 255)
	xText(10 + x + 120, 10 + y, "Hexagons (Single Surface)", 1)
	xText(10 + x, 25 + y, "Triangles: " + Str(xTrisRendered()))
	xText(10 + x, 40 + y, "DIP calls: " + Str(xDIPCounter()))
	xText(10 + x, 55 + y, "FPS: " + Str(xGetFPS()))
	If mode = 0
		xText(10 + x, 70 + y, "Press <SPACE> to switch to MOUSE mode")
	Else
		xText(10 + x, 70 + y, "Press <SPACE> to switch to AUTO mode")
	EndIf
	If distort = 0
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion ON")
	Else
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion OFF")
	EndIf
	xText(10 + x, 100 + y, "Cells: " + Str(cellCount) + " (use <MOUSE SCROLL> to change)")
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
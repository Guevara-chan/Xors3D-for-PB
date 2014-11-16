; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Graphic Modes'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare AppRunning()
Declare UpdateApp()
Declare GetAllModes()
Declare ListAllModes()

xCreateLog()
Global g_appRuns = #True

Structure tGfxMode
item.i
width.i
height.i
depth.i
gfxMode.s
desktop.i
EndStructure 

Global NewList gfxList.tGfxMode()

xGraphics3d(800, 600, 0, #False, #True)
xSetFont(xLoadFont("Tahoma", 10))
GetAllModes()

time = ElapsedMilliseconds()
yy = 1
While AppRunning()
	If (ElapsedMilliseconds() - time) > 500
		yy = yy + 1
		If yy > 50
			yy = 1
		EndIf
		time = ElapsedMilliseconds()
	EndIf
	xCls()
	UpdateApp()
	ListAllModes()
	xFlip()
Wend
End

Procedure AppRunning()
	ProcedureReturn g_appRuns
EndProcedure

Procedure UpdateApp()
	If xKeyHit(#KEY_ESCAPE) Or xWinMessage("WM_CLOSE")
		g_appRuns = #False
	EndIf
EndProcedure

Procedure GetAllModes()
	For i = 0 To xCountGfxModes()-1
		AddElement(GfxList())
		Define *gfx.tGfxMode = GfxList()
		*gfx\width = xGfxModeWidth(i)
		*gfx\height= xGfxModeHeight(i)
		*gfx\depth = xGfxModeDepth(i)
		If (*gfx\width = xGfxModeWidth(-1)) And (*gfx\height = xGfxModeHeight(-1)) And (*gfx\depth = xGfxModeDepth(-1))
			*gfx\desktop = 1
		Else
			*gfx\desktop = 0
		EndIf
		*gfx\gfxMode = Str(*gfx\width) + " x " + Str(*gfx\height) + " x " + Str(*gfx\depth) + "bpp"
	Next
EndProcedure

Procedure ListAllModes()
	Define i = 0	
	Define x, xS = 10
	Define y, yS = 50
	Define xStep = 200
	Define yStep = 20
	Define heightCap = Round((xGraphicsHeight() - yS) / yStep, #PB_Round_Down)
	ForEach GfxList()
    Define *gfx.tGfxMode = GfxList()
		x = xS + Round(i / heightCap, #PB_Round_Down) * xStep
		y = yS + (i % heightCap) * yStep
		xColor(24, 26, 28)
		xRect(x, y + 1, xStep * 0.9, yStep - 1, #True)
		If (*gfx\desktop = 1)
			xColor(255, 128, 32)
			xText(x + 2, y + 2, ">")
		EndIf
		xColor(196, 196, 196)
		xText(x + 15, y + 2, Str(i+1) + ". ")
		xText(x + 45, y + 2, *gfx\gfxMode)
		i = i + 1
	Next 
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
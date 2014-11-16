; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Parenting #1'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CreateDisks(num.i = 8)
Declare UpdateDisks()


#USE_TEXTURED_POLY = #True

Structure TDisk
entity.i
speed.f
EndStructure

Global NewList Disks.TDisk()

xGraphics3d(1024, 768, 32, 0, 1)

Global camera = xCreateCamera()
xPositionEntity(camera, 0.0, 0.0, -16.0)

Global tex
If #USE_TEXTURED_POLY
	tex = xLoadTexture("Media/Textures/magic_circle.png")
EndIf

CreateDisks()

While Not xKeyHit(#KEY_ESCAPE)
	UpdateDisks()
	xRenderWorld()
	xFlip()
Wend
End

Procedure CreateDisks(num.i = 8)
	Define i.i
	For i = 1 To num
		Define ni.f = (num - i) * 0.5
		Define si.f = ni / num * 20
		Define ci.f
		If #USE_TEXTURED_POLY
			ci = i * 0.35
		Else
			ci = i
		EndIf
    AddElement(Disks())
		Define *disk.TDisk = Disks()
		If (i = 1)
			If #USE_TEXTURED_POLY
				*disk\entity = xCreatePoly(#False)
				xEntityTexture(*disk\entity, tex)
				xEntityBlend(*disk\entity, #BLEND_PUREADD)
			Else
				*disk\entity = xCreateCylinder(32, #True)
				xRotateMesh(*disk\entity, 90, 0, 0)
				xScaleMesh(*disk\entity, 1.0, 1.0, 0.1)
			EndIf
		Else : LastElement(Disks()) : If ListSize(Disks()) > 1 : PreviousElement(Disks()) : EndIf
      Define *l.TDisk = Disks() : LastElement(Disks()) : *disk\entity = xCopyEntity(*l\entity, *l\entity)
		EndIf
		xEntityFX(*disk\entity, #FX_FULLBRIGHT)
		xEntityOrder(*disk\entity, ni + 1)
		xScaleEntity(*disk\entity, si, si, si, #True)
		xPositionEntity(*disk\entity, ci, 0.0, 0.0, #True)
		xEntityColor(*disk\entity, 0, 255 * i / num, 255 * (1.0 - i / num))
		If #USE_TEXTURED_POLY
			xEntityAlpha(*disk\entity, i * 0.5 / num + 0.5)
		EndIf
		*disk\speed = i / num
	Next
EndProcedure

Procedure UpdateDisks()
	Define *disk.TDisk
	ForEach Disks() : *disk = Disks()
		xTurnEntity(*disk\entity, 0.0, 0.0, *disk\speed, #True)
	Next
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
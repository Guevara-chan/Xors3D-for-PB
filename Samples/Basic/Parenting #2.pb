; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Parenting #2'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare GenerateObjs(count.i, height.f, size.f)
Declare UpdateObjs()

Structure TObj
*entity
factor.f
EndStructure

Global NewList Objects.TObj()
Global startTime.i

xGraphics3d(1024, 768, 32, 0, 1)

Global camera = xCreateCamera()
xPositionEntity(camera, 0.0, 20.0, -50.0)

xCreateLight()

GenerateObjs(40, 0.5, 0.1)

While Not xKeyHit(#KEY_ESCAPE)
	UpdateObjs()
	xRenderWorld()
	xFlip()
Wend
End

Procedure GenerateObjs(count.i, height.f, size.f)
	Define max.i = 20
	Define i.i, j.i
	Define *obj.TObj
	Define prevEntity.i, parent.i
	Define initialObj.i = xCreateCube()
	xPositionMesh(initialObj, 0, 1.0, 0)
	xScaleMesh(initialObj, size, height, size)
	
	For j = 1 To max
		prevEntity = 0
		For i = 1 To count
      AddElement(Objects())
			*obj.TObj = Objects()
			*obj\factor = 1.0 / (Sin(Radian(j * 45.0 / 15.0))+ 1.0)
			If ((i = 1) And (j = 1))
				*obj\entity = initialObj
			Else
				*obj\entity = xCopyEntity(initialObj)
			EndIf
			xPositionEntity(*obj\entity, 0, 2.0 * height * (i - 1) * 0.95, 0)
			xEntityColor(*obj\entity, 255.0 / 20 * j, 255.0 / count * i - 255.0 / 20 * j, 255.0 - 255.0 / count * i)
			prevEntity = *obj\entity
		Next
	Next
	Define LSize = ListSize(Objects())
  FirstElement(Objects())
	*obj.TObj = Objects()
	For j = 1 To max
		parent = 0
		For i = 1 To count
			xEntityParent(*obj\entity, parent)
			parent.i = *obj\entity
			If (ListIndex(Objects()) < LSize)
				NextElement(Objects()) : *obj = Objects()
			EndIf
		Next
	Next
	startTime = xMillisecs()
EndProcedure

Procedure UpdateObjs()
	Define *obj.TObj
	ForEach Objects() : *obj.TObj = Objects()
		Define period.f = Sin(Radian((ElapsedMilliseconds() - startTime) * 0.05)) * 25
		xRotateEntity(*obj\entity, 0, 0, period * *obj\factor)
		If (xGetParent(*obj\entity))
			xTurnEntity(*obj\entity, 0, 25.0 * *obj\factor, 0)
		EndIf
	Next
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
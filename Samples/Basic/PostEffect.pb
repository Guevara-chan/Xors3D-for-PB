; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D basic sample: 'Post Effect'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare CubeField(num.I = 10)
Declare CameraControl()
Declare PostEffectControl()
Declare PrintInfo()
Declare Draw2D()
Declare.F CurveValue(newvalue.F, oldvalue.F, increments)

Global masterCube = 0
Global pe_invertion_enabled.I = 1
Global pe_rgb2brg_enabled.I = 0

;xCreateLog(#LOG_HTML, #LOG_INFO, "PostEffect_00.html")
xAppTitle("Simple invertion post-effect")
xGraphics3d(1024, 768, 32, 0, 1)

xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
Global mousespeed.F       = 0.5
Global camerasmoothness.F = 4.5
Global camxa.F = 0
Global camya.F = 0

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
Define light = xCreateLight()

CubeField()

Global PostEffect_Invertion = xLoadPostEffect("media\shaders\simple_posteffect_invertion.fx")
Global PostEffect_RGB2BRG = xLoadPostEffect("media\shaders\simple_posteffect_rgb2brg.fx")

If pe_invertion_enabled
	xSetPostEffect(0, PostEffect_Invertion)
EndIf
If pe_rgb2brg_enabled
	xSetPostEffect(0, PostEffect_RGB2BRG)
EndIf

While Not xKeyHit(#KEY_ESCAPE)
	
	PostEffectControl()
;	CameraControl()
	xRenderWorld()
	Draw2D()
	xRenderPostEffects()
	PrintInfo()
	xFlip()
Wend

End

Procedure CubeField(num.I = 10)
	Define x.I, y.I
	Define i.I
	
	For x = 0 To num - 1
		For y = 0 To num - 1
			Define obj.I
			If (x = 0 And y = 0)
				obj = xCreateCube()
				masterCube = obj
			Else
				obj = xCopyEntity(masterCube)
			EndIf
			xPositionEntity(obj, (x - num * 0.5 + 0.5) * 2.5, (y - num * 0.5 + 0.5) * 2.5, num * 4.0)
			Define r.I = x * 255 / num
			Define g.I = y * 255 / num
			Define b.I = 255 - g
			xEntityColor(obj, r, g, b)
		Next
	Next
EndProcedure

Procedure CameraControl()
	If xKeyDown(#KEY_W) : xMoveEntity(camera,  0,  0,  1.0) : EndIf
	If xKeyDown(#KEY_S) : xMoveEntity(camera,  0,  0, -1.0) : EndIf
	If xKeyDown(#KEY_A) : xMoveEntity(camera, -1.0,  0,  0) : EndIf
	If xKeyDown(#KEY_D) : xMoveEntity(camera,  1.0,  0,  0) : EndIf
	mxs.F = CurveValue(xMouseXSpeed() * mousespeed, mxs, camerasmoothness)
	mys.F = CurveValue(xMouseYSpeed() * mousespeed, mys, camerasmoothness)
  Define Tmp.i = mxs : Tmp % 360
	camxa.F = camxa - Tmp
	camya.F = camya + mys
	If camya < -89 : camya = -89 : EndIf
	If camya >  89 : camya =  89 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(camera, camya, camxa, 0.0)
EndProcedure

Procedure PostEffectControl()
	If xKeyHit(#KEY_1)
		pe_invertion_enabled = 1 - pe_invertion_enabled
		If pe_invertion_enabled
			xSetPostEffect(0, PostEffect_Invertion)
		Else
			xSetPostEffect(0, 0)
		EndIf
	EndIf
	If xKeyHit(#KEY_2)
		pe_rgb2brg_enabled = 1 - pe_rgb2brg_enabled
		If pe_rgb2brg_enabled
			xSetPostEffect(1, PostEffect_RGB2BRG)
		Else
			xSetPostEffect(1, 0)
		EndIf
	EndIf
EndProcedure

Procedure PrintInfo()
	Define state.s
	xColor(255, 128, 64, 128)
	xRect(9, 9, 262, 62, 0)
	xColor(0, 0, 0, 128)
	xRect(10, 10, 260, 60, 1)
	xColor(255, 255, 255, 255)
	If (pe_invertion_enabled = 1)
		state = "DISABLE"
	Else
		state = "ENABLE"
	EndIf
	xText(25, 20, "Press '1' to " + state + " Invertion posteffect.")
	If (pe_rgb2brg_enabled = 1)
		state = "DISABLE"
	Else
		state = "ENABLE"
	EndIf
	xText(25, 40, "Press '2' to " + state + " RGB2BRG posteffect.")
EndProcedure

Procedure Draw2D()
	xColor(255, 128, 0, 255)
	xRect(20, xGraphicsHeight() - 40, xGraphicsWidth() - 40, 30, 1)
	xColor(128, 0, 255, 255)
	xText(xGraphicsWidth() / 2, xGraphicsHeight() - 25, "We can post process 2d graphics too", 1, 1)
EndProcedure

Procedure.f CurveValue(newvalue.F, oldvalue.F, increments)
	If increments >  1 : oldvalue.F = oldvalue.F - (oldvalue.F - newvalue.F) / increments : EndIf
	If increments <= 1 : oldvalue.F = newvalue.F : EndIf
	ProcedureReturn oldvalue.F 
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = --
; EnableXP
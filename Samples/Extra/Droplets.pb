; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D extra sample: 'Droplets'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare LoadSkybox(path.S, ext.S)
Declare CreateDropletBuffer()
Declare LoadDropletNormalMap()
Declare CreateInitialDroplet()
Declare CreateDroplet(x.F = 0.0, y.F = 0.0, size.F = 0.0)
Declare UpdateDroplets()
Declare UpdateCamera(cam.I)
Declare PrintInfo(x.I = 10, y.I = 10)
Declare UpdateControl()
Declare UpdateFrame()
Declare Saturate(value.F)
Declare Clamp(value.F)
Declare.F CurveValue(newvalue.F, oldvalue.F, increments)

#camZoom             = 1.0
#zPlane              = 2.0
#mousespeed          = 0.5
#camerasmoothness    = 4.5
#maxDropletNum       = 500
#minDropletNum       = 0
#dropletAcceleration = -0.0025

Structure TDrop
entity.I
size.F
x.F
y.F
vx.F
vy.F
startTime.I
lifeTime.I
randTime.I
EndStructure

Global NewList Drops.TDrop()
xCreateLog(#LOG_HTML, #LOG_INFO, "Droplets.html")

xAppTitle("Droplets")
xGraphics3d(1024, 768, 32, 0, 1)

Global showDistortion = 1
Global showDropletBuffer = 0
Global g_mouseXSpeed.F = 0.0
Global g_mouseYSpeed.F = 0.0
Global g_cameraXAngle.F = 0.0
Global g_cameraYAngle.F = 0.0
Global cameraXSpeed.F = 0.0
Global cameraYSpeed.F = 0.0
Global FOV.F = Degree(ATan(1.0 / #camZoom)) / 2.0
Global aspectRatio.F = xGraphicsWidth() / xGraphicsHeight()
Global planeHeight.F = #zPlane * Tan(Radian(FOV))
Global planeWidth.F = planeHeight * aspectRatio
Global dropScale.F =  planeHeight * 0.02
Global maxDropletYSpeed.F = 0.36 * dropScale
Global maxArcLength.F = 6.0 * dropScale
Global limitDropletNum.I = 150
Global dropletsNum.I = 0

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)
xCameraRange(camera, 1.0, 1000.0)
xCameraZoom(camera, #camZoom)

Global skybox = LoadSkybox("Media\Textures\Skybox\Miramar\miramar", "dds")

Global droplet_nm.I = LoadDropletNormalMap()
Global dropletBuffer.I = CreateDropletBuffer()
Global dropPiv.I = xCreatePivot(camera)

Global poly = xCreatePoly(0, camera)
xScaleEntity(poly, planeWidth, planeHeight, 1.0)
xPositionEntity(poly, 0.0, 0.0, #zPlane)
xEntityFX(poly, #FX_FULLBRIGHT)
xEntityTexture(poly, dropletBuffer)
xHideEntity(poly)

Global initialDroplet = CreateInitialDroplet()

Global PostEffect_Offset = xLoadPostEffect("Media\shaders\droplets_posteffect_distortion.fx")
xSetPostEffect( 0, PostEffect_Offset )
xSetPostEffectTexture (PostEffect_Offset, "distortionTexture", dropletBuffer)

While Not (xKeyHit(#KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
	UpdateFrame()
	
	If (showDropletBuffer = 0)
		xHideEntity(poly)
	EndIf
	If (showDistortion = 1)
		xSetBuffer(xTextureBuffer(dropletBuffer))
		xCameraClsMode(camera, #False, #False)
		xHideEntity(skybox)
		xShowEntity(dropPiv)
		xColor(128, 128, 0, 4)
		xRect(0, 0, xGraphicsWidth(), xGraphicsHeight(), 1)
	EndIf
	xREnderWorld()
	
	If (showDropletBuffer = 1)
		xShowEntity(poly)
	EndIf
	If (showDistortion = 1)
		xSetBuffer(xBackBuffer())
		xCameraClsColor(camera, 32, 64, 128)
		xCameraClsMode(camera, #True, #True)
		xShowEntity(skybox)
		xHideEntity(dropPiv)
		xREnderWorld()
		xHideEntity(poly)
		If (showDropletBuffer = 0)
			xREnderPostEffects()
		EndIf
	EndIf
	
	PrintInfo()
	
	xFlip()
Wend

End

Macro Rnd(MinVal, MaxVal) ; Pseudo-procedure.
((Random((MaxVal - MinVal) * 1000.0) + MinVal * 1000.0) / 1000.0)
EndMacro

Procedure LoadSkybox(path.S, ext.S)
	Define tex_cube.I = xLoadTexture(path + "_cubemap_dxt1." + ext, #FLAGS_COLOR + #FLAGS_CUBICENVMAP )
	Protected skybox.I = xCreateCube()
	xFlipMesh(skybox)
	xScaleMesh(skybox, 10.0, 10.0, 10.0)
	xEntityOrder(skybox, 1024)
	xEntityTexture(skybox,  tex_cube)
	xEntityFX(skybox, #FX_FULLBRIGHT)
	ProcedureReturn skybox
EndProcedure

Procedure CreateDropletBuffer()
	Define buffer.I = xCreateTexture(xGraphicsWidth(), xGraphicsHeight(), #FLAGS_COLOR + 16384); + FLAGS_ALPHA)
	xSetBuffer(xTextureBuffer(buffer))
	xClsColor(128, 128, 0)
	xCls()
	xSetBuffer(xBackBuffer())
	ProcedureReturn buffer
EndProcedure

Procedure LoadDropletNormalMap()
	ProcedureReturn xLoadTexture("Media\Textures\droplet_nm.dds", #FLAGS_COLOR + #FLAGS_ALPHA)
EndProcedure

Procedure CreateInitialDroplet()
	Define shader = xLoadFXFile("Media\Shaders\droplets_hw_instancing.fx")
	Define droplet = xCreatePoly(0)
	xEntityTexture(droplet, droplet_nm)
	xSetEntityEffect(droplet, shader)
	xSetEffectTechnique(droplet, "Instancing")
	xHideEntity(droplet)
	ProcedureReturn droplet
EndProcedure

Procedure CreateDroplet(x.F = 0.0, y.F = 0.0, size.F = 0.0)
	If x < -1.0 : x = -1.0 : EndIf
	If x >  1.0 : x =  1.0 : EndIf
	If y < -1.0 : y = -1.0 : EndIf
	If y >  1.0 : y =  1.0 : EndIf
	AddElement(Drops())
  Define *d.TDrop = Drops()
	*d\entity = xCreateInstance(initialDroplet, dropPiv)
	If (size = 0)
		*d\size = Rnd(0.25, 1.0) * dropScale
	Else
		*d\size = size
	EndIf
	*d\x = (planeWidth + *d\size) * x
	*d\y = (planeHeight + *d\size) * y
	*d\vx = dropScale * Rnd(-0.0625, 0.0625)
	*d\vy = dropScale * Rnd(-0.3125, -0.0156)
	xPositionEntity(*d\entity, *d\x, *d\y, #zPlane)
	xScaleEntity(*d\entity, *d\size, *d\size, *d\size)
	*d\startTime = xMillisecs()
	*d\randTime = Rnd(5000, 10000)
	*d\lifeTime = *d\startTime + *d\randTime
	dropletsNum = dropletsNum + 1
EndProcedure

Procedure UpdateDroplets()
	Define DefineTime.I = xMillisecs()
	Define cosCameraPitch.F = Cos(Radian(xEntityPitch(camera)))
	Define sinCameraPitch.F = Sin(Radian(xEntityPitch(camera)))
	Define *d.TDrop
	ForEach Drops() : *d = Drops()
		If (xMilliSecs() - *d\startTime > 150)
			*d\vx = dropScale * Rnd(-0.0625, 0.0625)
			*d\vy = *d\vy * (Saturate(Rnd(-100.0, 1.0)) * 0.5 + 1.0) ; sudden rare acceleration
			*d\startTime = xMillisecs()
		EndIf
		*d\vy = (*d\vy + #dropletAcceleration * *d\size) * cosCameraPitch
		*d\vx = *d\vx * (cosCameraPitch * 0.5 + 0.5) * (Saturate(Abs(*d\vy / maxDropletYSpeed))* 0.85 + 0.15) + Clamp(cameraXSpeed) * 0.032 * dropScale * cosCameraPitch
		; limit speed to avoid unnatural 'dotted' streaks
		If (*d\vy < -maxDropletYSpeed)
			*d\vy = -maxDropletYSpeed
		EndIf
		*d\x = *d\x + *d\vx
		*d\y = *d\y + *d\vy
		; droplets should rotate when the camera faces up or down
		Define r.F = Sqr(*d\x * *d\x + *d\y * *d\y)
    Define dArc.F = Clamp(cameraXSpeed) * 32.0 * dropScale * (1.0 - cosCameraPitch)
		If (Abs(r * dArc) > maxArcLength)
			dArc = maxArcLength / r * Sign(dArc)
		EndIf
    Define arc.F = Degree(ATan2(*d\x, *d\y)) - r * dArc
    *d\x = r * Cos(Radian(arc))
  	*d\y = r * Sin(Radian(arc))
    xPositionEntity(*d\entity, *d\x, *d\y, #zPlane)
		Define alpha.F  = (*d\lifeTime - DefineTime) / *d\randTime
		xEntityAlpha(*d\entity, alpha)
		If (xEntityY(*d\entity) < -(planeHeight + *d\size)) Or (*d\lifeTime - DefineTime < 0)
			xFreeEntity(*d\entity)
			DeleteElement(Drops())
			dropletsNum = dropletsNum - 1
		EndIf
	Next
EndProcedure

Procedure Clamp(value.F)
	If value > 1.0 : value = 1.0   : EndIf
	If value < -1.0 : value = -1.0 : EndIf
	ProcedureReturn value
EndProcedure

Procedure Saturate(value.F)
	If value > 1.0 : value = 1.0 : EndIf
	If value < 0.0 : value = 0.0 : EndIf
	ProcedureReturn value
EndProcedure

Procedure UpdateControl()
	UpdateCamera(camera)
	
	If xKeyHit(#KEY_ENTER)
		showDistortion = 1 - showDistortion
		If (showDistortion = 0)
			xHideEntity(dropPiv)
		EndIf
	EndIf
	
	If xKeyHit(#KEY_SPACE)
		showDropletBuffer = 1 - showDropletBuffer
	EndIf
	
	limitDropletNum = limitDropletNum + xMouseZSpeed()
	If limitDropletNum > #maxDropletNum
		limitDropletNum = #maxDropletNum
	EndIf
	If limitDropletNum < #minDropletNum
		limitDropletNum = #minDropletNum
	EndIf
EndProcedure

Procedure UpdateFrame()
	UpdateDroplets()
	While dropletsNum < limitDropletNum
		CreateDroplet(Rnd(-1.0, 1.0), Rnd(-1.0, 1.0))
Wend
EndProcedure

Procedure UpdateCamera(cam.I)
	Define oldPitch.F = xEntityPitch(camera)
	Define oldYaw.F = xEntityYaw(camera)
	g_mouseXSpeed.F = CurveValue(xMouseXSpeed() * #mousespeed, g_mouseXSpeed, #camerasmoothness)
	g_mouseYSpeed.F = CurveValue(xMouseYSpeed() * #mousespeed, g_mouseYSpeed, #camerasmoothness)
	Define Tmp = g_mouseXSpeed : Tmp % 360
  g_cameraXAngle = g_cameraXAngle - Tmp
	g_cameraYAngle = g_cameraYAngle + g_mouseYSpeed
	If g_cameraYAngle < -89.9 : g_cameraYAngle = -89.9 : EndIf
	If g_cameraYAngle >  89.9 : g_cameraYAngle =  89.9 : EndIf
	xMoveMouse(xGraphicsWidth() / 2, xGraphicsHeight() / 2)
	xRotateEntity(cam, g_cameraYAngle, g_cameraXAngle, 0.0)
	cameraXSpeed = xEntityYaw(camera) - oldYaw
	cameraYSpeed = xEntityPitch(camera) - oldPitch
EndProcedure

Procedure PrintInfo(x.I = 10, y.I = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 245 + x, 125 + y, #True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 245 + x, 125 + y, #False)
	xColor(96, 152, 255, 255)
	xText(10 + x + 120, 10 + y, "Droplets", 1)
	xText(10 + x, 25 + y, "Triangles: " + Str(xTrisREndered()))
	xText(10 + x, 40 + y, "DIP calls: " + Str(xDIPCounter()))
	xText(10 + x, 55 + y, "FPS: " + Str(xGetFPS()))
	If showDropletBuffer = 0
		xText(10 + x, 70 + y, "Press <SPACE> to SHOW droplet buffer")
	Else
		xText(10 + x, 70 + y, "Press <SPACE> to HIDE droplet buffer")
	EndIf
	If showDistortion = 0
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion ON")
	Else
		xText(10 + x, 85 + y, "Press <ENTER> to turn distortion OFF")
	EndIf
	xText(10 + x, 100 + y, "Droplets: " + Str(dropletsNum) + " (use <MOUSE SCROLL> to change)")
	xText(10 + x, 115 + y, "Use <MOUSE> to rotate camera")
EndProcedure

Procedure.F CurveValue(newvalue.F, oldvalue.F, increments)
	If increments >  1 : oldvalue.F = oldvalue.F - (oldvalue.F - newvalue.F) / increments : EndIf
	If increments <= 1 : oldvalue.F = newvalue.F : EndIf
	ProcedureReturn oldvalue.F 
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = ---
; EnableXP
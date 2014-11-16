; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D shading sample: 'Burn'
; Original source from MoKa (Maxim Miheyev)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare UpdateInput()
Declare UpdateCamera(Camera.i,ViewSensivity.f,MoveSensivity.f)
Macro SinD(Val) : Sin(Radian(Val)) : EndMacro
Macro CosD(Val) : Cos(Radian(Val)) : EndMacro
;====================================

;====================================
; Window
xGraphics3D(800,600,32,0,1)
xSetTextureFiltering(#TF_ANISOTROPIC)
;====================================


;====================================
; *Font
Define *Font=xLoadFont("Tahoma",10)
xSetFont(*Font)
;====================================


;====================================
; Varriables
Global mXSp.i,mYSp.i
Global IKdQ.i,IKdW.i,IKdE.i,IKdA.i,IKdS.i,IKdD.i
;====================================


;====================================
; Camera
Global gCamera.i=xCreateCamera()
xCameraZoom(gCamera,0.8)
xCameraClsColor(gCamera,50,50,50)
xRotateEntity(gCamera,20,0,0)
xMoveEntity(gCamera,0,10,-100)
;====================================


;====================================
; LightSphere
Define tLightSpr.i=xCreateSphere(8)
xEntityFX(tLightSpr,1)
;====================================


;====================================
; Shader
Define tShader.i=xLoadFXFile("Media\Materials\Burn.fx")
;====================================


;====================================
; Model
Define tModel.i=xLoadMesh("Media\Extra media\Teapot.b3d")

Define tTextureDiffuse.i=xLoadTexture("Media\Extra media\Rockwall_Diffuse.jpg")
Define tTextureHeight.i=xLoadTexture("Media\Extra media\Rockwall_Height.png")
Define tTextureFire.i=xLoadTexture("Media\Extra media\Fire.png")

xSetEntityEffect(tModel,tShader)
xSetEffectTechnique(tModel,"Normal")
xSetEffectMatrixSemantic(tModel,"MatWorldViewProj",#WORLDVIEWPROJ)
xSetEffectMatrixSemantic(tModel,"MatWorld",#WORLD)
;		Shader Varriables
xSetEffectFloat(tModel,		"SourceRng",10)
xSetEffectFloat(tModel,		"BurnHeightInt",1)
xSetEffectVector(tModel,	"BurnOClr",0.9,0.5,0)
xSetEffectVector(tModel,	"BurnBClr",0.2,0.2,0.2)
xSetEffectFloat(tModel,		"BurnOWidth",0.2)
xSetEffectFloat(tModel,		"BurnBWidth",0.08)
xSetEffectFloat(tModel,		"BurnRWidth",0.05)
xSetEffectTexture(tModel,	"tDiffuse",tTextureDiffuse)
xSetEffectTexture(tModel,	"tHeight",tTextureHeight)
xSetEffectTexture(tModel,	"tFire",tTextureFire)

Define BurnHeight.f,tPointLight.i
;====================================



;====================================
; Main Cycle
xMoveMouse(400,300)

Repeat

		UpdateInput()
		UpdateCamera(gCamera,0.1,1)
		
		;====================================
		If xKeyHit(#KEY_1)
			BurnHeight=0.0
			tPointLight=#False
			xSetEffectTechnique(tModel,"Normal")
		EndIf
		If xKeyHit(#KEY_2)
			BurnHeight=0.0
			tPointLight=#True
			xSetEffectTechnique(tModel,"PointDistance")
		EndIf
		
		If xKeyHit(#KEY_SPACE)
			xPositionEntity(tLightSpr,(Random(600)-300)/10.0,(Random(600)-300)/10.0,(Random(600)-300)/10.0)
			xSetEffectVector(tModel,"SourcePos",xEntityX(tLightSpr),xEntityY(tLightSpr),xEntityZ(tLightSpr))
			BurnHeight=0.0
		EndIf
		
		BurnHeight=BurnHeight+0.005
		If BurnHeight>1.0 : BurnHeight=0.0 : EndIf
		
		If tPointLight : xSetEffectFloat(tModel,"SourceRng",BurnHeight*250) : EndIf
		xSetEffectFloat(tModel,"BurnHeight",BurnHeight)
		;====================================
		
		If xKeyHit(#KEY_ESCAPE) : End : EndIf
	
	xRenderWorld()
	
	xText(10,10,"TrisRendered: "+Str(xTrisRendered()))
	xText(10,25,"FPS: "+Str(xGetFPS()))
	xText(10,565,"Press ;Space; to Change Point Position")
	xText(10,580,"Press 1,2 to Change Burn Mode")
	
	xFlip()
ForEver
;====================================



;====================================
; Functions
Procedure UpdateInput()
	xMoveMouse(400,300)
	mXSp=xMouseXSpeed() : mYSp=xMouseYSpeed()
	IKdQ=xKeyDown(#KEY_Q) : IKdW=xKeyDown(#KEY_W)
	IKdE=xKeyDown(#KEY_E) : IKdA=xKeyDown(#KEY_A)
	IKdS=xKeyDown(#KEY_S) : IKdD=xKeyDown(#KEY_D)
EndProcedure

Procedure.f SgnF(Val.F) ; Returns sign of value.
If Val > 0     : ProcedureReturn 1
ElseIf Val < 0 : ProcedureReturn -1
EndIf
EndProcedure

Procedure UpdateCamera(Camera.i,ViewSensivity.f,MoveSensivity.f)
	Define CamP.f=xEntityPitch(gCamera)+mYSp*ViewSensivity
	If Abs(CamP)>80 : CamP=80*SgnF(CamP) : EndIf
	xTurnEntity(Camera,0,-mXSp*ViewSensivity,0)
	xRotateEntity(Camera,CamP,xEntityYaw(gCamera),0)
	
	xMoveEntity(Camera,(IKdD-IKdA)*MoveSensivity,(IKdE-IKdQ)*MoveSensivity,(IKdW-IKdS)*MoveSensivity)
EndProcedure
;====================================
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
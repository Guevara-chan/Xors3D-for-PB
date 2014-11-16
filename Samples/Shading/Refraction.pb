; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D shading sample: 'Refraction'
; Original source from MoKa (Maxim Miheyev)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare UpdateInput()
Declare UpdateCamera(Camera.i,ViewSensivity.f,MoveSensivity.f)
Declare mLoadSkyBox(Dir$,Typ$="jpg")
Macro SinD(Val) : Sin(Radian(Val)) : EndMacro
Macro CosD(Val) : Cos(Radian(Val)) : EndMacro
;====================================


;====================================
; Window
xGraphics3D(800,600,32,0,1)
xSetTextureFiltering(#TF_ANISOTROPIC)
;====================================


;====================================
; Font
Define *Font=xLoadFont("Tahoma",10)
xSetFont(*Font)
;====================================


;====================================
; Varriables
Global mXSp.i,mYSp.i
Global IKdQ.i,IKdW.i,IKdE.i,IKdA.i,IKdS.i,IKdD.i
Global IKhF1.i,EffRefractionNM.i=#True
;====================================


;====================================
; Camera
Global gCamera.i=xCreateCamera()
xCameraZoom(gCamera,0.8)
xCameraClsColor(gCamera,0,0,0)
xRotateEntity(gCamera,-20,45,0)
xMoveEntity(gCamera,0,10,-100)
xCameraRange(gCamera,1,6000)
;====================================


;====================================
; SkyBox
Global SkyBox.i=mLoadSkyBox("Media\Extra media\SkyBox\Sky1")
xPositionMesh(SkyBox,0,1,0)
xScaleEntity(SkyBox,3000,1500,3000)
;====================================


;====================================
; Shader
Define tShader.i=xLoadFXFile("Media\Materials\Refraction.fx")
;====================================


;====================================
; Model
Define tModel.i=xLoadMesh("Media\Extra media\HellKnight.b3d")
xUpdateNormals(tModel)

Define tTextureNormal.i=xLoadTexture("Media\Extra media\HellKnight_Normal.jpg")
Define tTextureScreen.i=xCreateTexture(256,192)

xSetEntityEffect(tModel,tShader)
xSetEffectTechnique(tModel,"RefractionNM")
xSetEffectMatrixSemantic(tModel,"MatWorldViewProj",#WORLDVIEWPROJ)
xSetEffectMatrixSemantic(tModel,"MatWorld",#WORLD)
;		Shader Varriables
xSetEffectTexture(tModel,	"tNormal",tTextureNormal)
xSetEffectTexture(tModel,	"tScreen",tTextureScreen)
xSetEffectFloat(tModel,		"FallOffInt",0.2)
xSetEffectVector(tModel,	"FallOffClr",0,0.6,0.8)
xSetEffectFloat(tModel,		"FallOffSoft",4)
xSetEffectFloat(tModel,		"Refract",0.1)
;====================================





;====================================
; Main Cycle
xMoveMouse(400,300)

Repeat

		UpdateInput()
		UpdateCamera(gCamera,0.1,1)
		
		;====================================
		xTurnEntity(tModel,0,0.2,0)
		
		If IKhF1
			EffRefractionNM = EffRefractionNM ! 1
			If EffRefractionNM
				xSetEffectTechnique(tModel,"RefractionNM")
			Else
				xSetEffectTechnique(tModel,"Refraction")
			EndIf
		EndIf
		;====================================
		
		If xKeyHit(#KEY_ESCAPE) : End : EndIf
	
	;====================================
	; Render Refraction
	xHideEntity(tModel)
	xCameraViewport(gCamera,0,0,256,192)
	xSetBuffer(xTextureBuffer(tTextureScreen))
	xRenderWorld()
	xSetBuffer(xBackBuffer())
	xCameraViewport(gCamera,0,0,800,600)
	xShowEntity(tModel)
	;====================================
	; Setting Parameters
	xSetEffectVector(tModel,	"PosCamera",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera))
	;====================================
	xRenderWorld()
	;====================================
	
	
	;====================================
	xText(10,10,"TrisRendered: "+Str(xTrisRendered()))
	xText(10,25,"FPS: "+Str(xGetFPS()))
	;====================================
	If EffRefractionNM
		xText(10,575,"Press F1 to Change Refraction Mode to Simple")
	Else
		xText(10,575,"Press F1 to Change Refraction Mode to Normal Mapped")
	EndIf
	;====================================
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
	IKhF1=xKeyHit(#KEY_F1)
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

Procedure mLoadSkyBox(Dir$,Typ$="jpg")
	Define Mesh.i=xCreateMesh()
	Define Brush.i,Texture.i,Surf.i,v0.i,v1.i,v2.i,v3.i
	
	; Left
	If FileSize(Dir$+"\"+"left."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"left."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1,-1,0,0)
		v1=xAddVertex(Surf,-1, 1, 1,1,0)
		v2=xAddVertex(Surf,-1,-1,-1,0,1)
		v3=xAddVertex(Surf,-1,-1, 1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	; Front
	If FileSize(Dir$+"\"+"front."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"front."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1,1,0,0)
		v1=xAddVertex(Surf, 1, 1,1,1,0)
		v2=xAddVertex(Surf,-1,-1,1,0,1)
		v3=xAddVertex(Surf, 1,-1,1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	; Right
	If FileSize(Dir$+"\"+"right."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"right."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,1, 1, 1,0,0)
		v1=xAddVertex(Surf,1, 1,-1,1,0)
		v2=xAddVertex(Surf,1,-1, 1,0,1)
		v3=xAddVertex(Surf,1,-1,-1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	; Back
	If FileSize(Dir$+"\"+"back."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"back."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf, 1, 1,-1,0,0)
		v1=xAddVertex(Surf,-1, 1,-1,1,0)
		v2=xAddVertex(Surf, 1,-1,-1,0,1)
		v3=xAddVertex(Surf,-1,-1,-1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	; Bottom
	If FileSize(Dir$+"\"+"bottom."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"bottom."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1,-1, 1,0,0)
		v1=xAddVertex(Surf, 1,-1, 1,1,0)
		v2=xAddVertex(Surf,-1,-1,-1,0,1)
		v3=xAddVertex(Surf, 1,-1,-1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	; Top
	If FileSize(Dir$+"\"+"top."+Typ$)=>0
		Texture=xLoadTexture(Dir$+"\"+"top."+Typ$,49)
		Brush=xCreateBrush()
		xBrushTexture(Brush,Texture)
		Surf=xCreateSurface(Mesh,Brush)
		v0=xAddVertex(Surf,-1, 1, 1,0,0)
		v1=xAddVertex(Surf,-1, 1,-1,1,0)
		v2=xAddVertex(Surf, 1, 1, 1,0,1)
		v3=xAddVertex(Surf, 1, 1,-1,1,1)
		xAddTriangle(Surf,v2,v1,v0)
		xAddTriangle(Surf,v1,v2,v3)
	EndIf
	
	xEntityFX(Mesh,1+8)
	xFlipMesh(Mesh)
	xUpdateNormals(Mesh)
	
	ProcedureReturn Mesh
EndProcedure
;====================================
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP
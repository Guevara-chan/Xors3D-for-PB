; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D shading sample: 'Refraction Particle'
; Original source from MoKa (Maxim Miheyev)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

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
Define tShader.i=xLoadFXFile("Media\Materials\Refraction Particle.fx")
;====================================


;====================================
; Model
Define tModel.i=xCreatePoly(0, 0)
xScaleEntity(tModel,30,30,30)
xUpdateNormals(tModel)

Define tTextureDiffuse.i=xLoadTexture("Media\Extra media\Spark.png")
Define tTextureNormalS.i=xLoadTexture("Media\Extra media\Fire_NormalS.png")
Define tTextureNormalF.i=xLoadTexture("Media\Extra media\Fire_NormalF.png")
Define tTextureScreen.i=xCreateTexture(256,192)

xSetEntityEffect(tModel,tShader)
xSetEffectTechnique(tModel,"Refraction")
xSetEffectMatrixSemantic(tModel,"MatWorldViewProj",#WORLDVIEWPROJ)
xSetEffectMatrixSemantic(tModel,"MatWorld",#WORLD)
;		Shader Varriables
xSetEffectTexture(tModel,	"tAlpha",tTextureDiffuse)
xSetEffectTexture(tModel,	"tNormalS",tTextureNormalS)
xSetEffectTexture(tModel,	"tNormalF",tTextureNormalF)
xSetEffectTexture(tModel,	"tScreen",tTextureScreen)
xSetEffectFloat(tModel,		"Refract",0.1)

Define Offset.f=0
;====================================





;====================================
; Main Cycle
xMoveMouse(400,300)

Repeat
		
		UpdateInput()
		UpdateCamera(gCamera,0.1,1)
		
		;====================================
		Offset=Offset+0.01
		;====================================
		
		If xKeyHit(#KEY_ESCAPE) : End : EndIf
	
	xPointEntity(tModel,gCamera)
	xTurnEntity(tModel,0,180,0)
	xPositionEntity(SkyBox,xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera))
	
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
	xSetEffectFloat(tModel,		"Offset",Offset)
	xSetEffectVector(tModel,	"PosCamera",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera))
	;====================================
	xRenderWorld()
	;====================================
	
	
	;====================================
	xText(10,10,"TrisRendered: "+Str(xTrisRendered()))
	xText(10,25,"FPS: "+Str(xGetFPS()))
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
; EnableUnicode
; EnableXP
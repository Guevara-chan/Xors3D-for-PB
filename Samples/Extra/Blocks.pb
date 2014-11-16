; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D extra sample: 'Blocks'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

#blocksVert = 10
#blocksHor = #blocksVert * 2
#blockScale = 1.0

Global blockZPos.F = #blocksHor * 2.5
Global g_state.I  = 1
Global g_mode.I   = 0
Global g_dirMov.I = 1
Global g_dirRot.I = 1
Global g_subScale.F = 0.0
Global g_texNum.I = 0
Global g_uvShift0.I = 0
Global g_uvShift1.I = 0
Global g_activeSide.I = 0
Global g_activeTex.I  = 0

Structure TBlock
entity.I
state.I
angle.F
EndStructure

Structure TTexture
tex.I
EndStructure

Global Dim blocks.TBlock(#blocksHor, #blocksVert)
Global NewList Textures.TTexture()
Global NewList Blockz.TBlock()

xCreateLog(#LOG_HTML, #LOG_INFO, "Blocks.html")

xAppTitle("Blocks")
xGraphics3d(1280, 720, 32, 0, 1)

xSetFont(xLoadFont("Tahoma", 8))

Global camera = xCreateCamera()
xCameraClsColor(camera, 32, 64, 128)

Global light = xCreateLight()
xTurnEntity(light, 60, 0, 0)

Global initBlock, blockPiv ; Dissected.

Procedure CreateInitialBlock()
	Define *t0.TTexture, *t1.TTexture
	Define shader = xLoadFXFile("Media\Shaders\blocks_hw_instancing.fx")
	Define block = xCreateCube() : FirstElement(Textures())
	*t0.TTexture = Textures()    : NextElement(Textures())
	*t1.TTexture = Textures()
	xScaleMesh(block, 1.0, 1.0, 0.1)
	xEntityTexture(block, *t0\tex, 0, 0)
	xEntityTexture(block, *t1\tex, 0, 1)
	xSetEntityEffect(block, shader)
	xSetEffectTechnique(block, "Instancing")
	xHideEntity(block)
	ProcedureReturn block
EndProcedure

Procedure LoadOneTexture(path.S)
	Define tex.I = xLoadTexture(path)
	If (tex <> 0) : AddElement(Textures())
		Define *t.TTexture = Textures()
		*t\tex = tex
		g_texNum = g_texNum + 1
	EndIf
	ProcedureReturn tex
EndProcedure

Procedure LoadTextures(path.S, ext.S = "jpg")
	Define result.I = 0
	Define formedPath.S = ""
	Define index.I = 0
	xSetLogLevel(#LOG_NO)
	Repeat
		formedPath = path
		If (index < 10)
			formedPath = formedPath + "0"
		EndIf
		formedPath = formedPath + Str(index) + "." + ext
		result = LoadOneTexture(formedPath)
  index = index + 1
	Until result = 0
	xSetLogLevel(#LOG_INFO)
EndProcedure

Procedure CreateBlocks()
	Define i.I, j.I
	
	For i = 0 To #blocksHor - 1
		For j = 0 To #blocksVert - 1
			AddElement(Blockz())
      blocks(i, j) = Blockz()
			blocks(i, j)\state = 0
			blocks(i, j)\angle = 0.0
			blocks(i, j)\entity = xCreateInstance(initBlock, blockPiv)
			xScaleEntity(blocks(i, j)\entity, #blockScale, #blockScale, #blockScale)
			xPositionEntity(blocks(i, j)\entity, i * 2.0 - #blocksHor + 1.0, j * 2.0 - #blocksVert + 1.0, 0.0)
			; packing the block id and the number of blocks in the column to the diffuse color of the entity
			xEntityColor(blocks(i, j)\entity, i, j, #blocksVert)
		Next
	Next
EndProcedure

Procedure UpdateBlocksByRow(firstIteration.I = 0, triggerYaw.F = 90.0, speed.F = 1.0, subScale.F = 0.5, dirMov.I = 1, dirRot.I = 1)
	Define i.I, j.I, jj.I
	Define minJ.I, maxJ.I, deltaJ.I
	Define isFinished.I = 1
	If (dirMov = 1)
		minJ = 0
		maxJ = #blocksVert - 1
		deltaJ = 1
	Else
		dirMov = -1
		minJ = #blocksVert - 1
		maxJ = 0
		deltaJ = -1
	EndIf
	If (dirRot <> 1)
		dirRot = 0
	EndIf
	For jj = 0 To #blocksVert - 1
		If (dirMov = 1)
			j = jj
		Else
			j = #blocksVert - 1 - jj
		EndIf
		If (j = minJ)
			If (firstIteration = 1)
				isFinished = 0
				For i = 0 To #blocksHor - 1
					blocks(i, j)\state = 1
				Next
			EndIf
		EndIf
		For i = 0 To #blocksHor - 1
			If (blocks(i, j)\state = 1)
				isFinished = 0
				If (blocks(i, j)\angle >= 180.0)
;					Define roll.F = xEntityRoll(blocks(i, j)\entity)
;					Define pitch.F = Ceil(FixPitch(xEntityPitch(blocks(i, j)\entity), roll) / 180.0) * 180.0
;					Define yaw.F = Ceil(FixYaw(xEntityYaw(blocks(i, j)\entity)) / 180.0) * 180.0
;					xRotateEntity(blocks(i, j)\entity, pitch, yaw, roll)
					blocks(i, j)\angle = 0.0
					blocks(i, j)\state = 0
				Else
					xTurnEntity(blocks(i, j)\entity, speed * dirRot, speed * (1 - dirRot), 0.0)
					Define shift.F = Sin(Radian(xEntityYaw(blocks(i, j)\entity))) * (1 - dirRot)
					shift = shift + Sin(Radian(xEntityPitch(blocks(i, j)\entity))) * dirRot
					shift = shift * 2.5
					xPositionEntity(blocks(i, j)\entity, xEntityX(blocks(i, j)\entity), xEntityY(blocks(i, j)\entity), shift)
					Define scale.F = #blockScale / (Abs(shift) * subScale + 1.0)
					xScaleEntity(blocks(i, j)\entity, scale, scale, scale)
					blocks(i, j)\angle = blocks(i, j)\angle + Abs(speed)
				EndIf
				If (blocks(i, j)\angle >= triggerYaw)
					If (j * dirMov < maxJ * dirMov)
						blocks(i, j + deltaJ)\state = 1
					EndIf
				EndIf
			EndIf
		Next
	Next
	ProcedureReturn isFinished
EndProcedure

Procedure UpdateBlocksByColumn(firstIteration.I = 0, triggerYaw.F = 90.0, speed.F = 1.0, subScale.F = 0.5, dirMov.I = 1, dirRot.I = 1)
	Define i.I, j.I, jj.I
	Define minJ.I, maxJ.I, deltaJ.I
	Define isFinished.I = 1
	If (dirMov = 1)
		minJ = 0
		maxJ = #blocksHor - 1
		deltaJ = 1
	Else
		dirMov = -1
		minJ = #blocksHor - 1
		maxJ = 0
		deltaJ = -1
	EndIf
	If (dirRot <> 1)
		dirRot = 0
	EndIf
	For jj = 0 To #blocksHor - 1
		If (dirMov = 1)
			j = jj
		Else
			j = #blocksHor - 1 - jj
		EndIf
		If (j = minJ)
			If (firstIteration = 1)
				isFinished = 0
				For i = 0 To #blocksVert - 1
					blocks(j, i)\state = 1
				Next
			EndIf
		EndIf
		For i = 0 To #blocksVert - 1
		If (blocks(j, i)\state = 1)
				isFinished = 0
				If (blocks(j, i)\angle >= 180.0)
;					Define roll.F = xEntityRoll(blocks(j, i)\entity)
;					Define pitch.F = Ceil(FixPitch(xEntityPitch(blocks(j, i)\entity), roll) / 180.0) * 180.0
;					Define yaw.F = Ceil(FixYaw(xEntityYaw(blocks(j, i)\entity)) / 180.0) * 180.0
;					xRotateEntity(blocks(j, i)\entity, pitch, yaw, roll)
					blocks(j, i)\angle = 0.0
					blocks(j, i)\state = 0
				Else
					xTurnEntity(blocks(j, i)\entity, speed * dirRot, speed * (1 - dirRot), 0.0)
					Define shift.f = Sin(Radian(xEntityYaw(blocks(j, i)\entity))) * (1 - dirRot)
					Define Aux.f = Sin(Radian(xEntityPitch(blocks(j, i)\entity))) * DirRot
					shift = (Aux + shift) * 2.5
					xPositionEntity(blocks(j, i)\entity, xEntityX(blocks(j, i)\entity), xEntityY(blocks(j, i)\entity), shift)
          Define scale.F = #blockScale / (Abs(shift) * subScale + 1.0)
         	xScaleEntity(blocks(j, i)\entity, scale, scale, scale)
					blocks(j, i)\angle = blocks(j, i)\angle + Abs(speed)
				EndIf
				If (blocks(j, i)\angle >= triggerYaw)
					If (j * dirMov < maxJ * dirMov)
						blocks(j + deltaJ, i)\state = 1
					EndIf
				EndIf
			EndIf
		Next
	Next
	ProcedureReturn isFinished
EndProcedure

Procedure UpdateBlocks()
	If (g_state = 1)
		Define i.I
		Define rndTex.I
    FirstElement(Textures())
		Define *t.TTexture = Textures()
		g_mode    = Random(3)
		If (g_mode > 1)
			g_mode = g_mode % 2
			g_subScale = 0.5
		Else
			g_subScale = 0.0
		EndIf
		g_dirMov  = Random(1)
		g_dirRot  = Random(1)
		g_activeSide = 1 - g_activeSide
    Repeat
			rndTex = Random(g_texNum - 1)
		Until rndTex <> g_activeTex
		g_activeTex = rndTex
		For i = 0 To g_activeTex - 1
			NextElement(Textures()) : *t = Textures()
		Next
    	xEntityTexture(initBlock, *t\tex, 0, g_activeSide)
		If (g_activeSide = 0)
			g_uvShift0 = g_uvShift1
			If (g_dirRot = 0)
			Else
				g_uvShift0 = 1 - g_uvShift0
			EndIf
		Else
			g_uvShift1 = g_uvShift0
			If (g_dirRot = 0)
			Else
				g_uvShift1 = 1 - g_uvShift1
			EndIf
		EndIf
		xSetEffectVector(initBlock, "uvShift", g_uvShift0, g_uvShift1, 0.0, 0.0)
	EndIf
	Select g_mode
		Case 0
			g_state = UpdateBlocksByColumn(g_state, 25.0, 2.0, g_subScale, g_dirMov, g_dirRot)
		Case 1
			g_state = UpdateBlocksByRow(g_state, 25.0, 2.0, g_subScale, g_dirMov, g_dirRot)
	EndSelect
EndProcedure


Procedure UpdateBlockBoard()
	Define mX.F = (xMouseX() - xGraphicsWidth() * 0.5) * 0.02
	Define mY.F = -(xMouseY() - xGraphicsHeight() * 0.5) * 0.02
xRotateEntity(blockPiv, mY, mX, 0)
EndProcedure

Procedure.F FixPitch(pitch.F, roll.F)
	If (roll >= 180)
		pitch = 180 - pitch
	EndIf
	If (pitch < 0)
		pitch = pitch + 360
	EndIf
	ProcedureReturn pitch
EndProcedure

Procedure.F FixYaw(yaw.F)
	If (yaw < 0)
		yaw = 360 + yaw
	EndIf
	ProcedureReturn yaw
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

Procedure UpdateCamera(cam.I)
EndProcedure

Procedure UpdateControl()
	UpdateCamera(camera)
EndProcedure

Procedure UpdateFrame()
	UpdateBlocks()
	UpdateBlockBoard()
EndProcedure

Procedure DrawTexButtons()
	Define xOffset.F = xGraphicsWidth() * 0.5
	Define yOffset.F = xGraphicsHeight() * 0.95
	Define rad.F = 20.0
	Define i.I
	
	For i = 0 To g_texNum - 1
		Define x.F = (i * 2.0 - g_texNum + 1.5) * rad + xOffset
		If (i = g_activeTex)
			xColor(200, 50, 25, 200)
			xRect(x - rad - 2, yOffset - rad - 2, rad + 4, rad + 4, 1)
		EndIf
		xColor(50, 100, 200, 200)
		xRect(x - rad, yOffset - rad, rad, rad, 1)
	Next
EndProcedure

Procedure PrintInfo(x.I = 10, y.I = 10)
	xColor(0, 0, 0, 128)
	xRect(x, y, 245 + x, 95 + y, True)
	xColor(255, 255, 255, 64)
	xRect(x, y, 245 + x, 95 + y, False)
	xColor(96, 152, 255, 255)
	xText(10 + x + 120, 10 + y, "Blocks", 1)
	xText(10 + x, 25 + y, "Triangles: " + Str(xTrisRendered()))
	xText(10 + x, 40 + y, "DIP calls: " + Str(xDIPCounter()))
	xText(10 + x, 55 + y, "FPS: " + Str(xGetFPS()))
	xText(10 + x, 70 + y, "Blocks: " + Str(#blocksHor * #blocksVert))
	xText(10 + x, 85 + y, "Use <MOUSE> to rotate the board")
EndProcedure

Procedure.F CurveValue(newvalue.F, oldvalue.F, increments)
	If increments >  1 : oldvalue.F = oldvalue.F - (oldvalue.F - newvalue.F) / increments : EndIf
	If increments <= 1 : oldvalue.F = newvalue.F : EndIf
	ProcedureReturn oldvalue.F 
EndProcedure

LoadTextures("Media\Textures\abstract\a")
blockPiv = xCreatePivot()
initBlock = CreateInitialBlock()
CreateBlocks()
xPositionEntity(blockPiv, 0.0, 0.0, blockZPos)

While Not (xKeyHit(#KEY_ESCAPE) Or xWinMessage("WM_CLOSE"))
	
	UpdateControl()
	UpdateFrame()
	
	xRenderWorld()
	PrintInfo()
	DrawTexButtons()
	xFlip()
Wend

End

; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 1
; Folding = ----
; EnableXP
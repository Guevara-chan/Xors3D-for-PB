; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xGetJoy'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 600, 32, 0)

Dim buttonBuffer(25)
index = 0

While Not xKeyHit(1)
xCls()
button = xGetJoy()
If button<>0
	If index > 24 : index = 0 : EndIf
	buttonBuffer(index) = button
	index = index + 1
EndIf

For i = 0 To index-1
	If buttonBuffer(i)<>0 : xText(200, 60 + i*20, "You pressed joystick button # " + Str(buttonBuffer(i)), 1, 1) : EndIf
Next

xFlip()
Wend
End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyType'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

jType = xJoyType()

; Wait for user to hit ESC 
While Not (xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
Select jType
Case 0 
xText(200, 100, "Sorry, no joystick attached!" ,1,1)
Case 1 
xText(200, 100, "DIGITAL joystick is attached!" ,1,1)
Case 2 
xText(200, 100, "ANALOG joystick is attached!" ,1,1)
EndSelect 
xFlip()
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
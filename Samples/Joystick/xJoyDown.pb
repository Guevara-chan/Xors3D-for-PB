; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyDown'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; Until user presses ESC, show the states of joystick buttons
xgraphics3d(400, 400, 32, 0)

While Not (xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
xText(200, 60, "Push your buttons, gentlemen!",1,1)
xText(100, 90, "Joystick #1",1,1)
xText(300, 90, "Joystick #2",1,1)
For t = 1 To 16
button$="No"
If xJoyDown(t,0) : button$=Str(t)  : EndIf
xText(100, 135 + 15 * (t-1), button$ + " joystick button pressed!" , 1, 1)
Next 
For t = 1 To 16
button$="No"
If xJoyDown(t,1) : button$=Str(t) : EndIf
xText(300, 135 + 15 * (t-1), button$ + " joystick button pressed!" , 1, 1)
Next
xFlip()
Wend  
End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
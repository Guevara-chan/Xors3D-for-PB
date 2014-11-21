; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D joystick sample: 'xFlushJoy'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

current = ElapsedMilliseconds()

; wait 3 seconds
While ElapsedMilliseconds() < current + 3000
xCls()
xText(200, 85, "Press joystick buttons for " + Str(current + 2999 - ElapsedMilliseconds()) + " milliseconds...", 1, 1)
xFlip()
Wend

Delay(500)

xFlushJoy()

xText(200, 125, "Press any joystick button to exit", 1, 1)
xFlip()
xWaitJoy()

End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
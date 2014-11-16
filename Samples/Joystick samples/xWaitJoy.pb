; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xWaitJoy'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)


xText(200, 60, "Press any joystick button to continue.",1,1)
xFlip()

button=xWaitJoy()

xText(200, 100, "The joystick button code of the button you pressed was: " + Str(button),1,1)
xText(200, 130, "Now press any button to quit.",1,1)
xFlip()

xWaitJoy()

End

; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
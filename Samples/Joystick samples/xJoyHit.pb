; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyHit'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

; set up the timer
current=ElapsedMilliseconds()

; wait 4 seconds
While ElapsedMilliseconds() < current + 4000
xCls()
xText(200, 55, "Press button 1 a bunch of times for 4 seconds...", 1, 1)
xFlip()
Wend

hits = xJoyHit(1)

; wait for hitting ESC 
While Not (xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
xText(200, 90, "Buttons 1 is pressed  " + Str(hits) + " times.", 1 ,1)
xText(200, 120, "Press ESC to exit", 1, 1)
xFlip()
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
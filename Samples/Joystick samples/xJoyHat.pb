; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyHat'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

While Not(xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
xText(200, 100, "Joy Hat: " + Str(xJoyHat()), 1 ,1)
xFlip()
Wend
End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyX, xJoyY, xJoyZ, xJoyXDir, xJoyYDir, xJoyZDir'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

port = 0

While Not (xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
xText(60,80,"Joy X Value: " + Str(xJoyX(port)))
xText(60,105,"Joy Y Value: " + Str(xJoyY(port)))
xText(60,130,"Joy Z Value: " + Str(xJoyZ(port)))
xText(260,80,"Joy X Dir: " + Str(xJoyXDir(port)))
xText(260,105,"Joy Y Dir: " + Str(xJoyYDir(port)))
xText(260,130,"Joy Z Dir: " + Str(xJoyZDir(port)))
xFlip()
Wend  
End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
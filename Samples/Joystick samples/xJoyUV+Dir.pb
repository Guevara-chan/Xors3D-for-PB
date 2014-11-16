; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'xJoyU, xJoyV, xJoyUDir, xJoyVDir, xJoyYaw, xJoyPitch, xJoyRoll'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

xgraphics3d(400, 200, 32, 0)

While Not (xKeyHit(1) Or xWinMessage("WM_CLOSE"))
xCls()
xText(60,80,"Joy U Value: " + Str(xJoyU(port)))
xText(60,105,"Joy V Value: " + Str(xJoyV(port)))
xText(260,80,"Joy U Dir: " + Str(xJoyUDir(port)))
xText(260,105,"Joy V Dir: " + Str(xJoyVDir(port)))
xText(160,130,"Joy Yaw: " + Str(xJoyYaw()))
xText(160,150,"Joy Pitch: " + Str(xJoyPitch()))
xText(160,170,"Joy Roll: " + Str(xJoyRoll()))
xFlip()
Wend  
End
; IDE Options = PureBasic 5.30 (Windows - x86)
; EnableXP
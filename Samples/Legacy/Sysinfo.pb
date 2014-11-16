; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D legacy sample: 'Sysinfo'
; Original source from Xors3D Team (C)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

; set application window caption
xAppTitle("SYSInfo sample")

; initialize graphics mode
xGraphics3D(600, 500, 32, #False, #False)

; main progam loop
While Not xKeyHit(#KEY_ESCAPE)

	; clear screen
	xCls()
	
	; CPU information
	xText(45, 50,  "Name: "     + xCPUName())
	xText(45, 70,  "Speed: "    + Str(xCPUSpeed())    + " MHz")
	xText(45, 90,  "Vendor: "   + xCPUVendor())
	xText(45, 110, "Family: "   + Str(xCPUFamily()))
	xText(45, 130, "Model: "    + Str(xCPUModel()))
	xText(45, 150, "Stepping: " + Str(xCPUStepping()))
	
	; Memory information
	xText(45,  200, "Total Phys: " + StrF(xGetTotalPhysMem()/1024, 2)  + " MB")
	xText(45,  220, "Avail Phys: " + StrF(xGetAvailPhysMem()/1024, 2)  + " MB")
	xText(45,  240, "Total Page: " + StrF(xGetTotalPageMem()/1024, 2)  + " MB")
	xText(45,  260, "Avail Page: " + StrF(xGetAvailPageMem()/1024, 2)  + " MB")
	xText(245, 200, "Used Phys: " + StrF((xGetTotalPhysMem()/1024) - (xGetAvailPhysMem()/1024), 2)  + " MB")
	xText(245, 240, "Used Page: " + StrF((xGetTotalPageMem()/1024) - (xGetAvailPageMem()/1024), 2)  + " MB")
	
	; Video system infromation
	xText(45,  330, "Video Decription:                     " + xVideoInfo())
	xText(45,  350, "Total Vid: " + StrF(xGetTotalVidMem()/1024)  + " MB")
	xText(45,  370, "Avail Vid: " + StrF(xGetAvailVidMem()/1024)  + " MB")
	xText(45,  390, "Total Vid Local: " + StrF(xGetTotalVidLocalMem()/1024)  + " MB")
	xText(45,  410, "Avail Vid Local: " + StrF(xGetAvailVidLocalMem()/1024)  + " MB")
	xText(45,  430, "Total Vid Nonlocal: " + StrF(xGetTotalVidNonlocalMem()/1024)  + " MB")
	xText(45,  450, "Avail Vid Nonlocal: " + StrF(xGetAvailVidNonlocalMem()/1024)  + " MB")
	Temp.f = xGetAvailVidMem() / 1024
	xText(295, 360, "Used Vid : " + StrF((xGetTotalVidMem()/1024) - Temp, 2)  + " MB")
	Temp = xGetAvailVidLocalMem() / 1024
	xText(295, 400, "Used Vid  Local: " + StrF((xGetTotalVidLocalMem()/1024) - Temp, 2)+" MB")
	Temp = xGetAvailVidNonlocalMem() / 1024
	xText(295, 440,"Used Vid Nonlocal: " + StrF((xGetTotalVidNonlocalMem()/1024)-Temp, 2)+" MB")
	
	; switch back buffer
	xFlip()
Wend
; IDE Options = PureBasic 5.30 (Windows - x86)
' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include"../ramdisk/bas/RamDiskReadWriteApi.bas"

Load "TestScr.scr" Code $C000
RamDiskWrite($C000,$C000,6912)
RamDiskRead($4000,$C000,6912)
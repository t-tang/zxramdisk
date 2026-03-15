' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CHECK_MEMORY_BANKS__
#define __LIBRARY_RAMDISK_CHECK_MEMORY_BANKS__

Function RamDiskCheckMemoryBanks() as ubyte
    RamDiskBankSwitch(0)
    poke $C000,$ff
    RamDiskBankSwitch(5)
    poke $C000,$00
    RamDiskBankSwitch(0)
    dim hasMemoryBanks as ubyte = peek($c000) = $ff
    RamDiskBankSwitch(5)

    If Not hasMemoryBanks Then
        Print "Ram Disk requires 128K Spectrum"
        Stop
    End If
End Function
#endif
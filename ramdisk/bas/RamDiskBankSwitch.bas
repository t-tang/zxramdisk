' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_BANK_SWITCH__
#define __LIBRARY_RAMDISK_BANK_SWITCH__

Sub Fastcall RamDiskBankSwitch(logicalBank as ubyte)
Asm
    call RamDiskBankSwitch
End Asm
End Sub

#endif
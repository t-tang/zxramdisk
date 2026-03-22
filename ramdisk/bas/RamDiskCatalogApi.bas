' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

' ----------------------------------------------------------
' ZX Basic Public Disk Catalog Api
' ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_ZXBASIC_CATALOG_API__
#define __LIBRARY_RAMDISK_ZXBASIC_CATALOG_API__

Sub Fastcall RamDiskCatalogLoadCode()
Asm
    ret
    #include "../asm/readwrite/RamDiskBankSwitch.asm"
    #include "../asm/RamDiskCatalog.asm"
End Asm
End Sub

#include"RamDiskCheckMemoryBanks.bas"
RamDiskCatalogLoadCode()
RamDiskCheckMemoryBanks()

Function Fastcall RamDiskCatalogGetFilename(idx as uinteger) as string
Asm
    call RamDiskCatalogGetFilename
    ret
End Asm
End Function

Function Fastcall RamDiskCatalogGetFileSize(idx as uinteger) as uinteger
Asm
    ld a,RamDiskCatalogFileSizeOffset
    jp RamDiskCatalogGetWord
End Asm
End Function

Function Fastcall RamDiskCatalogGetSize() as uinteger
Asm
    jp RamDiskCatalogGetSize
End Asm
End Function

#endif
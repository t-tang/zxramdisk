' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

' ----------------------------------------------------------
' ZX Basic Ram Disk Public Disk Catalog Api
' ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_ZXBASIC_CATALOG_API__
#define __LIBRARY_RAMDISK_ZXBASIC_CATALOG_API__

Sub Fastcall RamDiskCatalogLoadCode()
Asm
    ret
    #include "../asm/readwrite/RamDiskBankSwitch.asm"
    #include "../asm/RamDiskCatalog.asm"
    #include "../asm/RamDiskReadWrite.asm"
End Asm
End Sub

#include"RamDiskCheckMemoryBanks.bas"
RamDiskCatalogLoadCode()
RamDiskCheckMemoryBanks()

#ifdef __LIBRARY_RAMDISK_ZXBASIC_READ_WRITE_API__
#include<print42.bas>
Cls
print42("You should choose either the"+chr(13))
print42("Read-Write Api OR the Catalog Api"+chr(13)+chr(13))
print42("Mixing the Apis can cause data corruption")
Stop
#endif

Const ERR_OK                  as ubyte = D_ERR_OK
Const ERR_OUT_OF_MEMORY       as ubyte = D_ERR_OUT_OF_MEMORY
Const ERR_INVALID_ARGUMENT    as ubyte = D_ERR_INVALID_ARGUMENT
Const ERR_INVALID_FILE_NAME   as ubyte = D_ERR_INVALID_FILE_NAME
Const ERR_FILE_ALREADY_EXISTS as ubyte = D_ERR_FILE_ALREADY_EXISTS
Const ERR_FILE_DOES_NOT_EXIST as ubyte = D_ERR_FILE_DOES_NOT_EXIST

Function Fastcall RamDiskFilename(idx as uinteger) as string
Asm
    call RamDiskCatalogGetFilename
    ret
End Asm
End Function

Function Fastcall RamDiskFileSize(idx as uinteger) as uinteger
Asm
    ld a,RamDiskCatalogFileSizeOffset
    jp RamDiskCatalogGetIndexWord
End Asm
End Function

Function Fastcall RamDiskIndexSize() as uinteger
Asm
    jp RamDiskCatalogGetIndexSize
End Asm
End Function

Function Fastcall RamDiskFreeBytes() as uinteger
Asm
    jp RamDiskCatalogGetFreeBytes
End Asm
End Function

Function Fastcall RamDiskSave(filename as string, sourceAddress as uinteger, length as uinteger) as ubyte
Asm
    pop af          ; ZX Basic return address
    pop de          ; main memory source address
    pop bc          ; number of bytes to transfer
    push af         ; restore return address
    
    jp RamDiskCatalogSaveFile

End Asm
End Function

Function Fastcall RamDiskLoad(filename as string, mainmemoryaddress as uinteger) as ubyte
Asm
Proc
    pop af
    pop de      ; de = main memory address
    push af

    jp RamDiskCatalogLoadFile
EndP
End Asm
End Function

Sub Fastcall RamDiskClear()
Asm
    jp RamDiskCatalogClear
End Asm
End Sub

#endif
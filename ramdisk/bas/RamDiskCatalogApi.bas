' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_WRITE_CATALOG_API__
#define __LIBRARY_RAMDISK_WRITE_CATALOG_API__

Sub Fastcall RamDiskCatalogLoadCode()
Asm
    ret
    #include "../asm/readwrite/RamDiskBankSwitch.asm"
    #include "../asm/RamDiskCatalogApi.asm"
End Asm
End Sub

#include"RamDiskCheckMemoryBanks.bas"
RamDiskCatalogLoadCode()
'RamDiskCheckMemoryBanks() TODO: FIXME

Sub Fastcall RamDiskCatalogWriteEntry(filename as string, fileptr as uinteger, filelen as uinteger)
Asm
                ; hl = filename
    pop af      ; return address to ZX Basic
    pop de      ; de = fileptr
    pop bc      ; bc = length
    push af     ; restore return address

    ;ld a,$04    ; logical bank 4 (phys 7)
    ;call RamDiskBankSwitch

    ex de,hl    ; hl = fileptr, de = filename
    call RamDiskCatalogWriteEntry

    ;ld a,$05
    ;call RamDiskBankSwitch

End Asm
End Sub

Function Fastcall RamDiskCatalogGetEntry(idx as uinteger) as uinteger
Asm
    jp RamDiskCatalogGetEntry  ; hl = filename address in catalog
End Asm
End Function

Function Fastcall RamDiskCatalogGetFilename(idx as uinteger) as string
Asm
    call RamDiskCatalogGetFilename
    ret
End Asm
End Function

Function Fastcall RamDiskCatalogGetWord(idx as uinteger, offset as ubyte) as uinteger
Asm
    pop bc
    pop af                      ; a = offset
    push bc

    jp RamDiskCatalogGetWord
End Asm
End Function

Function RamDiskCatalogGetFileSize(idx as uinteger) as uinteger
    return RamDiskCatalogGetWord(idx,$0e)
End Function

Function RamDiskCatalogGetFilePtr(idx as uinteger) as uinteger
    return RamDiskCatalogGetWord(idx,$0c)
End Function

#endif
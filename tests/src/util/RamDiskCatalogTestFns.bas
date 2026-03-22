' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

'--------------------------------------------------------------
' ZX Basic wrappers for the various low level assembly routines
'--------------------------------------------------------------

#include"../../../ramdisk/bas/RamDiskCatalogApi.bas"

Function Fastcall RamDiskCatalogFreeRamDiskAddress() as uinteger
Asm
    ld hl,(RamDiskCatalogFreeRamDiskAddress)
End Asm
End Function

Function Fastcall RamDiskCatalogGetIndexPtr(filename as string) as uinteger
Asm
    jp RamDiskCatalogGetIndexPtr
End Asm
End Function

Sub Fastcall RamDiskCatalogWriteIndexEntry(filename as string, fileptr as uinteger, filelen as uinteger)
Asm
                ; hl = filename
    pop af      ; return address to ZX Basic
    pop de      ; de = fileptr
    pop bc      ; bc = length
    push af     ; restore return address

    ;ld a,$04    ; logical bank 4 (phys 7)
    ;call RamDiskBankSwitch

    ex de,hl    ; hl = fileptr, de = filename
    call RamDiskCatalogWriteIndexEntry

    ;ld a,$05
    ;call RamDiskBankSwitch

End Asm
End Sub

Function Fastcall RamDiskCatalogGetIndexEntry(idx as uinteger) as uinteger
Asm
    jp RamDiskCatalogGetIndexEntry  ; hl = filename address in catalog
End Asm
End Function

Function Fastcall RamDiskCatalogGetRamDiskAddress(idx as uinteger) as uinteger
Asm
    ld a,RamDiskCatalogRamDiskOffset
    jp RamDiskCatalogGetIndexWord
End Asm
End Function

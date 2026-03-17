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
    ; hl = catalog index number
    jp RamDiskCatalogGetEntry  ; hl = filename address in catalog
End Asm
End Function

Function RamDiskCatalogGetFileName(idx as uinteger) as string
    Dim buffer as string = "0123456789" ' allocate buffer in ZX Basic
    RamDiskCatalogGetFileNameWithBuffer(idx, buffer)
    Return buffer
End Function

Sub Fastcall RamDiskCatalogGetFileNameWithBuffer(idx as uinteger, byref buffer as string)
Asm
                                ; hl = catalog entry number
    call RamDiskCatalogGetEntry ; hl = filename address in catalog

    pop af
    pop de      ; de = buffer 
    push af

    ex de,hl    ; hl = buffer ptr ptr, de = catalog entry address
    ld a,(hl)   ; derefence buffer ptr ptr
    inc hl
    ld h,(hl)
    ld l,a      ; hl = buffer ptr
    
    ex de,hl    ; de buffer ptr, hl = catalog entry address

    ld bc,$0C   ; max length of string + len
    ld($0001),a
    ldir

End Asm
End Sub

Function Fastcall RamDiskCatalogGet16(idx as uinteger, offset as ubyte) as uinteger
Asm
    pop bc
    pop af                      ; a = offset
    push bc

                                ; hl = catalog entry index
    ex af,af'                   ; save offset
    call RamDiskCatalogGetEntry ; hl = address of catalog entry
    ld a,l
    or h                        ; is the catalog empty?
    ret z                       ; catalog is empty

    xor a
    ld d,a
    ex af,af'       ; retrieve offset
    ld e,a
    add hl,de       ; address of uint16 data

    ld a,(hl)       ; grab lsb uint16
    inc hl
    ld h,(hl)       ; grab msb uint16
    ld l,a          ; hl = file size
End Asm
End Function

Function RamDiskCatalogGetFileSize(idx as uinteger) as uinteger
    return RamDiskCatalogGet16(idx,$0e)
End Function

Function RamDiskCatalogGetFilePtr(idx as uinteger) as uinteger
    return RamDiskCatalogGet16(idx,$0c)
End Function

#endif
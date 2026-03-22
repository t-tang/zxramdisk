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

Function Fastcall RamDiskCatalogGetFilename(idx as uinteger) as string
Asm
    call RamDiskCatalogGetFilename
    ret
End Asm
End Function

Function Fastcall RamDiskCatalogGetFileSize(idx as uinteger) as uinteger
Asm
    ld a,RamDiskCatalogFileSizeOffset
    jp RamDiskCatalogGetIndexWord
End Asm
End Function

Function Fastcall RamDiskCatalogGetIndexSize() as uinteger
Asm
    jp RamDiskCatalogGetIndexSize
End Asm
End Function

Function Fastcall RamDiskCatalogGetFreeBytes() as uinteger
Asm
    ld de,(RamDiskCatalogFreeRamDiskAddress)
    ld hl,$FFFF
    xor a       ; clear carry flag
    sbc hl,de
End Asm
End Function

Function Fastcall RamDiskCatalogGetIndexEntryPtr(filename as string) as uinteger
Asm
Proc
RamDiskCatalogGetIndexEntryPtr:
    push hl         ; save filename
    call RamDiskCatalogGetIndexSize ; hl = number of catalog entries
    ld a,h
    or l
    jr z,emptyindex ; empty catalog

    ld b,h
    ld c,l          ; bc = index size
    ld hl,(RamDiskFreeCatalogEntryPtr)
    ld de,RamDiskCatalogEntrySize
    add hl,de       ; last index entry
    pop de          ; de = filename

nextindexentry:
local nextindexentry:
    push de
    push hl
    call stringequals
    jr z,foundindexentry

    pop hl      ; hl = index entry ptr
    ld de,RamDiskCatalogEntrySize
    jr z,foundindexentry
    add hl,de   ; next index entry
    pop de      ; retrieve filename

    dec c
    jr nz,nextindexentry

    dec b
    jr nz,nextindexentry
    jr notfound

emptyindex:
local emptyindex:
    pop af      ; drop filename
notfound:
local notfound:
    xor a
    ld h,a
    ld l,a
    ret

foundindexentry:
local foundindexentry:
    pop hl      ; hl = index entry ptr
    pop de      ; drop filename
    ret

stringequals:
local stringequals:
    ld a,(de)   ; lsb str len
    cp (hl)
    ret nz      ; str not equals

    inc hl      ; msb str len
    inc de
    inc hl      ; skip msb str len
    inc de

nextchar:
local nextchar:
    ex af,af'   ; a' = str len
    ld a,(de)   ; a = str char
    cp (hl)
    ret nz      ; str not equals
    ex af,af'   ; a = str len
    dec a
    ret z
    jr nextchar
EndP
End Asm
End Function

Sub Fastcall RamDiskCatalogWriteFile(filename as string, mainmemoryAddress as uinteger, bytesLen as uinteger)
Asm
                    ; hl = filename
    pop af          ; return address to ZX Basic
    pop de          ; de = main memory address
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    push hl         ; save file name
    push bc         ; save bytes length

    ld hl,(RamDiskCatalogFreeRamDiskAddress)
    ex de,hl        ; hl = main memory address, de = ram disk address
    xor a           ; a = 0, write to ramdisk
    call RamDiskTransferMemory

    pop bc          ; retrieve bytes length
    pop de          ; retrieve file name
    ld hl,(RamDiskCatalogFreeRamDiskAddress)
    call RamDiskCatalogWriteIndexEntry

    ld hl,(RamDiskCatalogFreeRamDiskAddress)
    add hl,bc
    ld(RamDiskCatalogFreeRamDiskAddress),hl     ; update free ram disk address

End Asm
End Sub

Const ERR_OK as ubyte = 00
Const ERR_OUT_OF_MEMORY     as ubyte = 04
Const ERR_INVALID_ARGUMENT  as ubyte = 10
Const ERR_INVALID_FILE_NAME as ubyte = 15

Function RamDiskSave(filename as string, sourceAddress as uinteger, length as uinteger) as ubyte
    If length = 0 Then Return ERR_INVALID_ARGUMENT
    If Not Len(filename) Then Return ERR_INVALID_FILE_NAME
    If RamDiskCatalogGetIndexSize() = 5 Then Return ERR_OUT_OF_MEMORY
    If RamDiskCatalogGetFreeBytes() < length Then Return ERR_OUT_OF_MEMORY

    RamDiskCatalogWriteFile(filename, sourceAddress,length)
    return ERR_OK
End Function

Function Fastcall RamDiskLoad(filename as string, mainmemoryaddress as uinteger) as ubyte
Asm
Proc
    pop af
    pop de      ; de = main memory address
    push af

    push de     ; save main memory address

    call RamDiskCatalogGetIndexEntryPtr ; hl = index entry ptr
    ld a,h
    or l
    jr nz, loadfile

    pop af      ; drop main memory address
    ld a,$0F     ; ERR_INVALID_FILE_NAME
    ret
    
loadfile:
local loadfile:
    ld de,RamDiskCatalogRamDiskOffset
    add hl,de   ; hl = ram disk address

    ld e,(hl)   ; lsb ram disk address
    inc hl
    ld d,(hl)   ; de = ram disk address

    inc hl      ; hl = file size
    ld c,(hl)   ; lsb file size
    
    inc hl
    ld b,(hl)   ; msb file size

    pop hl      ; hl = main memory address
    
    ld a,$01    ; $01 = transfer from ram disk to main memory
    jp RamDiskTransferMemory
EndP
End Asm
End Function

#endif
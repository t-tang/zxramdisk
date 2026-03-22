; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in : hl = filename
; in : de = main memory source address
; bc : length
; ----------------------------------------------------------
Proc
RamDiskCatalogSaveFile:

checkfreebytes:
local checkfreebytes:
    push bc
    exx         ; save de = main memory address, hl = filename, bc = length
    pop bc
    call RamDiskCatalogGetFreeBytes ; hl = free bytes
    or a        ; clear carry flag
    sbc hl,bc   
    jr nc,checkcatalogsize
    
    ld a,D_ERR_OUT_OF_MEMORY
    ret

checkcatalogsize:
local checkcatalogsize:
    call RamDiskCatalogGetIndexSize  ; hl = number of catalog entries
    ld de,RamDiskCatalogMaxIndexEntries
    or a        ; clear carry flag
    sbc hl,de
    jr c,checkfileexists

    ld a,D_ERR_OUT_OF_MEMORY
    ret

checkfileexists:
local checkfileexists:
    exx
    push hl
    exx
    pop hl
    call RamDiskCatalogGetIndexPtr
    ld a,h
    or l
    jr z,checkfilelen

    ld a,D_ERR_FILE_ALREADY_EXISTS
    ret

checkfilelen:
local checkfilelen:
    exx

    ld a,(hl)
    or a
    jr nz,checkbyteslen

    ld a,D_ERR_INVALID_FILE_NAME
    ret

checkbyteslen:
local checkbyteslen:
    ld a,b
    or c
    jr nz,ramdiskcatalogwritefile

    ld a,D_ERR_INVALID_ARGUMENT
    ret

; ----------------------------------------------------------
; in : hl = filename
; in : de = main memory address
; in : bc = file length
; ----------------------------------------------------------
ramdiskcatalogwritefile:
local ramdiskcatalogwritefile:
    push hl         ; save filename
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
    xor a
    ld(hl),a    ; mark as unused

    ld a,D_ERR_OK
    ret
EndP
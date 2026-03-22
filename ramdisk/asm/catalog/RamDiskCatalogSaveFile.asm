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
    ld a,b
    xor c
    jr nz, checkfilelen

    ld a,D_ERR_INVALID_ARGUMENT
    ret

checkfilelen:
local checkfilelen:
    ld a,(hl)
    or a
    jr nz,checkfreebytes

    ld a,D_ERR_INVALID_FILE_NAME
    ret

checkfreebytes:
local checkfreebytes:
    push hl     ; save filename
    push de     ; save main memory source address

    call RamDiskCatalogGetFreeBytes ; hl = free bytes
    ld a,h
    or l
    jr nz,checkcatalogsize
    
    pop af      ; discard main memory source address
    pop af      ; discard filename
    ld a,D_ERR_OUT_OF_MEMORY
    ret

checkcatalogsize:
local checkcatalogsize:
    ; TODO: FIXME

; ----------------------------------------------------------
; in : hl = filename
; in : de = main memory address
; in : bc = file length
; ----------------------------------------------------------
ramdiskcatalogwritefile:
local ramdiskcatalogwritefile:
    pop de          ; main memory source address

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

    ld a,D_ERR_OK
    ret
EndP
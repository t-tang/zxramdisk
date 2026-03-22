; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

;-------------------------------------------------------
; in  : hl = fileptr, de = filename, bc = length
; keep: bc
; pre : Logical bank $05 (physical $07) is active
;-------------------------------------------------------
#include"RamDiskCatalogGlobalVars.asm"

#ifndef __LIBRARY_RAMDISK_CATALOG_WRITE_ENTRY_ASM__
#define __LIBRARY_RAMDISK_CATALOG_WRITE_ENTRY_ASM__

RamDiskCatalogWriteIndexEntry

PROC
    ; assert BANK_M has bank 4 (phys  7) paged in 
    push bc                     ; save the length
    push hl                     ; save the fileptr

    ld hl,(RamDiskFreeCatalogEntryPtr)

    ld a,(de)                   ; lsb file name len
    cp $0a                      ; len < 10?
    jr c,copynamelen            ; use filename as is
    ld a,$0a                    ; truncate filename

copynamelen:
local copynamelen:
    ld (hl),a                   ; copy lsb file name len
    inc hl                      ; next catalog entry byte
    inc de                      ; move to msb filename len

    xor a 
    ld (hl),a                   ; copy msb file name len
    inc hl                      ; next catalog entry byte
    inc de                      ; move to filename chars

    ld b,$0a
copychars:
local copychars:
    ld a,(de)                   ; copy filename (possibly truncated)
    ld (hl),a
    inc hl
    inc de
    djnz copychars

copyfileptr:
local copyfileptr:

    pop de                      ; retrieve file ptr
    ld (hl),e                   ; lsb file ptr
    inc hl
    ld (hl),d                   ; msb file ptr
    inc hl

; copy in the length
    pop bc                      ; retrieve the length
    ld (hl),c                   ; copy lsb length
    inc hl

    ld (hl),b                   ; copy msb length

; advance the free ptr
    ld hl,(RamDiskFreeCatalogEntryPtr)
    ld de,RamDiskCatalogEntrySize
    or a
    sbc hl,de
    ld (RamDiskFreeCatalogEntryPtr),hl

    ret
ENDP
#endif
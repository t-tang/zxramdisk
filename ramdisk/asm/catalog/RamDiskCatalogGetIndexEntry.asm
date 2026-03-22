; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in : hl = entry index
; out: hl = entry address or 0 if the entry does not exist
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATEGORY_GET_ENTRY_ASM__
#define __LIBRARY_RAMDISK_CATEGORY_GET_ENTRY_ASM__

#include"RamDiskCatalogGlobalVars.asm"

Proc
RamDiskCatalogGetIndexEntry:

    ld de,RamDiskCatalogFirstEntry
    ld a,(de)
    or a
    jr z,notfound   ; empty catalog

    add hl,hl       ; mult2
    add hl,hl       ; mult4
    add hl,hl       ; mult8
    add hl,hl       ; mult16

    ex de,hl
    or a            ; clear carry flag
    sbc hl,de       ; hl = address of catalog entry

    ex de,hl        ; de = address of catalog entry
    ld hl,(RamDiskFreeCatalogEntryPtr)
    sbc hl,de       ; RamDiskFreeCatalogPtr - index argument catalog ptr
    jr nc,notfound  ; failed bounds check
    ex de,hl        ; hl = index argument catalog ptr
    ret

notfound:
local notfound:
    xor a
    ld h,a
    ld l,a
    ret
EndP
#endif
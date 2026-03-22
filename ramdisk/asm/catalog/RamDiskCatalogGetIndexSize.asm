; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; out : hl = number of occupied catalog entries
; keep: a,bc
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATALOG_GET_SIZE_ASM__
#define __LIBRARY_RAMDISK_CATALOG_GET_SIZE_ASM__

#include"RamDiskCatalogGlobalVars.asm"

RamDiskCatalogGetIndexSize:
    ld de,(RamDiskFreeCatalogEntryPtr)
    ld hl,RamDiskCatalogStartAddr
    or a        ; clear carry flag
    sbc hl,de   ; normalise free catalog entry address

    srl h       ; 
    rr l        ; div2
    srl h       ; 
    rr l        ; div4
    srl h       ; 
    rr l        ; div8
    srl h       ; 
    rr l        ; div16

    dec hl
    ret
#endif
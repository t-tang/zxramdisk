; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in : hl = entry index
; in : a  = offset into catalog entry structure
; out: hl = 16bit word value in entry + offset
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATEGORY_GET_WORD_ASM__
#define __LIBRARY_RAMDISK_CATEGORY_GET_WORD_ASM__
#include"RamDiskCatalogGetIndexEntry.asm"
RamDiskCatalogGetIndexWord:

                                ; hl = catalog entry index
    ex af,af'                   ; save offset
    call RamDiskCatalogGetIndexEntry ; hl = address of catalog entry
    ld a,l
    or h                        ; is the index argument out of bounds?
    ret z                       ; index argument is out of bounds

    xor a
    ld d,a
    ex af,af'       ; retrieve offset
    ld e,a
    add hl,de       ; hl = address of uint16 data

    ld a,(hl)       ; grab lsb uint16
    inc hl
    ld h,(hl)       ; grab msb uint16
    ld l,a          ; hl = file size
    ret
#endif
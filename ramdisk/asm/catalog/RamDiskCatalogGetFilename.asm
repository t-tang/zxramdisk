; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in : hl = entry index
; out: hl = filename (ZX Basic string allocated on heap)
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATEGORY_GET_FILENAME_ASM__
#define __LIBRARY_RAMDISK_CATEGORY_GET_FILENAME_ASM__

#include<mem/alloc.asm>
#include"RamDiskCatalogGetIndexEntry.asm"

RamDiskCatalogGetFilename:
    push hl                 ; save index argument
    ld bc,$0c               ; filename is max 12 bytes
    push namespace core
    call __MEM_ALLOC        ; hl = heap ptr
    pop namespace
    ld a,h
    or l
    ret z                   ; check heap exhausted

    pop de                  ; de = catalog entry index
    push hl                 ; save heap ptr for return
    ex de,hl                ; hl = catalog entry index
    call RamDiskCatalogGetIndexEntry ; hl = filename address in catalog
    pop de                  ; de = heap ptr
    ld a,h
    or l                    ; index out of bounds
    ret z

    push de                 ; save heap ptr
    ld bc,$0c               ; filename is max 12 bytes
    ldir
    pop hl                  ; string ptr
    ret

#endif
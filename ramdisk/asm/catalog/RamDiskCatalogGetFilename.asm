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

#include"RamDiskCatalogGetEntry.asm"
RamDiskCatalogGetFilename:
    push hl                 ; save index argument
    ld bc,$0c               ; filename is max 12 bytes
    push namespace core
    call __MEM_ALLOC        ; hl = heap ptr
    pop namespace
                            ; TODO: check heap exhausted
    pop de                  ; de = catalog entry index
    push hl                 ; save heap ptr for return
    push hl                 ; save heap ptr
    ex de,hl                ; hl = catalog entry index
    call RamDiskCatalogGetEntry ; hl = filename address in catalog
    pop de                  ; de = heap ptr
    ld bc,$0c               ; filename is max 12 bytes
    ldir
    pop hl                  ; string ptr
    ret

#endif
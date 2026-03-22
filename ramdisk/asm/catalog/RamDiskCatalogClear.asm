; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

Proc
RamDiskCatalogClear:
    ld hl,RamDiskCatalogFirstEntry
    ld (RamDiskFreeCatalogEntryPtr),hl
    xor a
    ld h,a
    ld l,a
    ld (RamDiskCatalogFreeRamDiskAddress),hl
    ret
EndP
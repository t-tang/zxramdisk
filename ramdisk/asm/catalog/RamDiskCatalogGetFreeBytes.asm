; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; keep : bc
; ----------------------------------------------------------
RamDiskCatalogGetFreeBytes:
    ld de,(RamDiskCatalogFreeRamDiskAddress)
    ld hl,$FFFF
    xor a       ; clear carry flag
    sbc hl,de
    ret
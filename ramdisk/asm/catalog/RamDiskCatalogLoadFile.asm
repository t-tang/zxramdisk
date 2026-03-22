; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in : hl = filename
; in : de = main memory dest address
; ----------------------------------------------------------

Proc
RamDiskCatalogLoadFile:
    push de     ; save main memory address

    call RamDiskCatalogGetIndexPtr  ; hl = index entry ptr
    ld a,h
    or l
    jr nz, loadfile                 ; filename was not found

    pop af      ; drop main memory address
    ld a,D_ERR_FILE_DOES_NOT_EXIST
    ret
    
loadfile:
local loadfile:
    ld de,RamDiskCatalogRamDiskOffset
    add hl,de   ; hl = ram disk address

    ld e,(hl)   ; lsb ram disk address
    inc hl
    ld d,(hl)   ; de = ram disk address

    inc hl      ; hl = file size
    ld c,(hl)   ; lsb file size
    
    inc hl
    ld b,(hl)   ; msb file size

    pop hl      ; hl = main memory address
    
    ld a,$01    ; $01 = transfer from ram disk to main memory
    jp RamDiskTransferMemory
EndP
; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

;-------------------------------------------------------
; in  : de = filename, bc = length
; keep: bc
; pre : Logical bank $05 (physical $07) is active
;-------------------------------------------------------
RamDiskWriteCatalogEntry

PROC
    ; assert BANK_M has bank 4 (phys  7) paged in 
    local copyname, copychars

    ld hl,(RamDiskFreeCatalogEntryPtr)

    ld a,(de)                   ; lsb of filename string length
    cp $0a                      ; len < 10?
    jr c,copyname               ; use filename as is
    ld a,$0a                    ; truncate filename

    push bc                     ; save the length

copyname:
    inc de                      ; skip lsb strlen
    inc de                      ; skip msb strlen
    ld b,a 
    ld a,$0a
    sub b                       ; a = number of padding chars needed
    ex af,af'                   ; save the number of padding chars

copychars:
    ld a,(de)                   ; copy filename (possibly truncated)
    ld (hl),a
    inc hl
    inc de
    djnz copychars

    ex af,af'                   ; retrieve the number of padding chars
    or a                        ; is any padding needed?
    jr z,copylength             ; no padding needed
    ld b,a                      ; b = amount of padding
    ld a,$20                    ; use space for padding

padfilename:
    ld (hl),a                   ; pad filename
    inc hl
    djnz padfilename

copylength:
    pop bc                      ; retrieve the length
    ld a,c                      ; copy lsb length
    ld (hl),a
    inc de

    ld a,b                      ; copy msb length
    ld (hl),a

    ret

ENDP
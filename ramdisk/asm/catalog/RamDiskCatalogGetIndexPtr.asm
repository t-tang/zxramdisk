; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; in  : hl = filename
; out : hl = index entry address
; ----------------------------------------------------------

Proc
RamDiskCatalogGetIndexPtr:
    push hl         ; save filename
    call RamDiskCatalogGetIndexSize ; hl = number of catalog entries
    ld a,h
    or l
    jr z,emptyindex ; empty catalog

    ld b,h
    ld c,l          ; bc = index size
    ld hl,(RamDiskFreeCatalogEntryPtr)
    ld de,RamDiskCatalogEntrySize
    add hl,de       ; last index entry
    pop de          ; de = filename

nextindexentry:
local nextindexentry:
    push de
    push hl
    call stringequals
    jr z,foundindexentry

    pop hl      ; hl = index entry ptr
    ld de,RamDiskCatalogEntrySize
    jr z,foundindexentry
    add hl,de   ; next index entry
    pop de      ; retrieve filename

    dec c
    jr nz,nextindexentry

    dec b
    jr nz,nextindexentry
    jr notfound

emptyindex:
local emptyindex:
    pop af      ; drop filename
notfound:
local notfound:
    xor a
    ld h,a
    ld l,a
    ret

foundindexentry:
local foundindexentry:
    pop hl      ; hl = index entry ptr
    pop de      ; drop filename
    ret

stringequals:
local stringequals:
    ld a,(de)   ; lsb str len
    cp (hl)
    ret nz      ; str not equals

    inc hl      ; msb str len
    inc de
    inc hl      ; skip msb str len
    inc de

nextchar:
local nextchar:
    ex af,af'   ; a' = str len
    ld a,(de)   ; a = str char
    cp (hl)
    ret nz      ; str not equals
    ex af,af'   ; a = str len
    dec a
    ret z
    jr nextchar
EndP
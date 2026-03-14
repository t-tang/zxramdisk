;--------------------------------------------------------------------------------
; in : hl = ramdisk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes fit into bank indicated by ramdisk address
; splits a transfer such that individual transfers do not overlap a memory bank
;--------------------------------------------------------------------------------
RamDiskNextChunk:
PROC
    ld a,h          ; extract the starting bank number
    rlca
    rlca
    and %00000011

    ex af,af'       ;a' = save starting bank number
    push hl         ;save the ramdisk address
    add hl,bc
    dec hl          ;end ramdisk address for remaining bytes

    ld a,h          ;
    rlca            ;
    rlca            ;
    and %00000011   ;
    ld l,a          ;l = ending bank number for remaining bytes

    ex af,af'       ;recover starting bank number
    cp l            ;is the start and end bank the same?
    jr nz,spillsover

    pop hl          ; clean up the stack
    ld h,b
    ld l,c          ; all remaining bytes fit into this bank
    ret

spillsover:
local spillsover:
; calculate end address in this bank
    inc a       ; next bank
    rrca
    rrca        ; a = msb of next bank
    ld h,a
    ld l,$00
    dec hl      ; end address of current bank
    pop de      ; de = start address in ram disk
    or a        ; clear carry flag

    sbc hl,de   ; hl = number of bytes living in this bank
    inc hl      ; number of bytes spilled over from this bank
    ret
ENDP
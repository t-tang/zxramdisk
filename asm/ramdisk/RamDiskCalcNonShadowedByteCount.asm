;--------------------------------------------------
; in  : hl = source address
; in  : bc = remaining bytes to be copied
; out : hl = number of source bytes below $c000
; keep: no registers are preserved
;--------------------------------------------------
RamDiskCalcNonShadowedByteCount
PROC
    push hl         ; save the source address
    add hl,bc       ; find the end of the source data
    dec hl

    ld a,$c0
    cp h            ; does the source range extend into $c000?
    jr c, partial
    jr z, partial

    pop hl          ; clean up stack
    ld h,b
    ld l,c          ; there is no overlap into $c000
    ret

partial:
local partial:
; the source range extends into $c000, copy the range below $c000
    pop de          ; de = source address
    ld hl,$c000
    or a            ; clear carry flag
    sbc hl,de       ; return number of bytes below $c000
    ret
ENDP
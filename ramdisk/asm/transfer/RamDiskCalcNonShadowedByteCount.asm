; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CALC_NON_SHADOWED_BYTE_COUNT_ASM__
#define __LIBRARY_RAMDISK_CALC_NON_SHADOWED_BYTE_COUNT_ASM__

;--------------------------------------------------
; in  : hl = source address
; in  : bc = remaining bytes to be copied
; out : hl = number of source bytes below $c000
; keep: no registers are preserved
;--------------------------------------------------
RamDiskCalcNonShadowedByteCount
PROC

    ld a,$c0
    cp h            ; check starting source address is below $c000
    jr c,allabovec0
    jr z,allabovec0

    push hl

    add hl,bc
    dec hl          ; hl = end source address

    ld a,h
    cp $c0            ; check end source address is below $c000
    jr c,allbelowc0

; start address < $c000 and end address >= $c000
; calculate how many bytes below $c000
    pop hl          ; hl = source address
    ex de,hl        ; de = start address
    or a            ; clear carry flag
    ld hl,$c000
    sbc hl,de

    ret

allbelowc0:
local allbelowc0:
    pop hl          ; clean up stack
    ld h,b          ; all source bytes are below $c0000
    ld l,c          ; copy all bytes
    ret

allabovec0:
local allabovec0:
    xor a
    ld h,0          ; all bytes are above $c000
    ld l,0          ; don't copy any bytes
    ret

partial:
local partial:
; the source range extends into $c000, copy the range below $c000
ENDP
#endif
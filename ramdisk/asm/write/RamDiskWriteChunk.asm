;--------------------------------------------------
; in  : hl = source address
; in  : de = ram disk address
; in  : bc = remaining bytes to be transferred
; keep: no registers preserved
; copies data from source address into a bank
;--------------------------------------------------
RamDiskWriteChunk:
PROC
    call initchunkvars
    call RamDiskWriteNonShadowedBytes   ; write all source bytes below $c000 efficiently
    call updatechunkvars

nextwrite:
local nextwrite:
    ld a,b
    or c
    jr z,endproc                        ; no more remaining bytes

    call RamDiskWriteShadowedBytes      ; source bytes above $c000 are transferred using a buffer
    call updatechunkvars
    jr nextwrite

endproc:
local endproc:
    ld hl,(chunkbytestransferred)
    ret
ENDP

;---------------------------------------------
; in  : hl = source address
; in  : de = ram disk address
; in  : bc = remaining byte count to be copie
; keep: bc,de,hl preserved
;---------------------------------------------
PROC
initchunkvars:
    push hl         ; save hl for caller convenience
    ld (chunksourceaddress),hl

    ex de,hl
    ld (chunkramDiskAddress),hl
    ex de,hl

    ld h,b
    ld l,c
    ld (chunkbytesremaining),hl

    ld hl,$0000
    ld (chunkbytestransferred),hl

    pop hl          ; restore hl for caller
    ret

;---------------------------------------------
; in  : hl = bytes copied
; out : hl = updated source address
; out : de = updated ram disk address
; out : bc = updated remaining byte count
;---------------------------------------------
updatechunkvars:

    ld b,h
    ld c,l          ; bc = number of bytes copied

    ld hl,(chunksourceaddress)  ; update source address with bytes copied
    add hl,bc                   ; source address  += bytes copied
    ld (chunksourceaddress),hl  ; save updated source address

    ld hl,(chunkramDiskAddress) ; update ram disk address with bytes copied
    add hl,bc                   ; ram disk address += bytes copied
    ld (chunkramDiskAddress),hl ; save updated ram disk address
    ex de,hl                    ; de = ram disk address

    ld hl,(chunkbytestransferred) ; update bytes transferred with bytes copied
    add hl,bc                     ; bytes transferred += bytes copied
    ld (chunkbytestransferred),hl ; save bytes transferred

    ld hl,(chunkbytesremaining) ; update bytes remaining with bytes copied
    or a                        ; clear carry flag
    sbc hl,bc                   ; bytes remaining -= bytes remaining
    ld (chunkbytesremaining),hl ; save bytes remaining
    ld b,h                      ; msb bytes remaining
    ld c,l                      ; bc = remaining bytes

    ld hl,(chunksourceaddress)  ; hl = source address

    ret

;storage area used to track variables during transfer
;shared by WriteChunk and ReadChunk
chunksourceaddress:
local chunksourceaddress:
    dw $0000

chunkramDiskAddress:
local chunkramDiskAddress:
    dw $0000

chunkbytesremaining:
local chunkbytesremaining:
    dw $0000

chunkbytestransferred:
    dw $0000
ENDP
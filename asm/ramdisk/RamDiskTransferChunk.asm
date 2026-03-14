;--------------------------------------------------
; in  : hl = source address
; in  : de = ram disk address
; in  : bc = remaining bytes to be transferred
; keep: no registers preserved
; copies data from source address into a bank
;--------------------------------------------------
RamDiskTransferChunk:
PROC
    call savevars
    call RamDiskWriteNonShadowedBytes   ; write all source bytes below $c000 efficiently
    call updatevars

nextwrite:
local nextwrite:
    ld a,b
    or c
    jr z,endproc                        ; no more remaining bytes

    call RamDiskWriteShadowedBytes      ; source bytes above $c000 are transferred using a buffer
    call updatevars
    jr nextwrite

endproc:
local endproc:
    ld hl,(bytestransferred)
    ret

;---------------------------------------------
; in  : hl = source address
; in  : de = ram disk address
; in  : bc = remaining byte count to be copie
; keep: bc,de,hl preserved
;---------------------------------------------
savevars:
local savevars:
    push hl         ; save hl for caller convenience
    ld (sourceaddress),hl

    ex de,hl
    ld (ramDiskAddress),hl
    ex de,hl

    ld h,b
    ld l,c
    ld (bytesremaining),hl

    ld hl,$0000
    ld (bytestransferred),hl

    pop hl          ; restore hl for caller
    ret

;---------------------------------------------
; in  : hl = bytes copied
; out : hl = updated source address
; out : de = updated ram disk address
; out : bc = updated remaining byte count
;---------------------------------------------
updatevars:
local updatevars:

    ld b,h
    ld c,l          ; bc = bytes copied

    ld hl,(sourceaddress)
    add hl,bc
    ld (sourceaddress),hl

    push hl                     ; save source address

    ld hl,(ramDiskAddress)
    add hl,bc
    ld (ramDiskAddress),hl
    ex de,hl                    ; de = ram disk address

    ld hl,(bytestransferred)
    add hl,bc
    ld (bytestransferred),hl

    ld hl,(bytesremaining)
    or a
    sbc hl,bc
    ld (bytesremaining),hl
    ld b,h
    ld c,l                      ; bc = remaining bytes

    pop hl                      ; retrieve source address

    ret

sourceaddress:
local sourceaddress:
    dw $0000

ramDiskAddress:
local ramDiskAddress:
    dw $0000

bytesremaining:
local bytesremaining:
    dw $0000

bytestransferred:
local bytestransferred:
    dw $0000
ENDP
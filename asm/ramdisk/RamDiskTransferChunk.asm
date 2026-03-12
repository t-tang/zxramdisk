;--------------------------------------------------
; in : hl = source address
; in : de = ram disk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes were copied into the ram disk
; copies data from source address into a bank
;--------------------------------------------------
RamDiskTransferChunk:
PROC
    ld (sourceaddress),hl

    ex de,hl
    ld (ramDiskAddress),hl

    ld h,b
    ld l,c
    ld (bytesremaining),hl

    call RamDiskCalcNonShadowedByteCount   ; write all source bytes below $c000 efficiently
    call updatevars

nextwrite:
local nextwrite:
    ld a,b
    or c
    ret z          ; no more remaining bytes

    call RamDiskWriteShadowedBytes      ; source bytes above $c000 are transferred using a buffer
    call updatevars
    jr nextwrite

;---------------------------------------------
; in  : hl = bytes copied
; out : hl = updated source address
; out : de = updated ram disk address
; out : bc = updated remaining bytes
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

    ld hl,(bytesremaining)
    or a
    sbc hl,bc
    ld (bytesremaining),hl
    ld b,h
    ld c,l                      ; bc = remaining bytes

    pop hl                      ; hl = source address
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
ENDP
;--------------------------------------------------
; in : hl = source address
; in : de = ram disk address
; in : bc = remaining bytes to be transferred
; transfer data between main memory and the ram disk
;--------------------------------------------------
RamDiskTransfer:
; save registers to variables area
    ld (sourceaddress),hl   ; save source address

    ex de,hl
    ld (ramDiskAddress),hl  ; save ram disk adress

    ld h,b
    ld l,c
    ld (bytesremaining),hl  ; save remaining byte count

    ld hl,(sourceaddress)

nextChunk:
local nextChunk:
    call RamDiskNextChunk       ; chunk writes to fit nicely into memory banks
    ld b,h
    ld c,l                      ; bc = byte count to transfer

    ld hl,(ramDiskAddress)      
    ex de,hl                    ; de = ram disk address
    ld hl,(sourceaddress)       ; hl = source address
    call RamDiskWriteChunk      ; transfer bytes, bc = bytes transferred
    call updatevars

    ld a,b
    or c
    jr nz, nextChunk

    ret

;--------------------------------------------------
; in  : hl = bytes copied
; out : hl = updated source address
; out : de = updated ram disk address
; out : bc = updated remaining bytes
; update variables with number of bytes transferred
;--------------------------------------------------
updatevars:
local updatevars:

    ld b,h
    ld c,l          ; bc = bytes copied

    ld hl,(sourceaddress)
    add hl,bc                   ; source += bytes copied
    ld (sourceaddress),hl

    ld hl,(ramDiskAddress)
    add hl,bc                   ; ram disk address += bytes copied
    ld (ramDiskAddress),hl
    ex de,hl                    ; de = ram disk address

    ld hl,(bytesremaining)
    or a
    sbc hl,bc                   ; bytes remaining -= bytes copied
    ld (bytesremaining),hl
    ld b,h
    ld c,l                      ; bc = remaining bytes

    ld hl,(sourceaddress)
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

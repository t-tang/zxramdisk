;--------------------------------------------------
; in : hl = source address
; in : de = ram disk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes were copied into the ram disk
; transfer data between main memory and the ram disk
;--------------------------------------------------
RamDiskTransfer:
; save registers to variables area
    push hl
    ld (sourceaddress),hl   ; save source address

    ex de,hl
    ld (ramDiskAddress),hl  ; save ram disk adress

    ld h,b
    ld l,c
    ld (bytesremaining),hl  ; save remaining byte count
    pop hl

nextChunk:
local nextChunk:
    call RamDiskNextChunk       ; chunk writes to fit nicely into memory banks
    ld b,h
    ld c,l                      ; bc = byte count to transfer

    ld hl,(ramDiskAddress)      
    ex de,hl                    ; de = ram disk address
    ld hl,(sourceaddress)       ; hl = source address
    call RamDiskTransferChunk   ; transfer bytes, bc = bytes transferred
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

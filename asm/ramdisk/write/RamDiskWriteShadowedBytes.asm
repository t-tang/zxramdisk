#include"../RamDiskBankSwitchToAddress.asm"
#include"../RamDiskRebaseAddress.asm"

;--------------------------------------------------
; in : hl = ramdisk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes were copied into the ram disk
; copies data from above $c000 into ram disk
;--------------------------------------------------
PROC
    BUFFER_SIZE equ $20
    local BUFFER_SIZE

RamDiskWriteShadowedBytes:
    push hl             ; save source address
    ld hl,BUFFER_SIZE   ;
    or a                ; clear carry flag
    sbc hl,bc           ; is remaining bytes < buffer size?
    jr nc, transferbuffer

transferwholebuffer:
local transferwholebuffer:
    ld bc,BUFFER_SIZE

transferbuffer:
local transferbuffer:

    pop hl              ; recover source address
    push bc             ; save byte count for return
    push bc             ; save byte count for transfer to ram disk
    push de             ; save ram disk address
    ld de,buffer        ; de = buffer
    ldir                ; transfer bytes from main memory to buffer

    pop de                          ; recover ram disk address
    pop bc                          ; recover byte count
    call RamDiskBankSwitchToAddress ; switch ramdisk bank into upper memory
    call RamDiskRebaseAddress       ; rebase ram disk address into upper memory 
    ld hl,buffer
    ldir                            ; transfer bytes from main memory to buffer

    ld a,5
    call RamDiskBankSwitch  ; restore memory bank layout

    pop hl                  ; return byte count

    ret

buffer:
local buffer:
    ds BUFFER_SIZE,0
ENDP
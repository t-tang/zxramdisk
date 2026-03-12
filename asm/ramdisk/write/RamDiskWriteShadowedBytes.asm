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

    ld l,c
    ld h,b

    ret

buffer:
local buffer:
    ds BUFFER_SIZE,0
ENDP
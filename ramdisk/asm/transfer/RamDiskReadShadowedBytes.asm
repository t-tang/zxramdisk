
;--------------------------------------------------
; in : hl = destination address in main memory
; in : de = ram disk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes were copied into the ram disk
; copies data from above $c000 into ram disk
;--------------------------------------------------
PROC

RamDiskReadShadowedBytes:
    push hl             ; save main memory address
    ld hl,__RAMDISK_BUFFER_SIZE__   ;
    or a                ; clear carry flag
    sbc hl,bc           ; is remaining bytes < buffer size?
    pop hl              ; restore main memory address
    jr nc, transferbuffer

transferwholebuffer:
local transferwholebuffer:
    ld bc,__RAMDISK_BUFFER_SIZE__

transferbuffer:
local transferbuffer:

    push bc             ; save byte count for return
    push hl             ; save main memory address
    push bc             ; save byte count for second transfer to main memory

; transfer data from ramdisk to the buffer
    call RamDiskBankSwitchToAddress ; switch ramdisk bank into upper memory
    call RamDiskRebaseAddress       ; rebase ram disk address into upper memory 
    ex de,hl                        ; hl = ram disk address
    ld de,ramdiskbytesbuffer        ; transfer ram disk bytes to buffer
    ldir                            ; transfer bytes from main memory to buffer

; transfer data from from buffer to main memory
    ld a,5
    call RamDiskBankSwitch  ; switch to main memory bank 

    pop bc              ; recover byte count
    pop de              ; de = destination address in main memory
    ld hl,ramdiskbytesbuffer   ; hl = buffer
    ldir                ; transfer bytes from buffer to main memory

    pop hl              ; return byte count

    ret

ENDP
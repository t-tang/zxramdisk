; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

;--------------------------------------------------
; in : hl = ramdisk address
; in : bc = remaining bytes to be transferred
; out: hl = how many bytes were copied into the ram disk
; copies data from above $c000 into ram disk
;--------------------------------------------------
PROC

RamDiskWriteShadowedBytes:
    push hl             ; save source address
    ld hl,__RAMDISK_BUFFER_SIZE__   ;
    or a                ; clear carry flag
    sbc hl,bc           ; is remaining bytes < buffer size?
    jr nc, transferbuffer

transferwholebuffer:
local transferwholebuffer:
    ld bc,__RAMDISK_BUFFER_SIZE__

transferbuffer:
local transferbuffer:

    pop hl              ; recover source address
    push bc             ; save byte count for return
    push bc             ; save byte count for transfer to ram disk
    push de             ; save ram disk address
    ld de,ramdiskbytesbuffer   ; de = buffer
    ldir                ; transfer bytes from main memory to buffer

    pop de                          ; recover ram disk address
    pop bc                          ; recover byte count
    call RamDiskBankSwitchToAddress ; switch ramdisk bank into upper memory
    call RamDiskRebaseAddress       ; rebase ram disk address into upper memory 
    ld hl,ramdiskbytesbuffer
    ldir                            ; transfer bytes from main memory to buffer

    ld a,5
    call RamDiskBankSwitch  ; restore memory bank layout

    pop hl                  ; return byte count

    ret

__RAMDISK_BUFFER_SIZE__ equ $20

ramdiskbytesbuffer:
    ds __RAMDISK_BUFFER_SIZE__,0
ENDP
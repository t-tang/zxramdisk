; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

;--------------------------------------------------
; in  : hl = main memory address
; in  : de = ram disk address
; in  : bc = remaining bytes to be transferred
; keep: no registers preserved
; copies data from main memory address into a bank
;--------------------------------------------------
RamDiskTransferChunk:
PROC
    call initchunkvars
    call RamDiskTransferNonShadowedBytes   ; write all main memory bytes below $c000 efficiently
    call updatechunkvars

nextwrite:
local nextwrite:
    ld a,b
    or c
    jr z,endproc                  ; no more remaining bytes

    ld a,(ramdiskreadorwrite)
    or a                           ; is this a write to ram disk or a read?
    jr z,write                      ; it's a write operation
    call RamDiskReadShadowedBytes   ; read from ram disk
    jr next:

write:
local write:
    call RamDiskWriteShadowedBytes ; write to ram disk
next:
local next:
    call updatechunkvars
    jr nextwrite

endproc:
local endproc:
    ld hl,(chunkbytestransferred)
    ret
ENDP

;---------------------------------------------
; in  : hl = main memory address
; in  : de = ram disk address
; in  : bc = remaining byte count to be copie
; keep: bc,de,hl preserved
;---------------------------------------------
PROC
initchunkvars:
    push hl         ; save hl for caller convenience
    ld (chunkmainmemoryaddress),hl

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
; out : hl = updated main memory address
; out : de = updated ram disk address
; out : bc = updated remaining byte count
;---------------------------------------------
updatechunkvars:

    ld b,h
    ld c,l          ; bc = number of bytes copied

    ld hl,(chunkmainmemoryaddress)  ; update main memory address with bytes copied
    add hl,bc                       ; main memory address  += bytes copied
    ld (chunkmainmemoryaddress),hl  ; save updated main memory address

    ld hl,(chunkramDiskAddress)     ; update ram disk address with bytes copied
    add hl,bc                       ; ram disk address += bytes copied
    ld (chunkramDiskAddress),hl     ; save updated ram disk address
    ex de,hl                        ; de = ram disk address

    ld hl,(chunkbytestransferred)   ; update bytes transferred with bytes copied
    add hl,bc                       ; bytes transferred += bytes copied
    ld (chunkbytestransferred),hl   ; save bytes transferred

    ld hl,(chunkbytesremaining)     ; update bytes remaining with bytes copied
    or a                            ; clear carry flag
    sbc hl,bc                       ; bytes remaining -= bytes remaining
    ld (chunkbytesremaining),hl     ; save bytes remaining
    ld b,h                          ; msb bytes remaining
    ld c,l                          ; bc = remaining bytes

    ld hl,(chunkmainmemoryaddress)  ; hl = main memory address

    ret

;storage area used to track variables during transfer
;shared by WriteChunk and ReadChunk
chunkmainmemoryaddress:
local chunkmainmemoryaddress:
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
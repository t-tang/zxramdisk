; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_TRANSFER_NON_SHADOWED_BYTES_ASM__
#define __LIBRARY_RAMDISK_TRANSFER_NON_SHADOWED_BYTES_ASM__

#include"RamDiskBankSwitch.asm"
#include"RamDiskBankSwitchToAddress.asm"
#include"RamDiskRebaseAddress.asm"

RamDiskTransferNonShadowedBytes:
PROC

;--------------------------------------------------------------
; in : hl = main memory address
; in : de = ramdisk linear destination address
; in : bc = remaining byte count
; out: hl = number of bytes transferred
;--------------------------------------------------------------
; assert logical bank 5 is mapped to upper memory (phys 0)

    push hl                                 ; save main memory main memory address
    push de                                 ; save destination ram disk address

    call RamDiskCalcNonShadowedByteCount    ; hl = non shadowed byte count
    ld b,h
    ld c,l                                  ; bc = non shadowed byte count

    pop de                                  ; de = destination ram disk address 
    pop hl                                  ; hl = main memory main memory address

    ld a,b
    xor c
    jr nz,copybytes                         ; are there any bytes to copy?

    xor a                                   ; all main memory bytes > $c000
    ld h,a
    ld l,a
    ret                                     ; tell caller no bytes were transferred

copybytes:
local copybytes:
    push bc                         ; save non shadowed byte count for return

    call RamDiskBankSwitchToAddress ; switch ramdisk bank into upper memory
    call RamDiskRebaseAddress       ; rebase ram disk address into upper memory 
    ld a,(ramdiskreadorwrite)
    or a
    jr z,transfer
    ex de,hl                        ; this is a read from ramdisk
transfer:
local transfer:
    ldir                            ; copy bytes to ramdisk

    ld a,5
    call RamDiskBankSwitch          ; restore memory bank layout
    pop hl                          ; return bytes copied
    ret

ENDP
#endif
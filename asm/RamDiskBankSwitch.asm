#ifndef __LIBRARY_RAMDISK_BANKSWITCH_ASM__
#define __LIBRARY_RAMDISK_BANKSWITCH_ASM__
;---------------------------------------------
; in   : a = logical bank
; keep : de,hl
;---------------------------------------------
RamDiskBankSwitch
PROC

    RAMDISK_BANK_M equ $5B5C 
    local RAMDISK_BANK_M

    ld bc,logicalbanks ; mapping from logical to physical banks
    add a,c            ; look up the physical bank
    ld c,a
    jr nc,setphysicalbank
    inc b

setphysicalbank:
local setphysicalbank:
    ld a,(bc)               ; map into physcial bank
    ld c,a                  ; c = new bank
    ld a, (RAMDISK_BANK_M)  ; get current bank
    and %11111000           ; clear current bank
    or c                    ; mask in new bank
    ld bc, $7ffd            ; bank switching port
    di                      ; disable interrupts
    ld (RAMDISK_BANK_M),a   ; store new bank
    out (c),a               ; switch bank
    ei                      ; enable interrupts - todo: restore instead of assuming
    ret

;----------------------------------------------
; mapping of logical banks onto physical banks
; this arrangement means the top two bits of
; ram disk address identify the logical bank
;----------------------------------------------
logicalbanks:
local logicalbanks:
    ;physical         logical
    db $01          ; logical bank 0
    db $03          ; logical bank 1
    db $04          ; logical bank 2
    db $06          ; logical bank 3
    db $07          ; logical bank 4
    db $00          ; logical bank 5

ENDP
#endif
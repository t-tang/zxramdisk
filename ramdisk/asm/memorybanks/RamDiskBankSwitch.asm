; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_BANKSWITCH_ASM__
#define __LIBRARY_RAMDISK_BANKSWITCH_ASM__
;---------------------------------------------
; in   : a = logical bank
; keep : bc,de,hl
;---------------------------------------------
RamDiskBankSwitch
PROC

    RAMDISK_BANK_M equ $5B5C 

    push bc            ; save bc for convenience of callers

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

    pop bc                  ; restore bc to caller
    ret

;----------------------------------------------
; mapping of logical banks onto physical banks
; this arrangement means the top two bits of
; ram disk address identify the logical bank
;----------------------------------------------
RAMDISK_PHYS_INDEX_BANK equ $07
RAMDISK_PHYS_MAIN_BANK  equ $00

RAMDISK_LOGICAL_INDEX_BANK equ $04
RAMDISK_LOGICAL_MAIN_BANK  equ $05

logicalbanks:
local logicalbanks:
    ;physical         logical
    db $01          ; logical bank 0 - ramdisk storage $0000 - $3FFF
    db $03          ; logical bank 1 - ramdisk storage $4000 - $7FFF
    db $04          ; logical bank 2 - ramdisk storage $8000 - $BFFF
    db $06          ; logical bank 3 - ramdisk storage $C000 - $FFFF
    db RAMDISK_PHYS_INDEX_BANK ; logical bank 4 - catalog index
    db RAMDISK_PHYS_MAIN_BANK  ; logical bank 5 - regular (main) memory

ENDP
#endif
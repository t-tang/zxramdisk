#ifndef __RAMDISK_BANK_SWITCH_TO_ADDRESS_ASM__
#define __RAMDISK_BANK_SWITCH_TO_ADDRESS_ASM__

;--------------------------------------------------
; in   : de = ram disk address
; out  : memory bank for de is mapped to $c000
; keep : bc,de,hl
;--------------------------------------------------
RamDiskBankSwitchToAddress:
PROC
    ld a,d                  ; top 2 bits identify the logical ramdisk bank
    rrca    
    rrca                    ; a = ramdisk logical bank
    call RamDiskBankSwitch  ; switch ramdisk bank into upper memory
    ret
ENDP
#endif
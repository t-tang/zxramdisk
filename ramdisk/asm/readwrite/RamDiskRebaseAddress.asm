; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_REBASE_ADDRESS_ASM__
#define __LIBRARY_RAMDISK_REBASE_ADDRESS_ASM__
;--------------------------------------------------
; in   : de = rebase ram disk address into $c000 range
; out  : de rebased
; out  : memory bank switched in main memory
; keep : bc,hl
;--------------------------------------------------
RamDiskRebaseAddress:
PROC
    push hl                 ; save hl for caller convenience
    ld a,d                  ; high byte for linear dest address
    and %00111111           ; mask out the bank selector
    ld d,a                  ; de = 0 based dest address in memory bank

    ld hl,$c000             ;
    add hl,de               ; rebase destination addres to $c000
    ex de,hl                ; de = $c000 based dest address in main memory
    pop hl                  ; restore hl
    ret
ENDP
#endif
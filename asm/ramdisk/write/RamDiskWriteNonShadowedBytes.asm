#include"../../RamDiskBankSwitch.asm"

RamDiskWriteNonShadowedBytes:
PROC

;--------------------------------------------------------------
; in : hl = source address
; in : de = ramdisk linear destination address
; in : bc = bytes count to transfer
; out: hl = number of bytes transferred
;--------------------------------------------------------------
    ; assert logical bank 5 is mapped to upper memory (phys 0)
    ; assert hl + bc does not straddle memory banks

    ld a,d                  ; top 2 bits identify the logical ramdisk bank
    rrca    
    rrca                    ; a = ramdisk logical bank

    push bc                 ; save the byte count
    call RamDiskBankSwitch  ; switch ramdisk bank into upper memory
    pop bc                  ; restore the byte count

    ld a,d                  ; high byte for linear dest address
    and %11000000           ; mask out the bank selector
    ld d,a                  ; de = 0 based dest address in memory bank

    push bc                 ; save byte count for return
    push hl                 ; save the source address
    ld hl,$c000             ;
    add hl,de               ; rebase destination addres to $c000
    ex de,hl                ; de = $c000 based dest address in main memory
    pop hl                  ; retrieve the source address
     
    ldir                    ; copy bytes to ramdisk

    ld a,5
    call RamDiskBankSwitch  ; restore memory bank layout
    pop hl                  ; return byte count
    ret

ENDP
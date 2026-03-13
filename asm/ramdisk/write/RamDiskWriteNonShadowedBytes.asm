#include"../../RamDiskBankSwitch.asm"
#include"../RamDiskBankSwitchToAddress.asm"
#include"../RamDiskRebaseAddress.asm"

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

    call RamDiskBankSwitchToAddress ; switch ramdisk bank into upper memory
    call RamDiskRebaseAddress       ; rebase ram disk address into upper memory 
    push bc                         ; save byte count for return
    ldir                            ; copy bytes to ramdisk

    ld a,5
    call RamDiskBankSwitch  ; restore memory bank layout
    pop hl                  ; return byte count
    ret

ENDP
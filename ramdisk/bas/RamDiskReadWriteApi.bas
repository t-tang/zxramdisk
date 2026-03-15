' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

Sub Fastcall RamDiskLoadCode()
Asm
    ret
    #include "../asm/RamDiskReadWrite.asm"
End Asm
End Sub

Sub Fastcall RamDiskBankSwitch(logicalBank as ubyte)
Asm
    call RamDiskBankSwitch
End Asm
End Sub

#include"RamDiskCheckMemoryBanks.bas"
RamDiskLoadCode()
RamDiskCheckMemoryBanks()

'Transfer bytes from main memory to ramdisk
Sub Fastcall RamDiskWrite(mainmemoryAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger)
Asm
                    ; hl = main memory address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    xor a           ; a = 0, write to ramdisk

    jp RamDiskTransferMemory
End Asm
End Sub

'Transfer bytes from ram disk to main memory
Sub Fastcall RamDiskRead(mainmemoryAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger)
Asm
                    ; hl = main memory address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    ld a,1          ; a = 1, read from ramdisk

    jp RamDiskTransferMemory
End Asm
End Sub
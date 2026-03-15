' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

'--------------------------------------------------------------
' $00 filename 10 bytes
' $0a file length 2 bytes
' $0c start address in ramdisk 2 bytes
'--------------------------------------------------------------

Sub Fastcall RamDiskLoadTestFns()
Asm
    ret
    #include "../ramdisk/asm/RamDiskReadWrite.asm"
End Asm
End Sub

RamDiskLoadTestFns()

Function Fastcall RamDiskNextChunk(ramdiskAddress as uinteger, remainingBytes as uinteger) as uinteger
Asm
                    ; hl = ramdiskAddress (linear)
    pop af          ; return address to ZX Basic
    pop bc          ; bc = remaining bytes
    push af         ; restore return address

    call RamDiskNextChunk

End Asm
End Function

Function Fastcall RamDiskCalcNonShadowedByteCount(sourceAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
                    ; hl = source address
    pop af          ; return address to ZX Basic
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    call RamDiskCalcNonShadowedByteCount

ENDP
End Asm
End Function

'copy source bytes above $c000 using a buffer
Function Fastcall RamDiskWriteShadowedBytes(sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    call RamDiskWriteShadowedBytes
ENDP
End Asm
End Function

'copy source bytes above $c000 using a buffer
Function Fastcall RamDiskReadShadowedBytes(sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    call RamDiskReadShadowedBytes
ENDP
End Asm
End Function

Function Fastcall RamDiskTransferNonShadowedBytes(readOrWrite as ubyte, sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ld (ramdiskreadorwrite),a
    pop af          ; return address to ZX Basic
    pop hl          ; hl = source address
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    call RamDiskTransferNonShadowedBytes
ENDP
End Asm
End Function

'Transfers bytesLen bytes between main memory and ram disk
Function Fastcall RamDiskTransferChunk(readOrWrite as ubyte, mainmemoryAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ld (ramdiskreadorwrite),a
    pop af          ; return address to ZX Basic
    pop hl          ; hl = source address
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    call RamDiskTransferChunk
ENDP
End Asm
End Function

'Transfer bytes between main memory and ramdisk
Function Fastcall RamDiskTransferMemory(direction as ubyte, mainmemoryAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ex af,af'       ; save direction of transfer
    pop af          ; return address to ZX Basic
    pop hl          ; hl = main memory address
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    ex af,af'       ; retrieve direction of transfer

    call RamDiskTransferMemory

ENDP
End Asm
End Function

Sub Fastcall RamDiskBankSwitch(logicalBank as ubyte)
Asm
    call RamDiskBankSwitch
End Asm
End Sub
'--------------------------------------------------------------
' $00 filename 10 bytes
' $0a file length 2 bytes
' $0c start address in ramdisk 2 bytes
'--------------------------------------------------------------

Sub Dummy()
Asm
    #include "../asm/RamDiskBankSwitchToAddress.asm"
    #include "../asm/RamDiskRebaseAddress.asm"
End Asm
End Sub

Sub Fastcall RamDiskBankSwitch(logicalbanknum as ubyte)
Asm
    #include "../asm/RamDiskBankSwitch.asm"
End Asm
End Sub

Function Fastcall RamDiskNextChunk(ramdiskAddress as uinteger, remainingBytes as uinteger) as uinteger
Asm
                    ; hl = ramdiskAddress (linear)
    pop af          ; return address to ZX Basic
    pop bc          ; bc = remaining bytes
    push af         ; restore return address

    #include"../asm/RamDiskNextChunk.asm"
End Asm
End Function

Function Fastcall RamDiskCalcNonShadowedByteCount(sourceAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
                    ; hl = source address
    pop af          ; return address to ZX Basic
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    #include"../asm/RamDiskCalcNonShadowedByteCount.asm"
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
    #include"../asm/write/RamDiskWriteShadowedBytes.asm"
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
    #include"../asm/write/RamDiskReadShadowedBytes.asm"
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
    #include"../asm/RamDiskTransferNonShadowedBytes.asm"
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
    #include"../asm/RamDiskTransferChunk.asm"
ENDP
End Asm
End Function

'Transfer bytes between main memory and ramdisk
Function Fastcall RamDiskTransfer(direction as ubyte, mainmemoryAddress as uinteger, ramdisktAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ex af,af'       ; save direction of transfer
    pop af          ; return address to ZX Basic
    pop hl          ; hl = main memory address
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    ex af,af'       ; retrieve direction of transfer

    #include"../asm/RamDiskTransfer.asm"
ENDP
End Asm
End Function

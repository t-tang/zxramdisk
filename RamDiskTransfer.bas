'--------------------------------------------------------------
' $00 filename 10 bytes
' $0a file length 2 bytes
' $0c start address in ramdisk 2 bytes
'--------------------------------------------------------------

'calculate how many bytes fit into the bank at ram disk address
Function Fastcall RamDiskNextChunk(ramdiskAddress as uinteger, remainingBytes as uinteger) as uinteger
Asm
                    ; hl = ramdiskAddress (linear)
    pop af          ; return address to ZX Basic
    pop bc          ; bc = remaining bytes
    push af         ; restore return address

    #include"asm/ramdisk/RamDiskNextChunk.asm"
End Asm
End Function

'copy all source bytes below $c000
Function Fastcall RamDiskWriteNonShadowedBytes(sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address

    #include"asm/ramdisk/write/RamDiskWriteNonShadowedBytes.asm"
ENDP
End Asm
End Function

'buffered copy of source bytes above $c000 using a buffer
Function Fastcall RamDiskWriteShadowedBytes(sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    #include"asm/ramdisk/write/RamDiskWriteShadowedBytes.asm"
ENDP
End Asm
End Function

'Copies byteslen source bytes to ram disk address
'Control loop for Write Non Shadow Bytes and Write Shadow Bytes
Function Fastcall RamDiskTransferChunk(sourceAddress as uinteger, ramdiskAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    #include"asm/ramdisk/RamDiskTransferChunk.asm"
ENDP
End Asm
End Function

'Transfer bytes between main memory and ramdisk
Function Fastcall RamDiskTransfer(sourceAddress as uinteger, ramdisktAddress as uinteger, bytesLen as uinteger) as uinteger
Asm
PROC
    ; hl = source address
    pop af          ; return address to ZX Basic
    pop de          ; de = dest address in RamDisk (linear)
    pop bc          ; bc = remaining bytes to be copied
    push af         ; restore return address
    #include"asm/ramdisk/RamDiskTransfer.asm"
ENDP
End Asm
End Function

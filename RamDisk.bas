#include<hex.bas>
#include"sys/RamDiskSysVars.bas"
#include"sys/RamDiskBankSwitch.bas"
#include"RamDiskWrite.bas"

#include<memcopy.bas>

cls

Const RamDiskBank0 as UBYTE = $00
Const RegularMemory as UBYTE = $05

Sub Fastcall RamDiskTransfer(sourceAddress as uinteger, ramDiskAddress as uinteger, bytesLen as uinteger)
Asm
End Asm
PROC
                ; hl = source address
    pop af      ; return address to ZX Basic
    pop de      ; de = ram disk address
    pop bc      ; bc = remaining bytes 
    push af     ; restore return address

 
ENDP
End Sub

Sub RamDiskWrite(sourceAddress as uinteger, ramDiskAddress as uinteger, bytesLen as uinteger)
    dim bytesUsed as uinteger
    while bytesLen > 0

        bytesUsed = RamDiskGetNextChunk(ramDiskAddress, bytesLen)
        print hex16(sourceAddress);" ";hex16(ramDiskAddress);" ";hex16(bytesUsed);" bank"
        print "------------------------------"

        RamDiskWriteChunk(sourceAddress,ramDiskAddress,bytesUsed)
        print 
        bytesLen = bytesLen - bytesUsed
        ramDiskAddress = ramDiskAddress + bytesUsed
        sourceAddress = sourceAddress + bytesUsed

    end while
End Sub

dim sourceAddress as uinteger = $BFFF
dim ramDiskAddress as uinteger = $3FFF
dim bytesLen as uinteger = $40

RamDiskWrite(sourceAddress, ramDiskAddress, bytesLen)

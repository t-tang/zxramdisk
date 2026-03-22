' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include<hex.bas>
#include"print42.bas"

DATA 0,0,4,8,80,32,0,0
DATA 0,68,40,16,40,68,0,0

dim n as ubyte : for i = usr "a" to usr "a" + 15: read n: poke i,n: next

Dim tmpStr as string
Sub CheckResult(actualResult as uinteger, expectedResult as uinteger, testDesc as string)
    if actualResult = expectedResult THEN
        tmpStr = "\A"
    ELSE
        tmpStr = "\B"
    END IF

    tmpStr = tmpStr + " " + hex16(actualResult) + " " + hex16(expectedResult) + " " +  testDesc + chr(13)
    ink (((actualResult <> expectedResult) * 2))
    print42(tmpStr) 
End Sub

Sub CheckString(actualResult as string, expectedResult as string, testDesc as string)
    if actualResult = expectedResult THEN
        tmpStr = "\A"
    ELSE
        tmpStr = "\B"
    END IF

    tmpStr = tmpStr + " " + hex16(Len(actualResult)) + " " + hex16(Len(expectedResult)) + " " +  testDesc + chr(13)
    ink (((actualResult <> expectedResult) * 2))
    print42(tmpStr) 
End Sub

Function MainMemoryCheckSum(sourceAddress as uinteger, byteCount as uinteger) as uinteger
    dim srcXorCheck, srcSumCheck, aByte as ubyte
    for i = 0 to byteCount - 1
        aByte = peek(sourceAddress + i)
        srcXorCheck = srcXorCheck xor aByte
        srcSumCheck = srcSumCheck + aByte
    next
    return srcXorCheck * 256 + srcSumCheck
End Function

Function RamDiskCheckSum(ramdiskAddress as uinteger, byteCount as uinteger) as uinteger
    'switch bank into upper memory
    dim memBank as ubyte = ramdiskAddress / $4000
    RamDiskBankSwitch(memBank)
    dim rebasedAddress as uinteger = (ramdiskAddress bAND %0011111111111111) + $c000

    dim ramXorCheck, ramSumCheck, aByte as ubyte
    for i = 0 to byteCount - 1
        aByte = peek(rebasedAddress + i)
        ramXorCheck = ramXorCheck xor aByte
        ramSumCheck = ramSumCheck + aByte
    next

    RamDiskBankSwitch($05)

    return ramXorCheck * 256 + ramSumCheck
End Function

Sub CheckTransfer(sourceAddress as uinteger, ramdiskAddress as uinteger, byteCount as uinteger, testDesc as string)
    dim mainMemoryChecksum as uinteger = MainMemoryCheckSum(sourceAddress,byteCount)
    dim ramdiskChecksum as uinteger = RamDiskCheckSum(ramdiskAddress, byteCount)

    CheckResult(mainMemoryChecksum, ramdiskChecksum, testDesc)

End Sub


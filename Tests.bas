#include<hex.bas>
#include"sys/print42.bas"
#include"sys/RamDiskBankSwitch.bas"
#include"RamDiskTransfer.bas"

DATA 0,0,4,8,80,32,0,0
DATA 0,68,40,16,40,68,0,0

dim n as ubyte : for i = usr "a" to usr "a" + 15: read n: poke i,n: next
cls

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

Sub CheckTransfer(sourceAddress as uinteger, ramdiskAddress as uinteger, byteCount as uinteger, testDesc as string)

    dim srcXorCheck, srcSumCheck, aByte as ubyte
    for i = 0 to byteCount - 1
        aByte = peek(sourceAddress + i)
        srcXorCheck = srcXorCheck xor aByte
        srcSumCheck = srcSumCheck + aByte
    next

    'switch bank into upper memory
    dim memBank as ubyte = ramdiskAddress / $4000
    RamDiskBankSwitch(memBank)

    dim ramXorCheck, ramSumCheck as ubyte
    for i = 0 to byteCount - 1
        aByte = peek(sourceAddress + i)
        ramXorCheck = ramXorCheck xor aByte
        ramSumCheck = ramSumCheck + aByte
    next

    RamDiskBankSwitch($05)

    CheckResult(srcXorCheck * 256 + srcSumCheck, ramXorCheck * 256 + ramSumCheck, testDesc)

End Sub


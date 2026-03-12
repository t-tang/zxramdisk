#include<hex.bas>
#include"sys/print42.bas"
#include"RamDiskTransfer.bas"

DATA 0,0,4,8,80,32,0,0
DATA 0,68,40,16,40,68,0,0

dim n as ubyte : for i = usr "a" to usr "a" + 15: read n: poke i,n: next

Dim tmpStr as string
Sub Test(actualResult as uinteger, expectedResult as uinteger, testDesc as string)
    if actualResult = expectedResult THEN tmpStr = "\A": ELSE tmpStr = "\B": ENDIF
    tmpStr = tmpStr + " " + hex16(actualResult) + " " + hex16(expectedResult) + " " +  testDesc + chr(13)
    ink (((actualResult <> expectedResult) * 2) or 1)
    print42(tmpStr) 
End Sub

cls

'This routine calculates the number of source bytes below $c000
Test(RamDiskCalcNonShadowedByteCount($0000,$10), $0010, "Calc Non Shadowed Byte Count")
Test(RamDiskCalcNonShadowedByteCount($BFFF,$10), $0001, "Calc Non Shadowed Byte Count")

'This routine uses a buffer to copy source bytes above $c000
Test(RamDiskWriteShadowedBytes($C000,$4000,$21), $0020,"Write Shadowed Bytes")
Test(RamDiskWriteShadowedBytes($C000,$4000,$1F), $001F,"Write Shadowed Bytes")

'This routine splits the source bytes into chunks which all fit inside a bank
'Simplifies downstream routines because they don't need to worry about bank boundaries
Test(RamDiskNextChunk($0000,$10), $0010,"Next Chunk")
Test(RamDiskNextChunk($BFFF,$10), $0001,"Next Chunk")
Test(RamDiskNextChunk($0000,$4100), $4000,"Next Chunk")
Test(RamDiskNextChunk($1000,$4100), $3000,"Next Chunk")

'This routine copies source bytes into the ram disk bank indicated by ram disk start address
Test(RamDiskTransferChunk($0000,$0000,$2000),$2000,"Transfer Chunk")


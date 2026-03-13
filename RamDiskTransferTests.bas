#include<hex.bas>
#include"sys/print42.bas"
#include"HasMemoryBanks.bas"
#include"Tests.bas"

If Not HasMemoryBanks() Then
    Print "No memory banks found"
    Stop
End If

Dim someData($20) as ubyte
for i = 0 to $20 - 1: someData(i) = i: next
for i = 0 to $100: poke $c100 + i, i mod $21: next
for i = 0 to $100: poke $bffe + i, i: next

CheckResult(RamDiskCalcNonShadowedByteCount($C000,$10), $0000, "Calc Non Shadowed Byte Count")
CheckResult(RamDiskCalcNonShadowedByteCount($C100,$10), $0000, "Calc Non Shadowed Byte Count")
CheckResult(RamDiskCalcNonShadowedByteCount($0000,$10), $0010, "Calc Non Shadowed Byte Count")
CheckResult(RamDiskCalcNonShadowedByteCount($BFFF,$10), $0001, "Calc Non Shadowed Byte Count")

'This routine calculates the number of source bytes below $c000
'This routine copies source bytes below $c000 in to ram disk
CheckTransfer(RamDiskWriteNonShadowedBytes(@someData(0),$0000,$20),@someData(0),$0000,"Write Non Shadowed Bytes")
CheckTransfer(RamDiskWriteNonShadowedBytes($0000,$0000,$200),$0000,$0000,"Write Non Shadowed Bytes")

'This routine uses a buffer to copy source bytes above $c000
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$001F),$001F,"Write Shadowed Bytes")        'remaining < buffer size
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$0020),$0020,"Write Shadowed Bytes")        'remaining = buffer size
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$0021),$0020,"Write Shadowed Bytes")        'remaining > buffer size
CheckTransfer(RamDiskWriteShadowedBytes($C100,$0000,$0020),$C100,$0000,"Write Shadowed Bytes")

'This routine splits the source bytes into chunks which all fit inside a bank
'Simplifies downstream routines because they don't need to worry about bank boundaries
CheckResult(RamDiskNextChunk($0000,$0010), $0010,"Next Chunk")
CheckResult(RamDiskNextChunk($BFFF,$0010), $0001,"Next Chunk")
CheckResult(RamDiskNextChunk($0000,$4100), $4000,"Next Chunk")
CheckResult(RamDiskNextChunk($1000,$4100), $3000,"Next Chunk")

'This routine copies source bytes into the ram disk bank indicated by ram disk start address
RamDiskTransferChunk($1000,$0000,$0200): CheckTransfer($0200, $1000, $0000, "Transfer Chunk")    'all source bytes below $c000
RamDiskTransferChunk($BFFE,$0000,$0022): CheckTransfer($0022, $BFFE, $0000, "Transfer Chunk")    '2 source bytes below $c000, remaining = buffer size
RamDiskTransferChunk($BFFE,$0001,$0036): CheckTransfer($0036, $BFFE, $0001, "Transfer Chunk")    '2 source bytes below $c000, remaining > buffer size
RamDiskTransferChunk($C101,$0000,$0020): CheckTransfer($0020, $C101, $0000, "Transfer Chunk")    'all source bytes above $c000
RamDiskTransferChunk($BFFE,$0000,$0103): CheckTransfer($0103, $BFFE, $0000, "Transfer Chunk")

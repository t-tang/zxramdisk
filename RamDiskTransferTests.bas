#include<hex.bas>
#include"sys/print42.bas"
#include"Tests.bas"

Dim someData($20) as ubyte
for i = 0 to $20 - 1: someData(i) = i: next
for i = 0 to $20 - 1: poke $c100 + i, i: next

'This routine calculates the number of source bytes below $c000
CheckResult(RamDiskCalcNonShadowedByteCount($0000,$10), $0010, "Calc Non Shadowed Byte Count")
CheckResult(RamDiskCalcNonShadowedByteCount($BFFF,$10), $0001, "Calc Non Shadowed Byte Count")

'This routine copies source bytes below $c000 in to ram disk
CheckTransfer(RamDiskWriteNonShadowedBytes(@someData(0),$0000,$20),@someData(0),$0000,"Write Non Shadowed Bytes")

'This routine uses a buffer to copy source bytes above $c000
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$21), $0020,"Write Shadowed Bytes")
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$1F), $001F,"Write Shadowed Bytes")
CheckTransfer(RamDiskWriteShadowedBytes($C100,$4020,$20),$C100,$4020, "Write Shadowed Bytes")   'byte count same as buffer size

'This routine splits the source bytes into chunks which all fit inside a bank
'Simplifies downstream routines because they don't need to worry about bank boundaries
CheckResult(RamDiskNextChunk($0000,$10), $0010,"Next Chunk")
CheckResult(RamDiskNextChunk($BFFF,$10), $0001,"Next Chunk")
CheckResult(RamDiskNextChunk($0000,$4100), $4000,"Next Chunk")
CheckResult(RamDiskNextChunk($1000,$4100), $3000,"Next Chunk")

'This routine copies source bytes into the ram disk bank indicated by ram disk start address
RamDiskTransferChunk($1000,$0000,$0200): CheckTransfer($200, $1000, $0000, "Transfer Chunk")    'all source bytes below $c000

#include<MemCopy.bas>
'copy screen into memory at $B000
'MemCopy($4000, $b000, $68ac)
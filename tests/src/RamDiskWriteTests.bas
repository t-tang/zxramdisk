' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

' ----------------------------------------------------------
' Unit tests for the low level Ram Disk write routines
' ----------------------------------------------------------

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
RamDiskTransferNonShadowedBytes($00,@someData(0),$0000,$20): CheckTransfer(@someData(0),$0000,$0020,"Write Non Shadowed Bytes")
RamDiskTransferNonShadowedBytes($00,$0000,$0000,$0200): CheckTransfer($0000,$0000,$0200,"Write Non Shadowed Bytes")

'This routine uses a buffer to copy source bytes above $c000
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$001F),$001F,"Write Shadowed Bytes")        'remaining < buffer size
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$0020),$0020,"Write Shadowed Bytes")        'remaining = buffer size
CheckResult  (RamDiskWriteShadowedBytes($C000,$4000,$0021),$0020,"Write Shadowed Bytes")        'remaining > buffer size
RamDiskWriteShadowedBytes($C100,$0000,$0020): CheckTransfer($C100,$0000,$0020,"Write Shadowed Bytes")

'This routine splits the source bytes into chunks which all fit inside a bank
'Simplifies downstream routines because they don't need to worry about bank boundaries
CheckResult(RamDiskNextChunk($0000,$0010), $0010,"Next Chunk")
CheckResult(RamDiskNextChunk($BFFF,$0010), $0001,"Next Chunk")
CheckResult(RamDiskNextChunk($0000,$4100), $4000,"Next Chunk")
CheckResult(RamDiskNextChunk($1000,$4100), $3000,"Next Chunk")

'This routine copies source bytes into the ram disk bank indicated by ram disk start address
RamDiskTransferChunk($00,$1000,$0000,$0200): CheckTransfer($1000, $0000, $0200, "Write Chunk")    'all source bytes below $c000
RamDiskTransferChunk($00,$BFFE,$0000,$0022): CheckTransfer($BFFE, $0000, $0022, "Write Chunk")    '2 source bytes below $c000, remaining = buffer size
RamDiskTransferChunk($00,$BFFE,$0001,$0036): CheckTransfer($BFFE, $0001, $0036, "Write Chunk")    '2 source bytes below $c000, remaining > buffer size
RamDiskTransferChunk($00,$C101,$0000,$0020): CheckTransfer($C101, $0000, $0020, "Write Chunk")    'all source bytes above $c000
RamDiskTransferChunk($00,$BFFE,$0000,$0103): CheckTransfer($BFFE, $0000, $0103, "Write Chunk")

'This routine transfers data across banks boundaries
RamDiskTransferMemory($00,$C000,$4800,$0400): CheckTransfer($C000, $4800, $0400, "Transfer Write")
RamDiskTransferMemory($00,$BFFE,$4800,$0400): CheckTransfer($BFFE, $4800, $0400, "Transfer Write")

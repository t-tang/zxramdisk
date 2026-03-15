#include<hex.bas>
#include"../sys/print42.bas"
#include"../sys/HasMemoryBanks.bas"
#include"../ramdisk/bas/RamDiskTransfer.bas"

#include"TestUtils.bas"

cls

If Not HasMemoryBanks() Then
    Print "No memory banks found"
    Stop
End If

'----------------------------------------'
' Write-Read Non Shadowed bytes
'----------------------------------------'
for i = 0 to $100: poke $bfe0 + i, i mod $21: next
RamDiskTransferNonShadowedBytes($00,$BFE0,$c200,$0020)

for i = 0 to $100: poke $bfe0 + i, 0: next
RamDiskTransferNonShadowedBytes($01,$BFE0,$c200,$0020)
CheckTransfer($BFE0,$c200,$0020,"Write-Read Non Shadowed Bytes")

'----------------------------------------'
' Write-Read Shadowed bytes
'----------------------------------------'
for i = 0 to $100: poke $c100 + i, i mod $21: next
RamDiskWriteShadowedBytes($c100,$c300,$0020)

for i = 0 to $100: poke $c100 + i,0: next
RamDiskReadShadowedBytes($c100,$c300,$100)
CheckTransfer($c100,$c300,$0020,"Write-Read Shadowed Bytes")

'----------------------------------------'
' Large Transfer
'----------------------------------------'
for i = 0 to $100: poke $c100 + i, i mod $21: next
RamDiskTransfer($00,$c100,$c300,$100)

for i = 0 to $100: poke $c100 + i,0: next
RamDiskTransfer($01,$c100,$c300,$100)
CheckTransfer($c100,$c300,$0100,"Write-Read Transfer")
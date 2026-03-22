' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

' ----------------------------------------------------------
' Unit tests for the low level Ram Disk read routines
' ----------------------------------------------------------

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
RamDiskTransferMemory($00,$c100,$c300,$100)

for i = 0 to $100: poke $c100 + i,0: next
RamDiskTransferMemory($01,$c100,$c300,$100)
CheckTransfer($c100,$c300,$0100,"Write-Read Transfer")
#include<hex.bas>
#include"../sys/print42.bas"
#include"../sys/HasMemoryBanks.bas"

#include"RamDiskTestFns.bas"
#include"TestUtils.bas"

RamDiskLoadTestFns()
cls

If Not HasMemoryBanks() Then
    Print "No memory banks found"
    Stop
End If

#include"RamDiskWriteTests.bas"
#include"RamDiskReadTests.bas"

border 1
pause 0
#include<hex.bas>
#include"../sys/print42.bas"
#include"../ramdisk/bas/RamDiskCheckMemoryBanks.bas"

#include"RamDiskTestFns.bas"
#include"TestUtils.bas"

cls
RamDiskCheckMemoryBanks()

#include"RamDiskWriteTests.bas"
#include"RamDiskReadTests.bas"

border 1: pause 0

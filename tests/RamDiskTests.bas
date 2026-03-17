' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include<hex.bas>
#include"../ramdisk/bas/RamDiskCheckMemoryBanks.bas"

#include"src/util/RamDiskTestFns.bas"
#include"src/util/TestUtils.bas"

cls
RamDiskCheckMemoryBanks()

#include"src/RamDiskWriteTests.bas"
#include"src/RamDiskReadTests.bas"

Border 1: Pause 0
#include"src/RamDiskTestReadWriteApi.bas"

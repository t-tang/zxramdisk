' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include<hex.bas>
#include"util/TestUtils.bas"
#include"util/RamDiskCatalogTestFns.bas"
Cls

CheckResult($0000, RamDiskCatalogGetSize(), "Initial Catalog size is 0")
RamDiskCatalogWriteEntry("helloworld",$E101,$F000)
CheckResult($0001, RamDiskCatalogGetSize(), "Catalog size with 1 entry")
RamDiskCatalogWriteEntry("foobar",$E100,$00F0)
CheckResult($0002, RamDiskCatalogGetSize(), "Catalog size with 2 entries")

CheckResult($F000, RamDiskCatalogGetFileSize($0000), "File size is saved (01)")
CheckResult($00F0, RamDiskCatalogGetFileSize($0001), "File size is saved (02)")

CheckResult($E101, RamDiskCatalogGetRamDiskAddress($0000), "Ram Disk address is saved (01)")
CheckResult($E100, RamDiskCatalogGetRamDiskAddress($0001), "Ram Disk address is saved (02)")

CheckString("helloworld", RamDiskCatalogGetFilename($0000), "Filename is helloworld (01)")
CheckString("foobar", RamDiskCatalogGetFilename($0001), "Filename is foobar (01)")
RamDiskCatalogWriteEntry("loremipsumdolor",$E101,$F000)
CheckString("loremipsum", RamDiskCatalogGetFilename($0002), "Filename is truncated")

stop

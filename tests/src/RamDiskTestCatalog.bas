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

CheckResult($0000, RamDiskCatalogGetIndexSize(), "Initial index size is 0")
CheckResult($000F, RamDiskLoad("helloworld",$0000), "Search empty catalog")
CheckResult(ERR_INVALID_ARGUMENT, RamDiskSave("test", $0000, $0000), "Cannot save 0 bytes")
CheckResult(ERR_INVALID_FILE_NAME, RamDiskSave("", $0000, $0010), "Cannot save empty filename")

' ----------------------------------------------------------
' Save first file
' ----------------------------------------------------------
CheckResult(ERR_OK, RamDiskSave("helloworld",$0000,$4000), "Successful Save (01)")
CheckResult($0001, RamDiskCatalogGetIndexSize(), "Index size with 1 entry")
CheckResult($BFFF, RamDiskCatalogGetFreeBytes(), "Free Bytes is updated (01)")
CheckResult($4000, RamDiskCatalogFreeRamDiskAddress(), "Next Ram Disk address (01)")
CheckTransfer($0000,$0000,$4000,"Saved to Ram Disk (01)")

' ----------------------------------------------------------
' Save second file
' ----------------------------------------------------------
CheckResult(ERR_OK, RamDiskSave("foobar",$0000,$2000), "Successful Save (02)")
CheckResult($0002, RamDiskCatalogGetIndexSize(), "Index size with 2 entries")
CheckResult($9FFF, RamDiskCatalogGetFreeBytes(), "Free Bytes is updated (02)")
CheckResult($6000, RamDiskCatalogFreeRamDiskAddress(), "Next Ram Disk address (02)")
CheckTransfer($0000,$4000,$2000,"Saved to Ram Disk (02)")

' ----------------------------------------------------------
' Check Catalog Index Entries
' ----------------------------------------------------------
CheckResult($4000, RamDiskCatalogGetFileSize($0000), "File size is saved (01)")
CheckResult($2000, RamDiskCatalogGetFileSize($0001), "File size is saved (02)")

CheckResult($0000, RamDiskCatalogGetRamDiskAddress($0000), "Ram Disk address is saved (01)")
CheckResult($4000, RamDiskCatalogGetRamDiskAddress($0001), "Ram Disk address is saved (02)")

CheckString("helloworld", RamDiskCatalogGetFilename($0000), "Filename is helloworld (01)")
CheckString("foobar", RamDiskCatalogGetFilename($0001), "Filename is foobar (02)")
RamDiskCatalogWriteIndexEntry("loremipsumdolor",$E101,$F000)
CheckString("loremipsum", RamDiskCatalogGetFilename($0002), "Long filename is truncated")
CheckResult($EBDF, RamDiskCatalogGetIndexEntryPtr("foobar"), "Find foobar in catalog")
CheckResult($000F, RamDiskLoad("twasbrilig",$0000), "Load bad filename fails")

Border 0 : Pause 0

' ----------------------------------------------------------
' Screen Test
' ----------------------------------------------------------
Load "Test2.scr" Code $C000
RamDiskSave("Test2.scr",$C000,6912)
RamDiskLoad("Test2.scr",$4000)
Border 1
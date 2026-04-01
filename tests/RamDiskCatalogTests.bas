' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include"src/util/TestUtils.bas"
#include"src/catalog/RamDiskCatalogTestFns.bas"
Cls

CheckResult($0000, RamDiskIndexSize(), "Initial index size is 0")
CheckResult($FFFF, RamDiskFreeBytes(), "Inital Free Bytes")
CheckResult(ERR_FILE_DOES_NOT_EXIST, RamDiskLoad("helloworld",$0000), "Search empty catalog")
CheckResult(ERR_INVALID_ARGUMENT, RamDiskSave("test", $0000, $0000), "Cannot save 0 bytes")
CheckResult(ERR_INVALID_FILE_NAME, RamDiskSave("", $0000, $0010), "Cannot save empty filename")

' ----------------------------------------------------------
' Save first file
' ----------------------------------------------------------
CheckResult(ERR_OK, RamDiskSave("helloworld",$0000,$4000), "Successful Save (01)")
CheckResult($0001, RamDiskIndexSize(), "Index size with 1 entry")
CheckResult($BFFF, RamDiskFreeBytes(), "Free Bytes is updated (01)")
CheckResult($4000, RamDiskCatalogFreeRamDiskAddress(), "Next Ram Disk address (01)")
CheckTransfer($0000,$0000,$4000,"Saved to Ram Disk (01)")
CheckString("helloworld", RamDiskFilename($0000), "Filename is helloworld (01)")
CheckResult($4000, RamDiskFileSize($0000), "File size is saved (01)")
CheckResult($0000, RamDiskCatalogGetRamDiskAddress($0000), "Ram Disk address is saved (01)")

' ----------------------------------------------------------
' Save second file
' ----------------------------------------------------------
CheckResult(ERR_OK, RamDiskSave("foobar",$0000,$2000), "Successful Save (02)")
CheckResult($0002, RamDiskIndexSize(), "Index size with 2 entries")
CheckResult($9FFF, RamDiskFreeBytes(), "Free Bytes is updated (02)")
CheckResult($6000, RamDiskCatalogFreeRamDiskAddress(), "Next Ram Disk address (02)")
CheckTransfer($0000,$4000,$2000,"Saved to Ram Disk (02)")
CheckString("foobar", RamDiskFilename($0001), "Filename is foobar (02)")
CheckResult($2000, RamDiskFileSize($0001), "File size is saved (02)")
CheckResult($4000, RamDiskCatalogGetRamDiskAddress($0001), "Ram Disk address is saved (02)")

Border 0 : Pause 250 : Cls : printat42(0,0)

' ----------------------------------------------------------
' Edge conditions
' ----------------------------------------------------------
CheckResult(ERR_FILE_ALREADY_EXISTS, RamDiskSave("foobar",$0000,$2000), "Duplicate file check")
CheckResult($0000, RamDiskCatalogGetIndexEntry($FF), "Out of bounds index")
CheckResult($0000, Len(RamDiskFilename($FF)), "Out of bounds filename")
CheckResult($0000, RamDiskFileSize($FF), "Out of bounds file size")
CheckResult(ERR_OK, RamDiskSave("loremipsumdolor",$E101,$0001),"Save long filename")
CheckString("loremipsum", RamDiskFilename($0002), "Long filename is truncated")
CheckResult($EBDF, RamDiskCatalogGetIndexPtr("foobar"), "Find foobar in catalog")
CheckResult(ERR_FILE_DOES_NOT_EXIST, RamDiskLoad("twasbrilig",$0000), "Load bad filename fails")
CheckResult(ERR_OK, RamDiskSave("foobar1",$0000,$2000), "Successful Save (03)")
CheckResult(ERR_OUT_OF_MEMORY, RamDiskSave("foobar2",$0000,$2000), "Catalog is full")

Dim expectedFilenames(3) as String: for i = 0 to RamDiskIndexSize() - 1: Read expectedFilenames(i): Next : Data "helloworld","foobar","loremipsum","foobar1"
Dim filenames(3) as String: for i = 0 to RamDiskIndexSize() - 1 : filenames(i) = RamDiskFilename(i): next
CheckResult($0003, StrArrayEquals(expectedFilenames, filenames, 3), "Enumerate filenames")

RamDiskClear()
CheckResult($0000, RamDiskIndexSize(), "Ram disk clear")

Border 1 : Pause 250 : Cls : printat42(0,0)

' ----------------------------------------------------------
' Screen Test
' ----------------------------------------------------------
Load "Test2.scr" Code $C000
RamDiskSave("Test2.scr",$C000,6912)
RamDiskLoad("Test2.scr",$4000)
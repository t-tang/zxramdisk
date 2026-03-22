' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include<hex.bas>
#include"../../ramdisk/bas/RamDiskCatalogApi.bas"

RamDiskCatalogWriteEntry("helloworld",$E101,$F000)
RamDiskCatalogWriteEntry("foobar",$E100,$00F0)
print RamDiskCatalogGetFilename($00), hex16(RamDiskCatalogGetFileSize($00))
print RamDiskCatalogGetFilename($01), hex16(RamDiskCatalogGetFileSize($01))

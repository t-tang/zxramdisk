' ----------------------------------------------------------
' This file is released under the MIT License
'
' Copyleft (k) 2026
' by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
' ----------------------------------------------------------

#include<hex.bas>
#include"../../ramdisk/bas/RamDiskCatalogApi.bas"

RamDiskCatalogWriteEntry("helloworld",$E101,$00F0)
RamDiskCatalogWriteEntry("foobar",$E100,$00F0)
print RamDiskCatalogGetFileName($00)
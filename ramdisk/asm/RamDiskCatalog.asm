; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; Export all Ram Disk Catalog assembly routines
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATALOG_API_ASM__
#define __LIBRARY_RAMDISK_CATALOG_API_ASM__

#include"catalog/RamDiskCatalogGlobalVars.asm"
#include"catalog/RamDiskCatalogWriteIndexEntry.asm"
#include"catalog/RamDiskCatalogGetIndexEntry.asm"
#include"catalog/RamDiskCatalogGetFilename.asm"
#include"catalog/RamDiskCatalogGetIndexWord.asm"
#include"catalog/RamDiskCatalogGetIndexSize.asm"
#include"catalog/RamDiskCatalogGetIndexPtr.asm"
#include"catalog/RamDiskCatalogSaveFile.asm"
#include"catalog/RamDiskCatalogLoadFile.asm"
#include"catalog/RamDiskCatalogGetFreeBytes.asm"
#include"catalog/RamDiskCatalogClear.asm"

#endif
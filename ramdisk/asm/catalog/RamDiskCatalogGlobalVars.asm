; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

; ----------------------------------------------------------
; The catalogue occupies addresses $C000-$EBFF in ; physical
; RAM bank 7, starting at $EBFF and growing downwards.
;
; Each entry is 16 bytes as follows:
; 00-01 = filename length
; 02-0B = filename
; 0C-0D = ram disk address of data
; 0E-0F = data length
; ----------------------------------------------------------

#ifndef __LIBRARY_RAMDISK_CATALOG_GLOBAL_VARS_ASM__
#define __LIBRARY_RAMDISK_CATALOG_GLOBAL_VARS_ASM__

RamDiskCatalogEntrySize  equ $10
RamDiskCatalogStartAddr  equ $EBFF
RamDiskCatalogFirstEntry equ RamDiskCatalogStartAddr - RamDiskCatalogEntrySize

RamDiskCatalogRamDiskOffset  equ $0C
RamDiskCatalogFileSizeOffset equ $0E

; ----------------------------------------------------------
; Catalog entries stored 
; ----------------------------------------------------------
RamDiskFreeCatalogEntryPtr:
dw RamDiskCatalogFirstEntry
#endif
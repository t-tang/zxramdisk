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

#define D_ERR_OK                  $00
#define D_ERR_OUT_OF_MEMORY       $04
#define D_ERR_INVALID_ARGUMENT    $0A
#define D_ERR_INVALID_FILE_NAME   $0E
#define D_ERR_FILE_ALREADY_EXISTS $20
#define D_ERR_FILE_DOES_NOT_EXIST $23

RamDiskCatalogEntrySize  equ $10
RamDiskCatalogStartAddr  equ $EBFF
RamDiskCatalogFirstEntry equ RamDiskCatalogStartAddr - RamDiskCatalogEntrySize

RamDiskCatalogRamDiskOffset  equ $0C
RamDiskCatalogFileSizeOffset equ $0E

#ifndef RamDiskCatalogMaxIndexEntries
RamDiskCatalogMaxIndexEntries equ (RamDiskCatalogStartAddr - $C000) / RamDiskCatalogEntrySize
#endif

; ----------------------------------------------------------
; Catalog entries stored 
; ----------------------------------------------------------
RamDiskFreeCatalogEntryPtr:        dw RamDiskCatalogFirstEntry
RamDiskCatalogFreeRamDiskAddress:  dw $0000
#endif
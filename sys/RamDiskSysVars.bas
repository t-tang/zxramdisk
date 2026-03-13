#define RAMDISK_FIRST_CATALOG_ENTRY_PTR $EBEC
#define RAMDISK_BANK_M $5b5c    ' 128k system variable for saving the bank

Sub fastcall RamDiskSysVars()
asm
;The catalogue can occupy addresses $C000-$EBFF in physical RAM bank 7,
;starting at $EBFF and growing downwards.

;----------------------------------------------------------------------
;Number of bytes free in RAM disk (3 bytes, 17 bit, LSB first).
RamDiskSFSPACE:
    dw $ffff    ; technically max size is $4000 * 4 = $10000
;----------------------------------------------------------------------

;----------------------------------------------------------------------
; End of RAM disk catalogue marker.
; Pointer to first empty catalogue entry in logical bank $05 (phys $07)
RamDiskFreeCatalogEntryPtr
    dw RAMDISK_FIRST_CATALOG_ENTRY_PTR

;----------------------------------------------------------------------
; $00 - Filename (10 bytes)
; $0a - length (2 bytes)
; $0c - start address (linear) in the ram disk
;----------------------------------------------------------------------

end asm
End Sub

Function Fastcall RamDiskFreeCatalogEntryAddr() as uinteger
Asm
    ld hl, (RamDiskFreeCatalogEntryPtr)
End Asm
End Function
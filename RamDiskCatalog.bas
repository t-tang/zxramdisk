
Function Fastcall RamDiskWriteCatalogEntry(filename as string, filelen as uinteger) as uinteger
Asm
    pop af      ; return address to ZX Basic
    pop bc      ; bc = length
    push af     ; restore return address

    ex de,hl    ; de = filename

    #include "asm/RamDiskWriteCatalogEntry.asm"

End Asm
End Function
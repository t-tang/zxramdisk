Function HasMemoryBanks() as ubyte
    RamDiskBankSwitch(0)
    poke $C000,$ff
    RamDiskBankSwitch(5)
    poke $C000,$00
    RamDiskBankSwitch(0)
    dim hasMemoryBanks as ubyte = peek($c000) = $ff
    RamDiskBankSwitch(5)
    return hasMemoryBanks
End Function
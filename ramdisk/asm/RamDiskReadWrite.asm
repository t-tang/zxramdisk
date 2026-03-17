; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAM_DISK_READ_WRITE_ASM__
#define __LIBRARY_RAM_DISK_READ_WRITE_ASM__

#include"readwrite/RamDiskTransferGlobalVars.asm"

#include"readwrite/RamDiskBankSwitch.asm"
#include"readwrite/RamDiskRebaseAddress.asm"
#include"readwrite/RamDiskBankSwitchToAddress.asm"

#include"readwrite/RamDiskCalcNonShadowedByteCount.asm"
#include"readwrite/RamDiskTransferNonShadowedBytes.asm"

#include"readwrite/RamDiskWriteShadowedBytes.asm"
#include"readwrite/RamDiskReadShadowedBytes.asm"

#include"readwrite/RamDiskNextChunk.asm"
#include"readwrite/RamDiskTransferChunk.asm"

#include"readwrite/RamDiskTransferMemory.asm"
#endif
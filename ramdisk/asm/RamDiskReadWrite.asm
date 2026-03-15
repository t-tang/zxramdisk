; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

#ifndef __LIBRARY_RAM_DISK_READ_WRITE_ASM__
#define __LIBRARY_RAM_DISK_READ_WRITE_ASM__

#include"transfer/RamDiskTransferGlobalVars.asm"

#include"transfer/RamDiskBankSwitch.asm"
#include"transfer/RamDiskRebaseAddress.asm"
#include"transfer/RamDiskBankSwitchToAddress.asm"

#include"transfer/RamDiskCalcNonShadowedByteCount.asm"
#include"transfer/RamDiskTransferNonShadowedBytes.asm"

#include"transfer/RamDiskWriteShadowedBytes.asm"
#include"transfer/RamDiskReadShadowedBytes.asm"

#include"transfer/RamDiskNextChunk.asm"
#include"transfer/RamDiskTransferChunk.asm"

#include"transfer/RamDiskTransferMemory.asm"
#endif
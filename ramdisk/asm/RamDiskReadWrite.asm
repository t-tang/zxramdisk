; ----------------------------------------------------------
; This file is released under the MIT License
;
; Copyleft (k) 2026
; by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
; ----------------------------------------------------------

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
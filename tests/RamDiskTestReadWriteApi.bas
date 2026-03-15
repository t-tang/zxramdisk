#include"../ramdisk/bas/RamDiskReadWriteApi.bas"

Load "TestScr.scr" Code $C000
RamDiskWrite($C000,$C000,6912)
RamDiskRead($4000,$C000,6912)
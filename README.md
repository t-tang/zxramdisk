# ZX RamDisk 
This is a Ram Disk implementation for Boriel Basic currently under development. There are two Apis available, one which is analogous to the original Load! and Save! commands and a Read-Write Api which is lower level and treats the Ram Disk area as a linear address space.

### Catalog Api
The Catalog Api is analgous to the original Load! and Save! commands

 * RamDiskSave("aFilename", mainMemoryAddress, byteLength)
 * RamDiskLoad("aFilename", mainMemoryAddress)

 * RamDiskIndexSize()
 * RamDiskFilename(index)
 * RamDiskFileSize(index)

 * RamDiskFreeBytes()
 * RamDiskClear()

#include"ramdisk/bas/RamDiskCatalogApi.bas" to use the read-write API

### Read-Write Api

The read-write API treats the Ram Disk as a linear addresseable memory space
  * RamDiskWrite(mainMemoryAddress, ramDiskAddress, byteLength)
  * RamDiskRead (mainMemoryAddress, ramDiskAddress, byteLength)


#include"ramdisk/bas/RamDiskReadWriteApi.bas" to use the read-write API

### Technical Notes
For those who are interested in the implementation, addresses in the Ram Disk are represented as a regular address in the range $0000 to $FFFF. The top two bits of the Ram Disk address identify a logical memory bank from 0 to 3 which is then mapped onto physical memory banks 1,3,4 and 6

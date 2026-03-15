# ZX RamDisk 
This is a Ram Disk implementation for Boriel Basic currently under development


The current API allow reading and writing to the Ram Disk as follows:
  * RamDiskWrite(sourceAddress, ramDiskAddress, byteLength)
  * RamDiskRead (sourceAddress, ramDiskAddress, byteLength)


#include"RamDiskReadWriteApi.bas" to use the API

### Technical Notes
For those who are interested in the implementation, addresses in the Ram Disk are represented as a regular address in the range $0000 to $FFFF. The top two bits of the Ram Disk address identify a logical memory bank from 0 to 3 which is then mapped onto physical memory banks 1,3,4 and 6

 

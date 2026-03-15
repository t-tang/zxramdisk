@ECHO OFF
c:\portable\zx\zxbasic\zxbc.exe          ^
   -M memory.txt -O2                     ^
   --output-format=tap --autorun --BASIC ^
   -W160 -W170 -W190 -W150               ^
   --debug-memory ^
   tests/RamDiskTests.bas

   rem ramdisk/bas/RamDiskReadWrite.bas

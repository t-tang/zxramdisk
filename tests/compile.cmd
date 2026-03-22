@ECHO OFF
c:\portable\zx\zxbasic\zxbc.exe          ^
   -M memory.txt -O0                     ^
   --output-format=tap --autorun --BASIC ^
   -W160 -W170 -W190 -W150               ^
   -D RamDiskCatalogMaxIndexEntries=4    ^
   --append-binary src/Test2.scr         ^
   src/RamDiskTestCatalog.bas


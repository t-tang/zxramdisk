@ECHO OFF

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   --append-binary bin/Test.scr          ^
   RamDiskReadWriteTests.bas

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   -D RamDiskCatalogMaxIndexEntries=4    ^
   --append-binary bin/Test2.scr         ^
   RamDiskCatalogTests.bas

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   MixedApi1.bas

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   MixedApi2.bas


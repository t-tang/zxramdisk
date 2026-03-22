@ECHO OFF

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   --append-binary tests/bin/Test.scr    ^
   tests/RamDiskReadWriteTests.bas

c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -O2 -W160 -W170 -W190 -W150           ^
   -D RamDiskCatalogMaxIndexEntries=4    ^
   --append-binary tests/bin/Test2.scr   ^
   tests/RamDiskCatalogTests.bas

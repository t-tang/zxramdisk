@ECHO OFF
rem ----------------------------------------------------------
rem This file is released under the MIT License
rem
rem Copyleft (k) 2026
rem by Tat Tang (a.k.a choisum) <https://github.com/t-tang>
rem ----------------------------------------------------------

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


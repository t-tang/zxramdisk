@ECHO OFF
c:\portable\zx\zxbasic\zxbc.exe          ^
   --output-format=tap --autorun --BASIC ^
   -W160 -W170 -W190 -W150               ^
   --append-binary src/Test.scr          ^
   RamDiskTests.bas


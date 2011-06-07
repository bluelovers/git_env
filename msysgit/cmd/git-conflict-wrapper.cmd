rem %1 BASE
rem %2 REMOTE
rem %3 LOCAL
rem %4 source

rem UltraCompare
rem call "D:/Program Files (Portable)/UltraEdit/UltraCompare Professional.exe" -3 %1 %2 %3 -o %4

@call "D:/Program Files (Portable)/DiffMerge/diffmerge" -result %4 %2 %1  %3

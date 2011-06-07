#!/bin/sh

# diff is called by git with 7 parameters:
#  path old-file old-hex old-mode new-file new-hex new-mode

"C:/Program Files/TortoiseGit/bin/TortoiseMerge.exe" -base:"$2" -theirs:"$5"

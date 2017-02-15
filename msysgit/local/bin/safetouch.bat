@echo off
if %1.==. goto end
if exist %1 goto end

<nul (set/p z=) >%1

echo %1 touched!
:end
@echo off
wla-65816 -o MAIN.ASM MAIN.OBJ
wlalink -vs LINKFILE.L OUTPUT.SFC
del /q MAIN.OBJ
del /q OUTPUT.sym
echo Done. Press any key to close.
pause>NUL
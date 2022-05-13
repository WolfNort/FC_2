.\win_flex.exe calc.l  
.\win_bison.exe -d calc.y
gcc .\lex.yy.c .\calc.c .\calc.h .\calc.tab.c .\calc.tab.h  -o calc
cmd /c 'calc.exe <config.in'
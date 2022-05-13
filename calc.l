%{
#ifdef __unix__
// __unix__ is usually defined by compilers targeting Unix systems
#include "y.tab.h"
#elif defined _WIN32
// _Win32 is usually defined by compilers targeting 32 or 64 bit Windows systems
#include "calc.tab.h"
#endif
#include "calc.h"

int yylex();
%}
%option yylineno
%option  noyywrap
%%
\/\/(.*)                {;}
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {;}
"-"                     {return minus;}
"<<"				   	{return print;}
"exit"				   	{return exit_command;}
[a-z]				   	{yylval.id = yytext[0]; return term;}
[A-Z]				   	{yylval.id = yytext[0]; return variable;}
[0-9]+                 	{
                            
                            int len = strlen(yytext);
                            if((len > 1)&&(yytext[0] == 48))
                                PrintError("Incorrect number");
                            else
                                yylval.num = atoi(yytext); return number;
                        }
[ \t\r]                	{;}
[\n]                    {line_counter++; return next;}
<<EOF>>                 {line_counter++; return end;}
[*+^=;())(]           	{return yytext[0];}
.                      	{ECHO; yyerror (yytext);}


%%




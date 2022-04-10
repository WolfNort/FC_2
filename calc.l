%{
#include "calc.tab.h"
void yyerror (char *s);
int yylex();
%}
%%


"<<"				   	{return print;}
"exit"				   	{return exit_command;}
[a-z]				   	{yylval.id = yytext[0]; return term;}
[A-Z]				   	{yylval.id = yytext[0]; return variable;}
[0-9]+                 	{yylval.num = atoi(yytext); return number;}
[ \t\n]                	;
[*-+^=;())(]           	{return yytext[0];}
.                      	{ECHO; yyerror ("unexpected character");}
%%

int yywrap (void) {return 1;}


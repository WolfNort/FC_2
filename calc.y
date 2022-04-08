%{
#include "calc.h"
void yyerror (char *s);
int yylex();
%}

%union {
	int 	num; 
	int 	*piece_formula;
	char 	id; 
	struct 	Exp *formula
	}         /* Yacc definitions */

%start line
%token print
%token exit_command

%token <num> number
%type <piece_formula> monom
%token <id> variable term 
%type <formula> polynom
%type <num> line 
%type <id> assignment

%left '+'

%%

/* descriptions of expected inputs     corresponding actions (in C) */
line		: assignment ';'				
				{
					;
				}
			| line assignment ';'			
				{
					;
				}
			| print variable ';' 			
				{
					int idx = CharSymbolToIndex($2);
					//PrintPolynom(idx);
				}
			| line print variable	';' 	
				{
					int idx = CharSymbolToIndex($3);
					//PrintPolynom(idx);
				}
				;

assignment	: variable '=' polynom			
				{
					int idx = CharSymbolToIndex($1);
					AssignmentPolynom($1, $3);
					PrintPolynom($3);
				}
			;

polynom 	:'(' polynom ')'				
				{	
					$$ = $2;	
				}
 			| polynom '+' polynom			
 				{
 					//$$ = CalculateMinusPlus($1, $3, 0);	
 					;
 				}
 			| monom 							
 				{	
					//MonomialPrint($1);
 					$$ = PolynomInit($1);
 					AddMonom($$, $1, 0);
 					//PrintPolynom($$);
 				}
 			;

monom 		: term monom						
				{
					//printf("%c", $1);
 					$$ = MonomialInit($1, 1, 1);
 					$$ = MonomialSummary($$, $2);
 				}	
			| number 						
				{
					//$$ = PolyInit($1, 1, 0, 0);
					;
				}
			| variable		 				
				{
					;
				}
 			| term	 						
 				{
	 				//printf("%c\n", $1);
 					$$ = MonomialInit($1, 1, 1);
					//AddMonom($$, monom, 0);
 				}	
 			;

/*line    : assignment ';'		{;} //непосредственно выражение
//		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print expr ';'		{PrintPolynom($2);} //на вход идентификато
		| line assignment ';'	{;}
		| line print expr ';'	{PrintPolynom($3);}
//		| line exit_command ';'	{exit(EXIT_SUCCESS);}
        ;

assignment : identifier '=' expr  { updateSymbolVal($1,$3); }
		;

expr    : term                  {$$ = $1;}
//       	| expr '+' term          {$$ = $1 + $3;}
//       	| expr '-' term          {$$ = $1 - $3;}
       	;
term   	: number                {$$ = SetNumber($$, $1, NULL, 0);}
		| element				{$$ = SetSymbol($$, $1, 1);}
		| identifier			{$$ = symbolVal($1);} 

        ;*/

%%                     /* C code */



int main (void) {
	/* init symbol table */
	int i;
	symbols = (struct Exp*)calloc(COUNT_POLINOM, sizeof(struct Exp));
	
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


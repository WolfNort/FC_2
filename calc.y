%{
#include "calc.c.h"
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

%left '+' '-'

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
				}
			| line print variable	';' 	
				{
					int idx = CharSymbolToIndex($3);
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
			| polynom '-' polynom
				{
					PolynomMinus($1, $3);
					;
				}
 			| polynom '+' polynom			
 				{
					PolynomSummary($1, $3); 					
 				}
 			| monom 							
 				{	
 					$$ = PolynomInit($1);
 					AddMonom($$, $1, 0);
 				}
 			;

monom 		: term monom						
				{
 					$$ = MonomialInit($1, 1, 1);
 					$$ = MonomialMultipl($$, $2);
 				}	
			| number 						
				{
					$$ = MonomialInit(0, 1, $1);
					;
				}
			| number monom
				{
					$$ = MonomialInit(0, 1, $1);
					$$ = MonomialMultipl($$, $2);
				}
			| variable		 				
				{
					;
				}
 			| term	 						
 				{
 					$$ = MonomialInit($1, 1, 1);
 				}	
 			;

%%                     /* C code */

int main (void) {
	/* init symbol table */
	int i;
	symbols = (struct Exp*)calloc(COUNT_POLINOM, sizeof(struct Exp));
	
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


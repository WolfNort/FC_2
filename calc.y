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
%token minus

%token <num> number

%token <id> variable  
%token <id> term

%type <formula> polynom  
%type <formula> brackets
%type <formula> variable_exp

%type <num> line

%type <piece_formula> monom 
%type <piece_formula> symbol

%type <id> assignment

%left '+' 
%left minus
%left NEG
%left '^'
%right '*'
%left '(' ')'

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

polynom 	: minus polynom %prec NEG
				{
					printf("'-' polynom\n");
					$$ = PolynomInit();
					PolynomMinus($$, $2);
				} 
			| brackets
				{
					$$ =$1;
				}
			| brackets brackets %prec '*'
				{
					printf("brackets brackets prec '*'\n");
					$$ = PolynomMultiple($1, $2);

				}
			| polynom minus polynom
				{
					printf("polynom '-' polynom\n");
					PolynomMinus($1, $3);
					;
				}
 			| polynom '+' polynom			
 				{
					printf("polynom '+' polynom\n");
					PolynomSummary($1, $3); 					
 				}

			| polynom '*' polynom
				{
					printf("polynom '*' polynom\n");
					$$ = PolynomMultiple($1, $3);
				}
			| variable_exp
				{
					;
				}
 			| monom 							
 				{	
					printf("monom\n");
 					$$ = PolynomInit();
 					AddMonom($$, $1, 0);
 				}
 			;

brackets 	: '(' polynom ')'
				{
					$$ = $2;
				}
			| brackets '^' number
				{
					$$ = PolynomPower($1, $3);;
				}
			;

 monom 		: symbol
				{
					$$ = $1;
				}
			| symbol monom
				{
					$$ = MonomialMultipl($1, $2);;
				}
			| symbol '^' number
				{
					MonomlPower($1, $3);
				}

 			;

symbol		: number
				{
					$$ = MonomialInit(0, 1, $1);
					;
				}
			| term
 				{
 					$$ = MonomialInit($1, 1, 1);
 				}

variable_exp: variable
				{
					$$ = GetPolynom($1);
				}			



%%                     /* C code */

int main (void) {
	/* init symbol table */
	int i;
	symbols = (struct Exp*)calloc(COUNT_POLINOM, sizeof(struct Exp));
	
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


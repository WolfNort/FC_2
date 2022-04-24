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

%start begin
%token print
%token exit_command
%token minus



%token <num> number

%token <id> variable  
%token <id> term

%type <formula> polynom  
%type <formula> brackets

%type <num> power
%type <num> begin 
%type <num> line 
%type <num> errors

%type <piece_formula> monom 
%type <piece_formula> symbol

%type <id> assignment

%left '+' 
%left NEG
%left minus
%left '*'
%right '^'
%left '(' ')'


%%
begin 		: begin line 
				{
					;
				}
			| line 
				{
					;
				}

			;
/* descriptigit ons of expected inputs     corresponding actions (in C) */
line		: assignment ';'	
				{
					;
				}

			| print variable ';'
				{
					int idx = CharSymbolToIndex($2);
					PrintPolynom(&symbols[idx]);
				}

			// | errors
			// {
			// 	yyerror("Error initialization");
			// }

			;

assignment	: variable '=' polynom 		
				{
					printf("variable '=' polynom\n");
					int idx = CharSymbolToIndex($1);
					AssignmentPolynom($1, $3);
				}
			| errors
				{
					;
				}
			;
errors 		: 
			'\n'
				{
					;
				}
			| variable '='
				{
					yyerror("Error initialization");
					exit(-1);
				}
			
			;

polynom 	: minus polynom %prec NEG
				{
					printf("minus polynom prec NEG\n");
					$$ = PolynomInit();
					PolynomMinus($$, $2);
				} 
			| brackets
				{
					printf("brackets\n");
					$$ =$1;
				}
			| brackets brackets %prec '*'
				{
					printf("brackets brackets prec '*'\n");
					$$ = PolynomMultiple($1, $2);
				}
			| polynom minus polynom
				{
					printf("polynom minus polynom\n");
					PolynomMinus($1, $3);
				}
 			| polynom '+' polynom			
 				{
					printf(" polynom '+' polynom\n");
					PolynomSummary($1, $3); 				
 				}
			| polynom '*' polynom
				{
					printf("polynom '*' polynom\n");
					$$ = PolynomMultiple($1, $3);
				}
			| variable
				{
					printf("variable\n");
					$$ = GetPolynom($1);;
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
					printf("'(' polynom ')'\n");
					$$ = $2;
				}
			| brackets '^' power
				{
					printf("brackets '^' power\n");
					$$ = PolynomPower($1, $3);;
				}
			;

 monom 		: symbol
				{
					printf("symbol\n");
					$$ = $1;
				}
			| symbol monom
				{
					printf("symbol monom\n");
					$$ = MonomialMultipl($1, $2);;
				}
 			;

power 		: number
				{
					printf("number\n");
					$$ = $1;
				}
			| power '+' power
				{
					printf("power '+' power\n");
					$$ = $1 + $3;
				}
			| power minus power
				{
					printf("power minus power\n");
					$$ = $1 - $3;
				}
			| power '*' power
				{
					printf("power '*' power\n");
					$$ = $1 * $3;
				}
			| power '^' power 
				{
					printf("power %d '^' %d power \n", $1, $3);
					$$ = pow($1, $3);
				}
			| minus power %prec NEG	
				{
					printf("minus power prec NEG\n");
					$$ = 0 - $2;
				}
			| '(' power ')'
				{
					printf("'(' power ')'\n");
					$$ = $2;
				}
			;

symbol		: number
				{
					printf("number - %d\n", $1);
					$$ = MonomialInit(0, 1, $1);
					;
				}
			| term
 				{
					printf("term\n");
 					$$ = MonomialInit($1, 1, 1);
 				}
			| symbol '^' power
				{
					printf("symbol '^' power\n");
					MonomlPower($1, $3);
				}

%%                     /* C code */


int main (void) {
	/* init symbol table */
	int i;
	symbols = (struct Exp*)calloc(COUNT_POLINOM, sizeof(struct Exp));
	
	return yyparse ();
}


void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


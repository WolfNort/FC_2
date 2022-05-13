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

%start begin
%token print
%token exit_command
%token minus
%token next
%token end

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
begin 		: line next begin
				{
					;
				}
			| line next
				{
					;
				}
				
			| next begin
				{
					;
				}
			| line end
				{
					exit(1);
				}
			;

line		: assignment ';'	
				{
					;
				}

			| print variable ';'
				{
					int idx = CharSymbolToIndex($2);
					PrintPolynom(idx);
				}
			| assignment 
				{
					PrintError("Forgot in assignment ';'");
				}
			| print variable 
				{
					PrintError("Forgot in error ';'");
				}
			;

assignment	: variable '=' polynom 		
				{
					int idx = CharSymbolToIndex($1);
					AssignmentPolynom($1, $3);
				}
			| errors
				{
					;
				}
			;
errors 		: variable '='
				{
					PrintError("Error initialization");
					exit(-1);
				}
			
			;

polynom 	: minus polynom %prec NEG
				{
					$$ = PolynomInit();
					PolynomMinus($$, $2);
				} 
			| brackets
				{
					$$ =$1;
				}
			| brackets brackets %prec '*'
				{
					$$ = PolynomMultiple($1, $2);
				}
			| polynom minus polynom
				{
					PolynomMinus($1, $3);
				}
 			| polynom '+' polynom			
 				{
					PolynomSummary($1, $3); 				
 				}
			| polynom '*' polynom
				{
					$$ = PolynomMultiple($1, $3);
				}
			| variable
				{
					$$ = GetPolynom($1);
				}
			| variable '^' power
				{
					$$ = GetPolynom($1);
					$$ = PolynomPower($$, $3);
				}
 			| monom 							
 				{	
 					$$ = PolynomInit();
 					AddMonom($$, $1, 0);
 				}
 			;

brackets 	: '(' polynom ')'
				{
					$$ = $2;
				}
			| brackets '^' power
				{
					$$ = PolynomPower($1, $3);
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
 			;

power 		: number
				{
					$$ = $1;
				}
			| power '+' power
				{
					$$ = $1 + $3;
				}
			| power minus power
				{
					$$ = $1 - $3;
				}
			| power '*' power
				{
					$$ = MultipleNumbers($1,$3);
				}
			| power '^' power 
				{
					$$ = Pow($1, $3);
				}
			| minus power %prec NEG	
				{
					PrintError("Negative power not supposed");
					$$ = 0 - $2;
				}
			| '(' power ')'
				{
					$$ = $2;
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
			| print
				{
					PrintError("Incorrect assignment");
				}
			| symbol '^' power
				{
					//printf("symbol '^' power\n");
					MonomlPower($1, $3);
				}

%%                     /* C code */


int main (void) {
	/* init symbol table */
	int i;
	
	
	return yyparse ();
}





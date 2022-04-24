#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>
#include <errno.h>


#define COUNT_MONOM 100
#define COUNT_POLINOM 26
#define SIZE_MONOM (COUNT_POLINOM + 1)
#define MINUS 1
#define PLUS 0
#define MULTIPL 2

struct Exp
{
	int size;
	char id_variable;
	int **structure;

};

struct Exp *symbols;

//other
void ZeroStruct(struct Exp *new_polynom);
int* CreateList();
char IntSymbolToChar(int token);
int CharSymbolToIndex(char token);
void PrintMatrix(struct Exp* polynom);

//monomial
int SearchMonom(int **structure_poly_1, int *monom_poly_2);
void AddMonom(struct Exp *polynom, int *monom, int idx);
void MinusMonom(struct Exp *polynom, int *monom, int idx);
int* MonomialInit(char symbol, int degree, int coef);
int* MonomialMultipl(int *monom_1, int *monom_2);
void MonomialPrint(int *result_monom);
void MonomlPower(int* monom, int power);

//polynomial
void AssignmentPolynom(char variable,struct Exp *polynom);
void PolynomSummary(struct Exp *polynom_1, struct Exp *polynom_2);
void PolynomMinus(struct Exp *polynom_1, struct Exp *polynom_2);
struct Exp* PolynomMultiple(struct Exp *polynom_1, struct Exp *polynom_2);
struct Exp* PolynomPower(struct Exp* polynom, int power);
void PrintPolynom(struct Exp* polynom);
struct Exp* PolynomInit();






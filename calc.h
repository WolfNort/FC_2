#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


#define COUNT_MONOM 100
#define COUNT_POLINOM 26
#define SIZE_MONOM (COUNT_POLINOM + 1)
#define PLUS 0
#define MINUS 1
#define MULTIPL 2

int CharSymbolToIndex(char token);
char IntSymbolToChar(int token);
void MonomialPrint(int *result_monom);


struct Exp
{
	int size;
	char id_variable;
	int **structure;

};

struct Exp *symbols;

void ZeroStruct(struct Exp *new_polynom)
{
	new_polynom->size = 0;
	new_polynom->id_variable = 1;

	for(int i = 0; i < COUNT_MONOM; i++)
	{
		for(int j = 1; j < SIZE_MONOM; j++)
			new_polynom->structure[i][j] = 0;
	}
}

int SearchMonom(int **structure_poly_1, int *monom_poly_2)
{
	if(monom_poly_2 != NULL || structure_poly_1 != NULL)
	{
		for(int i = 0; i < COUNT_MONOM; i++)
		{
			//если коэффициент не равен 0
			if(structure_poly_1[i][0] != 0) 
			{
				//в нулевом лежит коэффициент, а они могут быть разными 
				for(int j = 1; j < SIZE_MONOM; i++) 
				{
					if(structure_poly_1[i][j] != monom_poly_2[j])
						continue;
					if(j == SIZE_MONOM - 1) 
						return i;
				}
				// если мнономы оказались одинаковыми 

			}
			else 
				return i;
		}
	}
	else
		{
			printf("In SearchMonom() error memory");
			exit(-1);
		}
}

void AddMonom(struct Exp *polynom, int *monom, int idx)
{
	for(int i = 0; i < SIZE_MONOM; i++)
	{
		printf("%d", monom[i]);
		polynom->structure[idx][i] += monom[i];
	}
}

void AssignmentPolynom(char variable,struct Exp *polynom)
{
	polynom->id_variable = variable;

	int symbols_idx = CharSymbolToIndex(variable);
	symbols[symbols_idx] = *polynom;
}

void PolynomSummary(struct Exp *polynom_1, struct Exp *polynom_2)
{
	int idx_monom_in_polynom_1 = 0;

	for(int i = 0; i < COUNT_MONOM; i++)
	{
		idx_monom_in_polynom_1 = SearchMonom(polynom_1->structure, polynom_2->structure[i]);
		AddMonom(polynom_1, polynom_2->structure[i], idx_monom_in_polynom_1);
	}
}

void PrintPolynom(struct Exp* polynom)
{
	int i=0, j=0;
	char term;
	//printf("[PrintPolynom] ");
	for(i = 0; i < COUNT_MONOM; i++)
	{
		for(j = 0; j < SIZE_MONOM; j++)
		{
			if(polynom->structure[i][j] != 0)
			{
				term = IntSymbolToChar(j);
				printf("%c");
			}
		}
		if(polynom->structure[i][j] != 0)
			printf(" + ");
	}
	printf("\n");
}

struct Exp* PolynomInit(int * monom)
{
	struct Exp *new_polynom = (struct Exp*)malloc(sizeof(struct Exp));
	new_polynom->structure = (int **)malloc(COUNT_MONOM * sizeof(int*));
	
	for(int i = 0; i < COUNT_MONOM; i++)
		new_polynom->structure[i] = (int*)malloc(SIZE_MONOM * sizeof(int));
	
	ZeroStruct(new_polynom);
	return new_polynom;

}

/*struct Exp* PolyInit(int number, int size, int degree, char variable)
{

	struct Exp *new_polynom = (struct Exp*)malloc(sizeof(struct Exp));
	ZeroStruct(new_polynom);
	//memset(&new_polynom, 0, sizeof(struct Exp));
	//printf("element 2.0 - %c\n", variable);
	if(size != 0)
	{
		if(variable != 0)
			new_polynom->id_variable = variable;
	
		new_polynom->size = size;
		//new_polynom->structure = (int*)malloc(MAX_DEGREES);
		new_polynom->structure[degree] = number;
	}
	//printf("hey\n");
	return new_polynom;
}


void PrintPolynom(int idx)
{
	int count = 0;
	for(int i = 0; i < MAX_ELEMENTS; i++)
	{
		if(symbols[idx].structure[i] != 0)
		{
			//printf("size - %d\n", symbols[idx].size);
			//printf("index - %d\n",symbols[idx].structure[i]);
			//printf("char - %d\n", symbols[idx].id_variable);
			count ++;
			if(symbols[idx].structure[i] != 1)
				printf("%d", symbols[idx].structure[i]);

			if(i >= 1 && symbols[idx].id_variable != 0)
				printf("%c", symbols[idx].id_variable);
			if(i > 1)
				printf("^%d", i);
			if(count != symbols[idx].size)
				printf("+");
		}
		
	}
	printf("\n");
}

struct Exp* CalculateMinusPlus(struct Exp* exp_1, struct Exp* exp_2, int operation)
{
	struct Exp *result = (struct Exp*)malloc(sizeof(struct Exp));
	ZeroStruct(result);
	if(exp_1->id_variable > 0 || exp_2->id_variable > 0)
	{
		result->id_variable = exp_1->id_variable;
		result->id_variable = exp_2->id_variable;
	}
	if(operation == PLUS)
	{
		for(int i = 0; i < MAX_ELEMENTS; i++)
		{
			if(exp_1->structure[i] != 0)
				result->structure[i] += exp_1->structure[i];
			if(exp_2->structure[i] != 0)
				result->structure[i] += exp_2->structure[i];
			if(result->structure[i] != 0)
				result->size +=1 ;
		}
	}
	else if(operation == MINUS)
	{
		for(int i = 0; i < MAX_ELEMENTS; i++)
		{
			if(exp_1->structure[i] != 0)
				result->structure[i] -= exp_1->structure[i];
			if(exp_2->structure[i] != 0)
				result->structure[i] -= exp_2->structure[i];
			if(result->structure[i] != 0)
				result->size +=1 ;
		}
	}
	return result;

}*/

int* CreateList()
{
	int *mass = (int*)malloc(SIZE_MONOM * sizeof(int));
	for(int i = 0; i <= SIZE_MONOM; i++)
		mass[i] = 0;
	return mass;
}

int* MonomialInit(char symbol, int degree, int coef)
{
	//printf("init\n");
	int idx = 0;

	int *new_monomial =	CreateList();

	if(symbol != 0)
	{
		idx = CharSymbolToIndex(symbol) + 1;
		//printf("[init] %d\n", idx);
		new_monomial[idx] = degree;
	}

	new_monomial[0] = coef;
	return new_monomial;
}

int* MonomialSummary(int *monom_1, int *monom_2)
{
	int *result = MonomialInit(0, 0, 1);
	for(int i = 1; i <= SIZE_MONOM; i++)
	{
		result[i] = monom_1[i] + monom_2[i];
		
	}
	return result;
}

void MonomialPrint(int *result_monom)
{
	//printf("hey, i'm here. In the print\n");
	char symbol = '\0';
	for(int i = 1; i <= SIZE_MONOM; i++)
	{

		if(result_monom[i] != 0)
		{
			//printf("[multiple] %d\n", result_monom[i]);
			symbol = IntSymbolToChar(i - 1);
			printf("%c", symbol);
			//if(result_monom[i] > 1)
			//	printf("^%d",result_monom[i]);
		}
	}
	printf("\n");
}

/*struct Exp* SetNumber(struct Exp *expr, int num,char symbol, int degree)
{
	expr = (struct Exp*)malloc(sizeof(struct Exp));
	//expr->structure = (int*)calloc(MAX_DEGREES, sizeof(int));
	expr->id_variable = symbol;
	expr->structure[degree] = num;
	//printf("SetSymbol - %d\n", expr->structure[degree]);
	return expr;
}
*/
char IntSymbolToChar(int token)
{
	char symbol = '\0';
	symbol = token + 'a';
	return symbol;
}

int CharSymbolToIndex(char token)
{
	int idx = -1;
	if(islower(token)) 
		idx = token - 'a';
	
	else if(isupper(token)) 
		idx = token - 'A';

	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = CharSymbolToIndex(symbol);
	//return symbols[bucket];
	return 0;
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int* val)
{
	int bucket = CharSymbolToIndex(symbol);
	//symbols[bucket].structure = val;
}
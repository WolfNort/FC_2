#include "calc.h"

void ZeroStruct(struct Exp *new_polynom)
{
	new_polynom->size = 0;
	new_polynom->id_variable = 1;

	for(int i = 0; i < COUNT_MONOM; i++)
	{
		for(int j = 0; j < SIZE_MONOM; j++)
			new_polynom->structure[i][j] = 0;
	}
}

int SearchMonom(int **structure_poly_1, int *monom_poly_2)
{
	if(monom_poly_2 != NULL || structure_poly_1 != NULL)
	{
		for(int i = 0; i < COUNT_MONOM; i++)
		{
			//if there is a monomial
			if(structure_poly_1[i][0] != 0) 
			{
				//we start from 1, since the coefficient leads to 0
				for(int j = 1; j < SIZE_MONOM; j++) 
				{
					if(structure_poly_1[i][j] != monom_poly_2[j])
						break;
					//if the monomials are the same
					if(j == SIZE_MONOM - 1) 
						return i;
				}
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
	//add a new monomial
	if(polynom->structure[idx][0] == 0)
	{
		for(int i = 1; i < SIZE_MONOM; i++)
			polynom->structure[idx][i] += monom[i];
	}
	//the monomials are the same, you need to change the coeff
	polynom->structure[idx][0] += monom[0];
}

void DeleteMonom(struct Exp *polynom, int *monom, int idx)
{
	//minus a new monomial
	if(polynom->structure[idx][0] != monom[0])
	{
		if(polynom->structure[idx][0] == 0)
		{
			for(int i = 1; i < SIZE_MONOM; i++)
				polynom->structure[idx][i] += monom[i];
		}
		polynom->structure[idx][0] -= monom[0];
	}
	else
	{
		for(int i = 0; i < SIZE_MONOM; i++)
			polynom->structure[idx][i] = 0;
	}
	//the monomials are the same, you need to change the coeff
	
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
		
		if(polynom_2->structure[i + 1][0] == 0)
			break;
	}
}

void PolynomMinus(struct Exp *polynom_1, struct Exp *polynom_2)
{
 	int idx_monom_in_polynom_1 = 0;

 	for(int i = 0; i < COUNT_MONOM; i++)
 	{
 		idx_monom_in_polynom_1 = SearchMonom(polynom_1->structure, polynom_2->structure[i]);
 		DeleteMonom(polynom_1, polynom_2->structure[i], idx_monom_in_polynom_1);
		
 		if(polynom_2->structure[i + 1][0] == 0)
 			break;
	}
}

void PrintPolynom(struct Exp* polynom)
{
	int i=0, j=0;
	char term;
	printf("%c = ", polynom->id_variable);
	for(i = 0; i < COUNT_MONOM; i++)
	{
		if(polynom->structure[i][0] != 0)
		{
			if(polynom->structure[i][0] > 1 || polynom->structure[i][0] < 0)
			{
				if(polynom->structure[i][0] == -1)
					printf("-");
				else
					printf("%d", polynom->structure[i][0]);
			}
		}
		else 
			break;
		
		for(j = 1; j < SIZE_MONOM; j++)
		{
			//sequentially walked along the monomial
			if(polynom->structure[i][j] != 0) 
			{
				term = IntSymbolToChar(j);
				printf("%c", term);
			}
		}
		//does the next monomial exist?
		//and overflow limit
		if((polynom->structure[i + 1][0] != 0) && (i < COUNT_MONOM - 1)) 
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

int* CreateList()
{
	int *mass = (int*)malloc(SIZE_MONOM * sizeof(int));
	for(int i = 0; i <= SIZE_MONOM; i++)
		mass[i] = 0;
	return mass;
}

int* MonomialInit(char symbol, int degree, int coef)
{
	int idx = 0;

	int *new_monomial =	CreateList();

	if(symbol != 0)
	{
		idx = CharSymbolToIndex(symbol) + 1;
		new_monomial[idx] = degree;
	}

	new_monomial[0] = coef;
	return new_monomial;
}

int* MonomialMultipl(int *monom_1, int *monom_2)
{
	int *result = MonomialInit(0, 0, 1);
	for(int i = 1; i <= SIZE_MONOM; i++)
		result[i] = monom_1[i] + monom_2[i];

	//multiple coeff
	result[0] = monom_1[0] * monom_2[0];

	return result;
}

void MonomialPrint(int *result_monom)
{
	char symbol = '\0';
	for(int i = 1; i <= SIZE_MONOM; i++)
	{

		if(result_monom[i] != 0)
		{
			symbol = IntSymbolToChar(i);
			printf("%c", symbol);
		}
	}
	printf("\n");
}

char IntSymbolToChar(int token)
{
	char symbol = '\0';
	symbol = token + 'a' - 1;
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

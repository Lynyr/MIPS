#include <stdio.h>

float cossh(float x);
float fact(float n);
int i = 0;			//Contador
float resultado = 1;		//1 pois independente do valor de X a primeira iteracao da serie sempre e 1
float potencia = 1;		//1 para nao zerar a multiplicacao quando for receber as multiplicacoes
float divisor = 0;

int main() {
	float x;
	printf("Escolha um valor para X em Cosh(X): ");
	scanf("%f", &x);
	printf("\nO valor do Cosh de %f: %f\n", x, cossh(x));
	getch();	//Evita que o programa feche logo apos mostrar cossh
	return 0;
}

float cossh(float x) {
	if ( x == 0 )
		return 1;
	else {
		while ( i < 10) {		//Limitando o numero de iteracoes
			i++;			//Contador que servira de criterio para sair da funcao
			potencia = potencia * x * x;
			divisor = fact((float)i*2);
			resultado = resultado + potencia/divisor;
			return cossh(x);	//Recursividade
		}
	}
	return resultado;
}

float fact(float n) {
	if ( n == 0 )
		return 1;
	else
		return n*fact(n-1);
}

#include "PLP.h"


int main() {

    //Aqui cuida do menu
    int continuar = 1;
    int num;
    char cont[3];
    while (continuar) {
        while (TRUE) {
            printf("1 - SinglePlayer\n2 - MultiPlayer\n3 - Ajuda/Creditos\n4 - Regras\n5 - Sair\n");
            scanf("%i", &num);
            if (num >= 1 && num <= 5) {
                break;
            } else {
                printf("Entrada invalida, digite 1, 2, 3, 4 ou 5\n");
            }
        }

        switch (num) {
            case 1:
                singlePlayer();
                break;
            case 2 :
                multiPlayer();
                break;
            case 3  :
                printf("aaaaa");
                break;
            case 4  :
                printf("aaaa\n");
                break;
            default :
                continuar = 0;
                continue;
        }

        while (TRUE) {
            printf("Deseja continuar? sim/nao\n");
            scanf("%s", cont);
            if (strcmp(cont, "nao") == 0) {
                continuar = 0;
                break;
            } else if (strcmp(cont, "sim") == 0) {
                break;
            } else {
                printf("Entrada invalida, digite sim ou nao\n");
            }
        }
    }
}

/*
	Tabuleiro classico

	printf(" ");
	for(i = 0; i < 44; i++){
		if(i != 17 && i != 26){
			printf("_");
		}
		else{
			printf(" ");
		}
	}
	printf(" \n");
	for(i = 0; i < 12; i++){
		printf("|");
		for(j = 0; j < 17; j++){
			if((i == 1 || i == 9 || i == 11)){
				printf("_");
			}
			else{
				printf(" ");
			}
		}
		printf("|");

		for(j = 0; j < 3; j++){
			if(i%2 == 1){
				printf("__|");
			}
			else{
				printf("  |");
			}
		}
		for(j = 0; j < 17; j++){
			if((i == 1 || i == 9 || i == 11)){
				printf("_");
			}
			else{
				printf(" ");
			}
		}
		printf("|");


		printf("\n");
	}

	for(i = 0; i < 6; i++){

		for(j = 0; j < 6; j++){
			if(i%2 == 1){
				printf("|__");
			}
			else{
				printf("|  ");
			}
		}
		printf("|________|");
		for(j = 0; j < 6; j++){
			if(i%2 == 1){
				printf("__|");
			}
			else{
				printf("  |");
			}
		}
		printf("\n");
	}

	for(i = 0; i < 12; i++){
		printf("|");
		for(j = 0; j < 17; j++){
			if((i == 1 || i == 9 || i == 11)){
				printf("_");
			}
			else{
				printf(" ");
			}
		}
		printf("|");

		for(j = 0; j < 3; j++){
			if(i%2 == 1){
				printf("__|");
			}
			else{
				printf("  |");
			}
		}
		for(j = 0; j < 17; j++){
			if((i == 1 || i == 9 || i == 11)){
				printf("_");
			}
			else{
				printf(" ");
			}
		}
		printf("|");


		printf("\n");
	}

*/

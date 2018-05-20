#include <stdio.h>
#include <string.h>

typedef struct{
    		
   	int casasAndadas;
   	char time;
} peca;
		
typedef struct{
   	peca peca1;
   	peca peca2;
   	char time;    		
} jogador;

typedef struct{
	
	jogador jogadorA;
	jogador jogadorB;
	int array[68];
} tabuleiro;


void printaTabuleiro(tabuleiro *t){
	
	int i, j;
	
	//print jogador A
	
	for(i = 0; i < 2; i++){
		printf("|");
		for(j = 0; j < 21; j++){
			
			if(i%2 == 1){
				printf("  |");
			}
			else{
				printf("%c%c|", 238, 238);
			}
		}
		printf("\n");
	}
	
	for(i = 0; i < 2; i++){
		printf("|");
		for(j = 0; j < 21; j++){
			
			if(i%2 == 1 && j < 6){
				printf("->|");
			}
			else if(i%2 == 1 && j >= 19){
				printf("  |");
			}
			else if(i%2 == 0 && (j < 6 || j >= 19)){
				printf("%c%c|", 238, 238);
			}
			else if(i%2 == 0 && !(j < 6 || j >= 19)){
				printf("%c%c ", 238, 238);
			}
			else{
				printf("   ");
			}
		}
		printf("\n");
	}
	
	for(i = 0; i < 2; i++){
		
		printf("|");
		for(j = 0; j < 21; j++){
			if((i%2 == 1 && (j < 1||j >=19)) || j == 19){
				printf("  |");
			}
			else if(i%2 == 0 && (j < 1 || j > 19)){
				printf("%c%c|", 238, 238);
			}
			else if(i%2 == 0 && j < 6){
				printf("%c%c ", 238, 238);
			}
			else{
				printf("   ");
			}
		}
		printf("\n");
	}
	
	for(i = 0; i < 2; i++){
		printf("|");
		for(j = 0; j < 21; j++){
			
			if(i%2 == 1 && j > 14){
				printf("<-|");
			}
			else if((i%2 == 1 && j == 0) || j == 14){
				printf("  |");
			}
			else if(i%2 == 0 && (j > 14 || j == 0) ){
				printf("%c%c|", 238, 238);
			}
			else{
				printf("   ");
			}
		}
		printf("\n");
	}
	
	for(i = 0; i < 2; i++){
		printf("|");
		for(j = 0; j < 21; j++){
			
			if(i%2 == 1){
				printf("  |");
			}
			else{
				printf("%c%c|", 238, 238);
			}
		}
		printf("\n");
	}
	
	for(i = 0; i < 21; i++){
		
		printf(" %c%c", 238, 238);
	}
	
	printf("\n");
	//print jogador B
}

void geraTabuleiro(tabuleiro *t){
	
	int i;
	for(i = 0; i < 68; i++){
		t->array[i] = 0;
	}
}

void singlePlayer(){
					
	peca peca1A;
	peca peca2A;
	peca peca1B;
	peca peca2B;
	
	jogador jogadorA;
	jogador jogadorB;
	
	tabuleiro tabuleiro;
	
	peca1A.casasAndadas = 0;
	peca1A.time = 'A';
	peca2A.casasAndadas = 0;
	peca2A.time = 'A';
	peca1B.casasAndadas = 0;
	peca1B.time = 'B';
	peca2B.casasAndadas = 0;
	peca2B.time = 'B';
	
	jogadorA.peca1 = peca1A;
	jogadorA.peca2 = peca2A;
	jogadorA.time = 'A';
	jogadorB.peca1 = peca1B;
	jogadorB.peca2 = peca2B;	
	jogadorB.time = 'B';
	
	tabuleiro.jogadorA = jogadorA;
	tabuleiro.jogadorB = jogadorB;
	geraTabuleiro(&tabuleiro);
	
	char p[1000];
	while(1){
		
		printaTabuleiro(&tabuleiro);
	

		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", &p); //digitar qualquer coisa para rodar o dado
	
		printf("\nTeste1\n");
	}
}

void multiPlayer(){
	
	peca peca1A;
	peca peca2A;
	peca peca1B;
	peca peca2B;
	
	jogador jogadorA;
	jogador jogadorB;
	
	tabuleiro tabuleiro;
	
	peca1A.casasAndadas = 0;
	peca1A.time = 'A';
	peca2A.casasAndadas = 0;
	peca2A.time = 'A';
	peca1B.casasAndadas = 0;
	peca1B.time = 'B';
	peca2B.casasAndadas = 0;
	peca2B.time = 'B';
	
	jogadorA.peca1 = peca1A;
	jogadorA.peca2 = peca2A;
	jogadorA.time = 'A';
	jogadorB.peca1 = peca1B;
	jogadorB.peca2 = peca2B;	
	jogadorB.time = 'B';
	
	tabuleiro.jogadorA = jogadorA;
	tabuleiro.jogadorB = jogadorB;
	geraTabuleiro(&tabuleiro);
	
	char p[1000];
	while(1){
		
		printaTabuleiro(&tabuleiro);
	

		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", &p); //digitar qualquer coisa para rodar o dado
	
		printf("\nTeste2\n");
	}
}

int main(){
	
	int continuar = 1;
	int num;
	char cont[3];
	while (continuar){
	    while (1){
	    	printf("1 - SinglePlayer\n2 - MultiPlayer\n3 - Ajuda/Creditos\n4 - Regras\n5 - Sair\n");
        	scanf("%i", &num);
        	if (num >= 1 && num <= 5){
			    break;
			}
        	else{
			    printf("Entrada invalida, digite 1, 2, 3, 4 ou 5\n");
			}
    	}
    			 
    	if(num == 1){
        	singlePlayer();
        }
    
   		else if(num == 2){
		    multiPlayer();
		}

    	else if(num == 3){
		    printf("teste1\n");
		}

    	else if(num == 4){
		    printf("teste2\n");
		}
    
    	else{
        	continuar = 0;
        	continue;
    	}
    
    	while (1){
    		printf("Deseja continuar? sim/nao\n");
        	scanf("%s", &cont);
        	if (strcmp(cont, "nao") == 0){
            	continuar = 0;
            	break;
            }
        	else if(strcmp(cont, "sim") == 0){
        		break;
        	}
        	else{
            	printf("Entrada invalida, digite sim ou nao\n");
            }
        }
    }
}

/*


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

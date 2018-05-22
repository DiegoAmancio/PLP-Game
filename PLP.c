#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Criar tipos com struct serve para ajudar na hora de usar funções com struct

//Criando os tipos de struct
typedef struct{
    		
   	int casasAndadas; //Quando chegar em 56 (algo assim) o jogador vence
   	char time; //Para representar as peças no tabuleiro
} peca;
		
typedef struct{
   	peca peca1;
   	peca peca2;
   	char time;    		
} jogador;

typedef struct{
	
	jogador jogadorA;
	jogador jogadorB;
	int matriz[21][5]; //Tabuleiro 21x5 com espaços em branco (21 + 21 + 5 + 5 dá 52 que é o num de casas que existem no ludo)
} tabuleiro;


void printaTabuleiro(tabuleiro *t){
	
	int i, j;
	
	//print jogador A
	
	//print jogador B
}

void geraTabuleiro(tabuleiro *t){
	
	int i, j;
	for(i = 0; i < 5; i++){
		for(j = 0; j < 21; j++){
			t->matriz[i][j] = 0; //Sim, realmente é [i][j], bizarro
		}
	} //Define tudo como 0, quando tiver alguem será 1
	//Se quiser pode gerar as armadilhas ja aqui
}

void singlePlayer(){
					
	//Cria as peças
	peca peca1A;
	peca peca2A;
	peca peca1B;
	peca peca2B;
	
	//Cria os jogadores
	jogador jogadorA;
	jogador jogadorB;
	
	//Cria o tabuleiro
	tabuleiro tabuleiro;
	
	//Atribuições
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
	
	//O jogo de verdade começará aqui
	char p[1000];
	while(1){
		
		printaTabuleiro(&tabuleiro);
	

		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado

		if(strcmp(p, "desistir") == 0){ //desistir do jogo
			break;
		}
		system("clear"); //limpa a tela

		printf("\nTeste1\n");
	}
}

void multiPlayer(){
	
	//Cria as peças
	peca peca1A;
	peca peca2A;
	peca peca1B;
	peca peca2B;
	
	//Cria os jogadores
	jogador jogadorA;
	jogador jogadorB;
	
	//Cria o tabuleiro
	tabuleiro tabuleiro;
	
	//Atribuições
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
	
	//O jogo de verdade começará aqui
	char p[1000];
	while(1){
		
		printaTabuleiro(&tabuleiro);
	

		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado
		
		if(strcmp(p, "desistir") == 0){ //desistir do jogo
			break;
		}
		system("clear"); //limpa a tela
	}
}

int main(){
	
	//Aqui cuida do menu
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
        	scanf("%s", cont);
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

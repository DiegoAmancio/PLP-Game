#ifndef PLP_H_
#define PLP_H_

	#include <stdio.h>
	#include <unistd.h>
	#include <string.h>
	#include <stdlib.h>    
	#include <time.h> 

	int vez_do_bot = 0;

	//Criando os tipos de struct
	typedef struct {

		int x;
		int y;
	    int casasAndadas;
	    char time;
		char representacao[2];
	} peca;

	typedef struct {

	    peca peca1;
	    peca peca2;
	    char time;
	} jogador;

	typedef struct {

	    jogador jogadorA;
	    jogador jogadorB;
	    int matriz[21][5]; //Tabuleiro 21x5 com espaços em branco (21 + 21 + 5 + 5 dá 52 que é o num de casas que existem no ludo)
	} tabuleiro;

	
int movePeca(tabuleiro *t, int qtdeCasas) {
		
		int numPeca; //Numero da peça a ser movida
		if(!vez_do_bot){ //Verifica se a vez é do bot ou não
			
			//Verificações se o player pode escolher alguma peça, caso não possa fazer alguma jogada será retornado 1 para fazer o jogo seguir
			if(t->jogadorA.peca1.x == -1 && t->jogadorA.peca2.x == -1 && qtdeCasas != 6){ //As duas peças na base
				return 1;
			}
			if(t->jogadorA.peca1.x == -1 && qtdeCasas < 6 && ((t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6) || (t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6))){ //Peca 1 na base e Peca 2 no caminho
				return 1;
			}
			if(t->jogadorA.peca2.x == -1 && qtdeCasas < 6 && ((t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6) || (t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6))){ //Peca 1 no caminho e Peca 2 na base
				return 1;
			}
			if(((t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6) || (t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6)) && ((t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6) || (t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6))){ //As duas peças no caminho sem pode se mover
				return 1;
			}
			while(1){
				printf("Escolha uma peca pra mover 1 ou 2: ");
				setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
				scanf("%d", &numPeca);
				printf("\n");
				if(numPeca == 1 || numPeca == 2){
					break;
				}
				else{
					printf("Peca Invalida \n escolha uma peça valida para o movimento\n");
				}
			}

			
			if(numPeca == 1){
				if(t->jogadorA.peca1.x == -1 && qtdeCasas == 6){ //Se tirar 6, pode sair da base
					t->jogadorA.peca1.x = 0;
					t->jogadorA.peca1.y = 1;
					t->matriz[1][0]++; //Atualizando o numero de pecas na posicao da matriz
					vez_do_bot = !vez_do_bot; //Faz com que troque a vez, para na hora do jogo trocar de volta para o mesmo player
					qtdeCasas = 0; //Zera a quantidade de casas para andar
				}
				//Verificacoes se a jogada e valida
				if(t->jogadorA.peca1.x == -1 && qtdeCasas < 6){ //Peca na base e dado resultou em um numero menor do que 6
					printf("Para a peça 1 sair da base é necessário tirar 6 no dado\n");
					return 0;
				}
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6){ //Peca no caminho, mas pode acabar passando da base
					return 0;
				}
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6){ //Peca ja chegou ao final
					printf("peca 1 ja terminou o trajeto");
					return 0;
				}

				if(qtdeCasas == 6){ //Jogar novamente
					vez_do_bot = !vez_do_bot;
				}

				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x]--; //Retira da posicao atual
				//movimentos inicio:
				if(t->jogadorA.peca1.x == 0){ //Movimento se estiver na primeira linha
					while(t->jogadorA.peca1.y < 20 && qtdeCasas > 0){
						t->jogadorA.peca1.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.y == 20){ //Movimento se estiver na ultima coluna
					while(t->jogadorA.peca1.x < 4 && qtdeCasas > 0){
						t->jogadorA.peca1.x++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.x == 4){ //Movimento se estiver na ultima linha
					while(t->jogadorA.peca1.y > 0 && qtdeCasas > 0){
						t->jogadorA.peca1.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.y == 0){ //Movimento se estiver na primeira coluna
					while(t->jogadorA.peca1.x > 1 && qtdeCasas > 0){
						t->jogadorA.peca1.x--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6){ //Movimento se estiver no caminho dourado
					while(t->jogadorA.peca1.y < 6 && qtdeCasas > 0){
						t->jogadorA.peca1.y++;
						qtdeCasas--;
					}
				}
				//fim de movimentos
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6){
					vez_do_bot = !vez_do_bot;
				} 
				if(t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] == 1){ //Verificacoes de captura
					if(t->jogadorB.peca1.x == t->jogadorA.peca1.x && t->jogadorB.peca1.y == t->jogadorA.peca1.y){
						t->jogadorB.peca1.x = -1;
						t->jogadorB.peca1.y = -1;						
						t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] = 0;
					}
					else if(t->jogadorB.peca2.x == t->jogadorA.peca1.x && t->jogadorB.peca2.y == t->jogadorA.peca1.y){
						t->jogadorB.peca2.x = -1;
						t->jogadorB.peca2.y = -1;	
						t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] = 0;
					}
				}

				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x]++; //Alocando no novo espaco
			}
			if(numPeca == 2){
				if(t->jogadorA.peca2.x == -1 && qtdeCasas == 6){
					t->jogadorA.peca2.x = 0;
					t->jogadorA.peca2.y = 1;
					t->matriz[1][0]++;
					vez_do_bot = !vez_do_bot;
					qtdeCasas = 0;
				}
				if(t->jogadorA.peca2.x == -1 && qtdeCasas < 6){
					printf("Para a peça 2 sair da base é necessário tirar 6 no dado\n");
					return 0;
				}
				if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6){
					printf("peca 2 ja terminou o trajeto");
					return 0;
				}
				if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6){
					return 0;
				}

				if(qtdeCasas == 6){
					vez_do_bot = !vez_do_bot;
				}

				t->matriz[t->jogadorA.peca2.y][t->jogadorA.peca2.x]--;
				if(t->jogadorA.peca2.x == 0){
					while(t->jogadorA.peca2.y < 20 && qtdeCasas > 0){
						t->jogadorA.peca2.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca2.y == 20){
					while(t->jogadorA.peca2.x < 4 && qtdeCasas > 0){
						t->jogadorA.peca2.x++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca2.x == 4){
					while(t->jogadorA.peca2.y > 0 && qtdeCasas > 0){
						t->jogadorA.peca2.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca2.y == 0){
					while(t->jogadorA.peca2.x > 1 && qtdeCasas > 0){
						t->jogadorA.peca2.x--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6){
					while(t->jogadorA.peca2.y < 6 && qtdeCasas > 0){
						t->jogadorA.peca2.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6){
					vez_do_bot = !vez_do_bot;
				} 
				if(t->matriz[t->jogadorA.peca2.y][t->jogadorA.peca2.x] == 1){
					if(t->jogadorB.peca1.x == t->jogadorA.peca2.x && t->jogadorB.peca1.y == t->jogadorA.peca2.y){
						t->jogadorB.peca1.x = -1;
						t->jogadorB.peca1.y = -1;						
						t->matriz[t->jogadorA.peca2.y][t->jogadorA.peca2.x] = 0;
					}
					else if(t->jogadorB.peca2.x == t->jogadorA.peca2.x && t->jogadorB.peca2.y == t->jogadorA.peca2.y){
						t->jogadorB.peca2.x = -1;
						t->jogadorB.peca2.y = -1;	
						t->matriz[t->jogadorA.peca2.y][t->jogadorA.peca2.x] = 0;
					}
				}
				t->matriz[t->jogadorA.peca2.y][t->jogadorA.peca2.x]++;
			}
		}
		else{
			if(t->jogadorB.peca1.x == -1 && t->jogadorB.peca2.x == -1 && qtdeCasas != 6){
				return 1;
			}
			if(t->jogadorB.peca1.x == -1 && qtdeCasas < 6 && ((t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y == 14) || (t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y > 14 && t->jogadorB.peca2.y-qtdeCasas < 14))){
				return 1;
			}
			if(t->jogadorB.peca2.x == -1 && qtdeCasas < 6 && ((t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y == 14) || (t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y > 14 && t->jogadorB.peca1.y-qtdeCasas < 14))){
				return 1;
			}
			if(((t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y == 14) || (t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y > 14 && t->jogadorB.peca1.y-qtdeCasas < 14)) && ((t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y == 14) || (t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y > 14 && t->jogadorB.peca2.y-qtdeCasas < 14))){
				return 1;
			}
			srand(time(NULL));
			numPeca = (rand() % 2)+1;
			if(numPeca == 1){
				if(t->jogadorB.peca1.x == -1 && qtdeCasas == 6){
					t->jogadorB.peca1.x = 4;
					t->jogadorB.peca1.y = 19;
					t->matriz[19][4]++;
					vez_do_bot = !vez_do_bot;	
					qtdeCasas = 0;				
				}
				if(t->jogadorB.peca1.x == -1 && qtdeCasas < 6){
					return 0;
				}
				if(t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y > 14 && t->jogadorB.peca1.y-qtdeCasas < 14){
					return 0;
				}
				if(t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y == 14){
					return 0;
				}
				if(qtdeCasas == 6){
					vez_do_bot = !vez_do_bot;
				}
				t->matriz[t->jogadorB.peca1.y][t->jogadorB.peca1.x]--;
				if(t->jogadorB.peca1.x == 4){
					while(t->jogadorB.peca1.y > 0 && qtdeCasas > 0){
						t->jogadorB.peca1.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca1.y == 0){
					while(t->jogadorB.peca1.x > 0 && qtdeCasas > 0){
						t->jogadorB.peca1.x--;
						qtdeCasas--;
					}
				}

				if(t->jogadorB.peca1.x == 0){
					while(t->jogadorB.peca1.y < 20 && qtdeCasas > 0){
						t->jogadorB.peca1.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca1.y == 20){
					while(t->jogadorB.peca1.x < 3 && qtdeCasas > 0){
						t->jogadorB.peca1.x++;
						qtdeCasas--;
					}
				}

				if(t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y > 14){
					while(t->jogadorB.peca1.y > 14 && qtdeCasas > 0){
						t->jogadorB.peca1.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y == 14){
					vez_do_bot = !vez_do_bot;
				} 
				if(t->matriz[t->jogadorB.peca1.y][t->jogadorB.peca1.x] == 1){
					if(t->jogadorB.peca1.x == t->jogadorA.peca1.x && t->jogadorB.peca1.y == t->jogadorA.peca1.y){
						t->jogadorA.peca1.x = -1;
						t->jogadorA.peca1.y = -1;						
						t->matriz[t->jogadorB.peca1.y][t->jogadorB.peca1.x] = 0;
					}
					else if(t->jogadorB.peca1.x == t->jogadorA.peca2.x && t->jogadorB.peca1.y == t->jogadorA.peca2.y){
						t->jogadorA.peca2.x = -1;
						t->jogadorA.peca2.y = -1;	
						t->matriz[t->jogadorB.peca1.y][t->jogadorB.peca1.x] = 0;
					}
				}
				t->matriz[t->jogadorB.peca1.y][t->jogadorB.peca1.x]++;
			}
			if(numPeca == 2){
				if(t->jogadorB.peca2.x == -1 && qtdeCasas == 6){
					t->jogadorB.peca2.x = 4;
					t->jogadorB.peca2.y = 19;
					t->matriz[19][4]++;
					vez_do_bot = !vez_do_bot;	
					qtdeCasas = 0;				
				}
				if(t->jogadorB.peca2.x == -1 && qtdeCasas < 6){
					return 0;
				}
				if(t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y > 14 && t->jogadorB.peca2.y-qtdeCasas < 14){
					return 0;
				}
				if(t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y == 14){
					return 0;
				}
				if(qtdeCasas == 6){
					vez_do_bot = !vez_do_bot;
				}
				t->matriz[t->jogadorB.peca2.y][t->jogadorB.peca2.x]--;
				if(t->jogadorB.peca2.x == 4){
					while(t->jogadorB.peca2.y > 0 && qtdeCasas > 0){
						t->jogadorB.peca2.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca2.y == 0){
					while(t->jogadorB.peca2.x > 0 && qtdeCasas > 0){
						t->jogadorB.peca2.x--;
						qtdeCasas--;
					}
				}

				if(t->jogadorB.peca2.x == 0){
					while(t->jogadorB.peca2.y < 20 && qtdeCasas > 0){
						t->jogadorB.peca2.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca2.y == 20){
					while(t->jogadorB.peca2.x < 3 && qtdeCasas > 0){
						t->jogadorB.peca2.x++;
						qtdeCasas--;
					}
				}

				if(t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y > 14){
					while(t->jogadorB.peca2.y > 14 && qtdeCasas > 0){
						t->jogadorB.peca2.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y == 14){
					vez_do_bot = !vez_do_bot;
				} 
				if(t->matriz[t->jogadorB.peca2.y][t->jogadorB.peca2.x] == 1){
					if(t->jogadorB.peca2.x == t->jogadorA.peca1.x && t->jogadorB.peca2.y == t->jogadorA.peca1.y){
						t->jogadorA.peca1.x = -1;
						t->jogadorA.peca1.y = -1;						
						t->matriz[t->jogadorB.peca2.y][t->jogadorB.peca2.x] = 0;
					}
					else if(t->jogadorB.peca2.x == t->jogadorA.peca2.x && t->jogadorB.peca2.y == t->jogadorA.peca2.y){
						t->jogadorA.peca2.x = -1;
						t->jogadorA.peca2.y = -1;	
						t->matriz[t->jogadorB.peca2.y][t->jogadorB.peca2.x] = 0;
					}
				}
				t->matriz[t->jogadorB.peca2.y][t->jogadorB.peca2.x]++;
			}
		}
		return 1;
	}

	void printaTabuleiro(tabuleiro *t) {

	    int i, j;
	    printf(" ______ \n");
		t->jogadorA.peca1.x == -1? printf("|      |  peca1: base\n") : printf("|      |  peca1: x:0%d y:%d%d\n", t->jogadorA.peca1.x, t->jogadorA.peca1.y/10, t->jogadorA.peca1.y%10);
		printf("|  %s  |\n", t->jogadorA.peca1.x == -1 ? t->jogadorA.peca1.representacao : "  ");
		printf("|  %s  |\n", t->jogadorA.peca2.x == -1 ? t->jogadorA.peca2.representacao : "  ");
		t->jogadorA.peca2.x == -1? printf("|______|  peca2: base\n") : printf("|______|  peca2: x:0%d y:%d%d\n", t->jogadorA.peca2.x, t->jogadorA.peca2.y/10, t->jogadorA.peca2.y%10);
		
		for(i = 0; i < 21; i++){
			printf(" __");
		}
		printf("\n");
		
		for(i = 0; i < 2; i++){
			printf("|");
			for(j = 0; j < 21; j++){
				
				if(i == 1){
					printf("__|");
				}
				else{
					t->matriz[j][0] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][0]);
				}
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			printf("|");
			for(j = 0; j < 21; j++){
				
				if(i == 0 && j < 6){
					t->matriz[j][1] == 0 ? printf("->|") : printf(" %d|" ,t->matriz[j][1]);
				}
				else if(j == 19){
					printf("  |");
				}
				else if(i == 0 && j ==20){
					t->matriz[j][1] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][1]);
				}
				else if(i == 1 && (j < 6 || j == 20)){
					printf("__|");
				}
				else if(i == 1 && !(j < 6 || j == 20)){
					printf("   ");
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
				if((i == 1 && (j == 0||j >= 19))){
					printf("__|");
				}
				else if(i == 0 && (j == 0 || j  >= 19)){
					t->matriz[j][2] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][2]);
				}
				else if(i == 1 && j < 19 && j > 14){
					printf("__ ");
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
				
				if(i == 0 && j > 14){
					t->matriz[j][3] == 0 ? printf("<-|") : printf(" %d|" ,t->matriz[j][3]);
				}
				else if(i == 1 && (j == 0 || j >= 14)){
					printf("__|");
				}
				else if(i ==0 && j == 14){
					printf("  |");
				}
				else if(i == 0 && j == 0){
					t->matriz[j][3] == 0 ? printf("  |") : printf(" %d|", t->matriz[j][3]);
				}
				else if(i == 1){
					printf("__ ");
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
					printf("__|");
				}
				else{
					t->matriz[j][4] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][4]);
				}
			}
			printf("\n");
		}		
	    printf("                                                         ______ \n");
		t->jogadorB.peca1.x == -1? printf("                                           peca1: base  |      |\n") : printf("                                      peca1: x:0%d y:%d%d  |      |\n", t->jogadorB.peca1.x, t->jogadorB.peca1.y/10, t->jogadorB.peca1.y%10);	
		printf("                                                        |  %s  |\n", t->jogadorB.peca1.x == -1 ? t->jogadorB.peca1.representacao : "  ");
		printf("                                                        |  %s  |\n", t->jogadorB.peca2.x == -1 ? t->jogadorB.peca2.representacao : "  ");
		t->jogadorB.peca2.x == -1? printf("                                           peca2: base  |______|\n\n") : printf("                                      peca2: x:0%d y:%d%d  |______|\n\n", t->jogadorB.peca2.x, t->jogadorB.peca2.y/10, t->jogadorB.peca2.y%10);	

	}


	void geraTabuleiro(tabuleiro *t) {

		//Preenche o tabuleiro com 0 (nenhuma peca em todas as casas)
	    int i, j;
	    for (i = 0; i < 5; i++) {
			for (j = 0; j < 21; j++) {
		    	t->matriz[j][i] = 0;
			}
	    }
	}

	/**
	 * ... Funcao que modela dado simples ...
	 * @return Valor entre 1 e 6
	 */
	int rodaDado() {
		srand(time(NULL));
	    int saidaDado = rand() % 6;
	    if(saidaDado < 0){
			saidaDado = rodaDado();
		}
		else if(saidaDado > 5){
			saidaDado = rodaDado();
		}
	    return saidaDado+1;
	}

	void jogo() {
		
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
		peca1A.representacao[0] = 'A';
		peca1A.representacao[1] = '1';
		peca1A.x = -1;
		peca1A.y = -1;
	    peca2A.casasAndadas = 0;
	    peca2A.time = 'A';
		peca2A.representacao[0] = 'A';
		peca2A.representacao[1] = '2';
		peca2A.x = -1;
		peca2A.y = -1;
	    peca1B.casasAndadas = 0;
	    peca1B.time = 'B';
		peca1B.representacao[0] = 'B';
		peca1B.representacao[1] = '1';
		peca1B.x = -1;
		peca1B.y = -1;
	    peca2B.casasAndadas = 0;
	    peca2B.time = 'B';
		peca2B.representacao[0] = 'B';
		peca2B.representacao[1] = '2';
		peca2B.x = -1;
		peca2B.y = -1;

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
	    int dado;
		char p[1000];
		
		while (1) {
			
			system("clear"); //limpa a tela			
			printaTabuleiro(&tabuleiro);
			
			if(!vez_do_bot){

				printf("Sua vez : digite qualquer coisa para rodar o dado ou desistir para sair:\n");		
				setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
				scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado
				if (strcmp(p, "desistir") == 0) { //desistir do jogo
					printf("Você desistiu, consequentemente... Voce perdeu!\n");
					break;
				}
				dado = rodaDado();
				printf("Voce tirou no dado %d\n", dado);
				sleep(1);
				while(1){ //Enquanto o movimento nao for valido, tentar jogar a peca
					if (movePeca(&tabuleiro, dado)){
						break;
					}
					else{
						printf("Movimento invalido\n");
					}
				}
				if(tabuleiro.matriz[6][1] == 2){ //Posicao final do time A
					printf("Parabens, voce ganhou!!\n");
					break;
				}
			}
			else{
				sleep(1);
				printf("Vez do bot : o bot vai jogar o dado...\n");
				sleep(1); //Para dar tempo a açao do bot
				printaTabuleiro(&tabuleiro);
				dado = rodaDado();
				printf("\nSaiu no dado %d\n", dado);
				while(1){
					if (movePeca(&tabuleiro, dado)){
						break;
					}
				}
				sleep(1);
				if(tabuleiro.matriz[14][3] == 2){ //Posicao final do time B
					printf("Voce perdeu :(\n");
					break;
				}
			}

			vez_do_bot = !vez_do_bot; //Troca a vez
	    }
	}

#endif  /*PLP_H*/

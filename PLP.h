#ifndef PLP_H_
#define PLP_H_

	#include <stdio.h>
	#include <unistd.h>
	#include <string.h>
	#include <stdlib.h> // necessario p as funçoes rand() e srand()   
	#include <time.h> //necessario p funçao time()

	#ifndef FALSE
	#define FALSE (0)
	#define TRUE (!(FALSE))
	#endif

	#define ERRO -1
	#define SEM_ERRO 0

	int vez_do_bot = 0;

	//IDENTIFICADORES DO JOGADOR
	const char PLAYER_A = 'A';
	const char PLAYER_B = 'B';

	// DISTANCIA DE 26 CASAS DO INICIO DE UM PARA O INICIO DO OUTRO ADVERSARIO
	#define OFFSET_PLAYER_B 26
	// TAMANHO DO TABULEIRO COM 57 CELULAS
	#define TAMANHO_TABULEIRO 57
	#define INDICE_MAXIMO_TABULEIRO (TAMANHO_TABULEIRO-1)

	//MAXIMO DE PECA POR JOGADOR
	const char MAX_PECAS_JOGADOR = 2;


	//Criar tipos com struct serve para ajudar na hora de usar funções com struct

	//Criando os tipos de struct
	typedef struct {
		int x;
		int y;
	    int casasAndadas; //Quando chegar em 56 (algo assim) o jogador vence
	    char time; //Para representar as peças no tabuleiro
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


	/**
	 *  ... Move a peca a quantidade dada de casas indicadas  ...
	 * @param pecaAMover a peca a ser movimentada
	 * @param qtdeCasas A quantidade de casas a ser movido
	 * @return Retorna ERRO se nao for possivel mover
	 */
	int movePeca(tabuleiro *t, int qtdeCasas) {
		
		int numPeca;
		peca pecaAMover;
		if(!vez_do_bot){
			
			if(t->jogadorA.peca1.x == -1 && t->jogadorA.peca2.x == -1 && qtdeCasas != 6){
				return 1;
			}
			if(t->jogadorA.peca1.x == -1 && qtdeCasas < 6 && ((t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6) || (t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6))){
				return 1;
			}
			if(t->jogadorA.peca2.x == -1 && qtdeCasas < 6 && ((t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6) || (t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6))){
				return 1;
			}
			if(((t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6) || (t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6)) && ((t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6) || (t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6))){
				return 1;
			}
			printf("Escolha uma peca pra mover: ");
			scanf("%d", &numPeca);
			printf("\n");
			
			if(numPeca == 1){
				if(t->jogadorA.peca1.x == -1 && qtdeCasas == 6){
					t->jogadorA.peca1.x = 0;
					t->jogadorA.peca1.y = 1;
					t->matriz[1][0]++;
					vez_do_bot = !vez_do_bot;	
					qtdeCasas = 0;				
				}
				if(t->jogadorA.peca1.x == -1 && qtdeCasas < 6){
					return 0;
				}
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6 && t->jogadorA.peca1.y+qtdeCasas > 6){
					return 0;
				}
				if(qtdeCasas == 6){
					vez_do_bot = !vez_do_bot;
				}

				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x]--;
				if(t->jogadorA.peca1.x == 0){
					while(t->jogadorA.peca1.y < 20 && qtdeCasas > 0){
						t->jogadorA.peca1.y++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.y == 20){
					while(t->jogadorA.peca1.x < 4 && qtdeCasas > 0){
						t->jogadorA.peca1.x++;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.x == 4){
					while(t->jogadorA.peca1.y > 0 && qtdeCasas > 0){
						t->jogadorA.peca1.y--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.y == 0){
					while(t->jogadorA.peca1.x > 1 && qtdeCasas > 0){
						t->jogadorA.peca1.x--;
						qtdeCasas--;
					}
				}
				if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y < 6){
					while(t->jogadorA.peca1.y < 6 && qtdeCasas > 0){
						t->jogadorA.peca1.y++;
						qtdeCasas--;
					}
				}
				if(t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] == 1){
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
				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x]++;
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
					return 0;
				}
				if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y < 6 && t->jogadorA.peca2.y+qtdeCasas > 6){
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

	    int i, j;
	    for (i = 0; i < 5; i++) {
			for (j = 0; j < 21; j++) {
		    	t->matriz[j][i] = 0;
			}
	    }
	    //Se quiser pode gerar as armadilhas ja aqui
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

/*	void geraArmadilha(peca pecaJogador, int numdado){
		srand(time(NULL));
		int numArmadilha = (rand() % 5)+1;

		if (numArmadilha == 1) {
			printf("Armadilha: Desvio na avenida local! /n Volte o número de casas indicado pelo dado/n Se você tirou 6, seu carro tem asas e conseguiu evitar o desvio");
			sleep(2);
			if(numdado != 6){
				movePeca(&pecaJogador,numdado);
			}
			
			
		}
		else if (numArmadilha == 2)
		{
			printf("Armadilha: Gasolina Acabando e o posto a frente cobra muito caro! /n Retorne 2 espaços para abastecer no posto anterior");
			movePeca(&pecaJogador,-2);

		}
		else if (numArmadilha == 3)
		{
			printf("Armadilha: Blitz na Rodovia! /n Se tirou par no Dado, indica que você tem carteira e foi liberado, caso não, pagou multa de 5 espaços");
			sleep(2);
			if(numdado %2 != 0){
				movePeca(&pecaJogador,-5);
			}
			
			
		}
		else if (numArmadilha = 4)
		{
			printf("Armadilha: Dia de Emplacamento! /n Pague o Emplacamento e volte a metade da quantidade de casas que você andou!");
			sleep(2);
			numdado = (numdado/2) * -1;
			movePeca(&pecaJogador,numdado);
		}
		else if (numArmadilha = 5){
			printf("Armadilha: Carona na abertura de ambulancia! /n Ande novamente o mesmo número de casas");
			sleep(2);
			movePeca(&pecaJogador, numdado);
		}
	}
*/

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

				printf("Sua vez : aperte digite qualquer coisa para rodar o dado ou desistir para sair:\n");		
				setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
				scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado
				dado = rodaDado();
				printf("Voce tirou no dado %d\n", dado);
				while(1){
					if (movePeca(&tabuleiro, dado)){
						break;
					}
					else{
						printf("Movimento invalido\n");
					}
				}
				if(tabuleiro.matriz[6][1] == 2){
					printf("Parabens, voce ganhou!!\n");
					break;
				}
			}
			else{
				system("clear"); //limpa a tela
				printf("Vez do bot : o bot vai jogar o dado...\n");
				sleep(1);
				dado = rodaDado();
				printf("\nSaiu no dado %d\n", dado);
				while(1){
					if (movePeca(&tabuleiro, dado)){
						break;
					}
				}
				sleep(2);
				if(tabuleiro.matriz[14][3] == 2){
					printf("Voce perdeu :(\n");
					break;
				}
			}
		
			if (strcmp(p, "desistir") == 0) { //desistir do jogo
				printf("Você desistiu, consequentemente... Voce perdeu!\n");
				break;
			}

			vez_do_bot = !vez_do_bot;
	    }
	}

#endif  /*PLP_H*/

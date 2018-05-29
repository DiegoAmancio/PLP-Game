#ifndef PLP_H_
#define PLP_H_

	#include <stdio.h>
	#include <unistd.h>
	#include <string.h>
	#include <stdlib.h>    
	#include <time.h>
	
	
	
#define foreground(color) FORE##color
#define background(color) BACK##color
#define style(style_) style_

/** Foreground Colors **/
#define FOREBLACK printf("\033[30m") 
#define FORERED printf("\033[31m") 
#define FOREGREEN printf("\033[32m") 
#define FOREYELLOW printf("\033[33m") 
#define FOREBLUE printf("\033[34m") 
#define FOREMARGENTA printf("\033[35m") 
#define FORECYAN printf("\033[36m") 
#define FOREWHITE printf("\033[37m") 
#define FORENORMAL_COLOR printf("\033[39m") 

/** Background Colors **/
#define BACKBLACK printf("\033[40m") 
#define BACKRED printf("\033[41m") 
#define BACKGREEN printf("\033[42m") 
#define BACKYELLOW printf("\033[43m") 
#define BACKBLUE printf("\033[44m") 
#define BACKMAGENTA printf("\033[45m") 
#define BACKCYAN printf("\033[46m") 
#define BACKWHITE printf("\033[47m") 
#define BACKNORMAL printf("\033[49m")

/** Style **/
#define BRIGHT printf("\033[1m")
#define DIM printf("\033[2m")
#define NORMAL printf("\033[22m")
#define RESETALL printf("\033[0m")
#define UNDERLINE printf("\033[4m")
#define BLINKSLOW printf("\033[5m")
#define BLINKRAPID printf("\033[6m")
#define ITALIC printf("\033[3m")
#define NEGATIVE printf("\033[7m")
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
		int armadilhas[21][5];
	} tabuleiro;


	
	int geraArmadilha(tabuleiro *tab, peca *pecaPega, int numdado){

		int numArmadilha = (rand() % 5)+1;
		int saida = 1;

		/*	
		if (numArmadilha == 1){
			printf("Armadilha: Desvio na avenida local! /n Volte o número de casas indicado pelo dado/n Se você tirou 6, seu carro tem asas e conseguiu evitar o desvio");
			sleep(2);
			if (numdado = 6){
				saida = 1;
			}else{
				//adicionar o movepeca retorna o numero indicado pelo dado
			}
		}else if (numArmadilha == 2){
			
			printf("Armadilha: Gasolina Acabando e o posto a frente cobra muito caro! /n Retorne 2 espaços para abastecer no posto anterior");
			//adicionar o movepeca dois espaços para tras
		
		}else if (numArmadilha == 3){
			
			printf("Armadilha: Blitz na Rodovia! /n Se tirou par no Dado, indica que você tem carteira e foi liberado, caso não, pagou multa de 5 espaços");
			sleep(2);
			
			if (numdado % 2 == 0){
				saida = 1;
			}else{
				//adicionar o movepeca 5 espaços para tras
			}
		}else if (numArmadilha = 4){
			printf("Armadilha: Dia de Emplacamento! /n Pague o Emplacamento e volte a metade da quantidade de casas que você andou!");
			sleep(2);
			numdado = (numdado / 2) * -1;
			//adicionar o movepeca com a metade do dado em negativo(transformação já feita acima)
		}else if (numArmadilha = 5){
			printf("Armadilha: Carona na abertura de ambulancia! /n Ande novamente o mesmo número de casas");
			sleep(2);
			//movePeca(tab,numdado * 2,0);
			saida = 1;
		}

		*/
		return saida;
		
	}

	int moveTimeA(tabuleiro *t, peca *p, int qtdeCasas){
		

		if(p->x == -1 && qtdeCasas == 6){ //Se tirar 6, pode sair da base
			p->x = 0;
			p->y = 1;
			t->matriz[1][0]++; //Atualizando o numero de pecas na posicao da matriz
			vez_do_bot = !vez_do_bot; //Faz com que troque a vez, para na hora do jogo trocar de volta para o mesmo player
			qtdeCasas = 0; //Zera a quantidade de casas para andar
			p->casasAndadas = 0;
		}
		int dado = qtdeCasas;
		//Verificacoes se a jogada e valida
		if(p->x == -1 && qtdeCasas < 6){ //Peca na base e dado resultou em um numero menor do que 6
			printf("Para a peça 1 sair da base é necessário tirar 6 no dado\n");
			return 0;
		}
		if(p->x == 1 && p->y < 6 && p->y+qtdeCasas > 6){ //Peca no caminho, mas pode acabar passando da base
			return 0;
		}
		if(p->x == 1 && p->y == 6){ //Peca ja chegou ao final
			printf("peca 1 ja terminou o trajeto");
			return 0;
		}
		if(qtdeCasas == 6){ //Jogar novamente
			vez_do_bot = !vez_do_bot;
		}
		t->matriz[p->y][p->x]--; //Retira da posicao atual
		//movimentos inicio:
		if(p->x == 0){ //Movimento se estiver na primeira linha
			while(p->y < 20 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
			}
		}
		if(p->y == 20){ //Movimento se estiver na ultima coluna
			while(p->x < 4 && qtdeCasas > 0){
				p->x++;
				qtdeCasas--;
			}
		}
		if(p->x == 4){ //Movimento se estiver na ultima linha
			while(p->y > 0 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
			}
		}
		if(p->y == 0){ //Movimento se estiver na primeira coluna
			while(p->x > 1 && qtdeCasas > 0){
				p->x--;
				qtdeCasas--;
			}
		}
		if(p->x == 1 && p->y < 6){ //Movimento se estiver no caminho dourado
			while(p->y < 6 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
			}
		}
		//fim de movimentos
		if(p->x == 1 && p->y == 6){
			vez_do_bot = !vez_do_bot;
		} 
		if(t->matriz[p->y][p->x] == 1){ //Verificacoes de captura
			if(t->jogadorB.peca1.x == p->x && t->jogadorB.peca1.y == p->y){
				t->jogadorB.peca1.x = -1;
				t->jogadorB.peca1.y = -1;						
				t->matriz[p->y][p->x] = 0;
			}
			else if(t->jogadorB.peca2.x == p->x && t->jogadorB.peca2.y == p->y){
				t->jogadorB.peca2.x = -1;
				t->jogadorB.peca2.y = -1;	
				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] = 0;
			}
		}
		t->matriz[p->y][p->x]++; //Alocando no novo espaco
		if(t->armadilhas[p->y][p->x]){
			geraArmadilha(t, p, dado); //A armadilha vai ser aleatoria
		}
		return 1;
	}


	int moveTimeB(tabuleiro *t, peca *p, int qtdeCasas){
		if(p->x == -1 && qtdeCasas == 6){
			p->x = 4;
			p->y = 19;
			t->matriz[19][4]++;
			vez_do_bot = !vez_do_bot;	
			qtdeCasas = 0;				
		}
		int dado = qtdeCasas;
		if(p->x == -1 && qtdeCasas < 6){
			return 0;
		}
		if(p->x == 3 && p->y > 14 && p->y-qtdeCasas < 14){
			return 0;
		}
		if(p->x == 3 && p->y == 14){
			return 0;
		}
		if(qtdeCasas == 6){
			vez_do_bot = !vez_do_bot;
		}
		t->matriz[p->y][p->x]--;
		if(p->x == 4){
			while(p->y > 0 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
			}
		}
		if(p->y == 0){
			while(p->x > 0 && qtdeCasas > 0){
				p->x--;
				qtdeCasas--;
			}
		}

		if(p->x == 0){
			while(p->y < 20 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
			}
		}
		if(p->y == 20){
			while(p->x < 3 && qtdeCasas > 0){
				p->x++;
				qtdeCasas--;
			}
		}
		
		if(p->x == 3 && p->y > 14){
			while(p->y > 14 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
			}
		}
		if(p->x == 3 && p->y == 14){
			vez_do_bot = !vez_do_bot;
		} 
		if(t->matriz[p->y][p->x] == 1){
			if(p->x == t->jogadorA.peca1.x && p->y == t->jogadorA.peca1.y){
				t->jogadorA.peca1.x = -1;
				t->jogadorA.peca1.y = -1;						
				t->matriz[p->y][p->x] = 0;
			}
			else if(p->x == t->jogadorA.peca2.x && p->y == t->jogadorA.peca2.y){
				t->jogadorA.peca2.x = -1;
				t->jogadorA.peca2.y = -1;	
				t->matriz[p->y][p->x] = 0;
			}
		}
		t->matriz[p->y][p->x]++;
		if(t->armadilhas[p->y][p->x]){
			geraArmadilha(t, p, dado); //A armadilha vai ser aleatoria
		}
		return 1;
	}

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
				return moveTimeA(t, &(t->jogadorA.peca1), qtdeCasas);
			}
			if(numPeca == 2){
				return moveTimeA(t, &(t->jogadorA.peca2), qtdeCasas);
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
				return moveTimeB(t, &(t->jogadorB.peca1), qtdeCasas);
			}
			if(numPeca == 2){
				return moveTimeB(t, &(t->jogadorB.peca2), qtdeCasas);
			}
		}
		return 1;
	}

	void voltePeca(tabuleiro *t, peca *p, int qtdeCasas){
		
		if(p->time == 'A'){

			t->matriz[p->y][p->x]--;
		
			if(p->y == 0){ //Movimento se estiver na primeira coluna
				while(p->x < 4 && qtdeCasas > 0){
					p->x++;
					qtdeCasas--;
				}
			}

			if(p->x == 4){ //Movimento se estiver na ultima linha
				while(p->y < 20 && qtdeCasas > 0){
					p->y++;
					qtdeCasas--;
				}
			}

			if(p->y == 20){ //Movimento se estiver na ultima coluna
				while(p->x > 0 && qtdeCasas > 0){
					p->x--;
					qtdeCasas--;
				}
			}
			
			if(p->x == 0){ //Movimento se estiver na primeira linha
				while(p->y > 1 && qtdeCasas > 0){
					p->y--;
					qtdeCasas--;
				}
			}

			t->matriz[p->y][p->x]++;
		}
		else{

			t->matriz[p->y][p->x]--;
			
			if(p->y == 20){
				while(p->x > 0 && qtdeCasas > 0){
					p->x--;
					qtdeCasas--;
				}
			}
			if(p->x == 0){
				while(p->y > 0 && qtdeCasas > 0){
					p->y--;
					qtdeCasas--;
				}
			}

			if(p->y == 0){
				while(p->x < 4 && qtdeCasas > 0){
					p->x++;
					qtdeCasas--;
				}
			}

			if(p->x == 4){
				while(p->y < 19 && qtdeCasas > 0){
					p->y++;
					qtdeCasas--;
				}
			}

			t->matriz[p->y][p->x]++;
		}
	}

	void printaTabuleiro(tabuleiro *t) {

	    int i, j;
	   
	    background(GREEN);
	    printf("        ");
	    
	    style(RESETALL);
	   	
		t->jogadorA.peca1.x == -1? printf("  peça1: base\n") : printf("  peça1: x:0%d y:%d%d\n", t->jogadorA.peca1.x, t->jogadorA.peca1.y/10, t->jogadorA.peca1.y%10);
		
		background(GREEN);
		printf("   %s   \n", t->jogadorA.peca1.x == -1 ? t->jogadorA.peca1.representacao : "  ");
		printf("   %s   \n", t->jogadorA.peca2.x == -1 ? t->jogadorA.peca2.representacao : "  ");
		printf("        ");
		style(RESETALL);
		
		t->jogadorA.peca2.x == -1? printf("  peça2: base\n") : printf("  peça2: x:0%d y:%d%d\n", t->jogadorA.peca2.x, t->jogadorA.peca2.y/10, t->jogadorA.peca2.y%10);
		
		
		printf("\n");
		background(WHITE);
		for(i = 0; i < 2; i++){
			foreground(BLACK);
			printf("|");
			for(j = 0; j < 21; j++){
				
				if(i == 1){
					if( j == 20){
						printf("__|");
					}else{
						printf("  |");
					}	
					
				}
				else{
				t->matriz[j][0] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][0]);
			}
		}
			
			printf("\n");
		}
		style(RESETALL);
		for(i = 0; i < 2; i++){
			background(GREEN);
			foreground(BLACK);
			printf("|");
			
			for(j = 0; j < 21; j++){
				foreground(BLACK);
				if(i == 0 && j < 6){
					background(GREEN);
					
					t->matriz[j][1] == 0 ? printf("->|") : printf(" %d|" ,t->matriz[j][1]);
					style(RESETALL);
				}
				else if(j == 19){
					printf("  ");
					
					background(WHITE);
					printf("|");
				}
				else if(i == 0 && j ==20){
					
					t->matriz[j][1] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][1]);
				}
				else if(i == 1 && (j < 6 || j == 20)){
					if(j != 20){
						background(GREEN);
						printf("  |");
					}else{
						printf("__|");
					}
					
					style(RESETALL);
					
				}
				else {
					background(BLACK);	
					printf("   ");
					
				}
				
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			foreground(BLACK);
			background(WHITE);
			printf("|");
			for(j = 0; j < 21; j++){
				foreground(BLACK);
				background(WHITE);
				if((i == 1 && (j == 0||j >= 19))){
					if(j == 19){
						background(BLACK);
						printf("  ");	
						background(WHITE);
						printf("|");
					}else{
						printf("__|");
					}
					
					
				}
				else if(i == 0 && (j == 19)){
					
					
					background(BLACK);
					printf("  ");
					background(WHITE);
					printf("|");
					
				}
				else if(i == 0 && (j == 0 || j  == 20)){
					
					
					background(WHITE);
					t->matriz[j][2] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][2]);
					
				}
				else if(i == 1 && j < 19 && j > 14){
					
					background(BLACK);	
					printf("   ");
					
				}
				else{
					background(BLACK);	
					printf("   ");
				}
					
			}
			
			printf("\n");
			
			
		}
		style(RESETALL);
		
		for(i = 0; i < 2; i++){
			foreground(BLACK);
			background(WHITE);
			printf("|");
			for(j = 0; j < 21; j++){
				foreground(BLACK);
				if(i == 0 && j > 14){
					background(BLUE);
					
					t->matriz[j][3] == 0 ? printf("<-|") : printf(" %d|" ,t->matriz[j][3]);
					style(RESETALL);
				}
				else if(i == 1 && (j == 0 || j >= 14)){
					if(j>14){
						background(BLUE);
					}
					if(j == 0){
						printf("__");
						
					}else{
						
						printf("  ");
					}
					background(BLUE);
					if(j == 0){
						background(WHITE);
					}
					printf("|");
					style(RESETALL);
				}
				else if(i ==0 && j == 14){
					printf("  ");
					background(BLUE);
					printf("|");
				}
				else if(i == 0 && j == 0){
					background(WHITE);
					t->matriz[j][3] == 0 ? printf("  |") : printf(" %d|", t->matriz[j][3]);
					style(RESETALL);
				}
				else if(i == 1){
					background(BLACK);	
					printf("   ");
				}
				else{
					background(BLACK);	
					printf("   ");
				}
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			foreground(BLACK);
			background(WHITE);
			printf("|");
			for(j = 0; j < 21; j++){
				
				if(i%2 == 1){
					printf("  |");
				}
				else{
					t->matriz[j][4] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[j][4]);
				}
			}
			printf("\n");
		}
		style(RESETALL);		
	    printf("                                                          \n");
	    
		t->jogadorB.peca1.x == -1? printf("                                          peça1: base  ") : printf("                                     peça1: x:0%d y:%d%d  ", t->jogadorB.peca1.x, t->jogadorB.peca1.y/10, t->jogadorB.peca1.y%10);
		background(BLUE);
		printf("        \n");	
		style(RESETALL);
		printf("                                                        ");
		background(BLUE);
		printf("   %s   \n", t->jogadorB.peca1.x == -1 ? t->jogadorB.peca1.representacao : "  ");
		style(RESETALL);
		printf("                                                        ");
		background(BLUE);
		printf("   %s   \n", t->jogadorB.peca2.x == -1 ? t->jogadorB.peca2.representacao : "  ");
		style(RESETALL);
		t->jogadorB.peca2.x == -1? printf("                                          peça2: base  ") : printf("                                     peça2: x:0%d y:%d%d  ", t->jogadorB.peca2.x, t->jogadorB.peca2.y/10, t->jogadorB.peca2.y%10);	
		background(BLUE);
		printf("        \n\n");	
		style(RESETALL);
	}


	void geraTabuleiro(tabuleiro *t) {

		//Preenche o tabuleiro com 0 (nenhuma peca em todas as casas)
	    int i, j;
		int x, y;
	    for (i = 0; i < 5; i++) {
			for (j = 0; j < 21; j++) {
		    	t->matriz[j][i] = 0;
			}
	    }
		//Gera os locais da armadilha
		for(i = 0; i < 5; i++){
			x = rand() % 5;
			if(x == 0 || x == 4){
				y = rand() % 21;
				if(y == 1 && x == 0){
					y++;	
				}
				if(y == 19 && x == 4){
					y--;	
				}
			}
			else{
				y = rand() % 2;
				if(y == 1){
					y = 20;
				}
			}
			t->armadilhas[y][x] = 1;
		}
	}

	/**
	 * ... Funcao que modela dado simples ...
	 * @return Valor entre 1 e 6
	 */
	int rodaDado() {
	    int saidaDado = (rand() % 6)+1;
	    return saidaDado;
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
		srand(time(NULL));
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

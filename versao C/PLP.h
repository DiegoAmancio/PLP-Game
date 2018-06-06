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
	#define RESETALL printf("\033[0m")
	
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
	    int matriz[21][5];
		int armadilhas[21][5];
	} tabuleiro;
	
	int vez_do_timeB = 0;
	
	int movePeca(tabuleiro *t, int qtdeCasas,int versusBot);
	void voltePeca(tabuleiro *t, peca *p, int qtdeCasas);
	int moveTimeA(tabuleiro *t, peca *p, int qtdeCasas,int numeroPeca);
	int moveTimeB(tabuleiro *t, peca *p, int qtdeCasas,int versusBot,int numeroPeca);
	void printaTabuleiro(tabuleiro *t);
	void jogo();
	
	/**
	 * volta uma peça no tabuleiro
	 * @param t tabuleiro
	 * @param p peça
	 * @param qtdeCasas quantidade de casas que a peça irá voltar
	 */
	void voltePeca(tabuleiro *t, peca *p, int qtdeCasas){
		
		if(p->time == 'A'){

			t->matriz[p->y][p->x]--;
		
			if(p->y == 0){
				while(p->x < 4 && qtdeCasas > 0){
					p->x++;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}

			if(p->x == 4){
				while(p->y < 20 && qtdeCasas > 0){
					p->y++;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}

			if(p->y == 20){ 
				while(p->x > 0 && qtdeCasas > 0){
					p->x--;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}
			
			if(p->x == 0){ 
				while(p->y > 1 && qtdeCasas > 0){
					p->y--;
					qtdeCasas--;
					p->casasAndadas--;
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
					p->casasAndadas--;
				}
			}
			if(p->x == 0){
				while(p->y > 0 && qtdeCasas > 0){
					p->y--;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}

			if(p->y == 0){
				while(p->x < 4 && qtdeCasas > 0){
					p->x++;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}

			if(p->x == 4){
				while(p->y < 19 && qtdeCasas > 0){
					p->y++;
					qtdeCasas--;
					p->casasAndadas--;
				}
			}

			t->matriz[p->y][p->x]++;
		}
	}
	/**
	 * gera e roda a armadilha da vez
	 * @param tab tabuleiro
	 * @param pecaPega peça
	 * @param numdado numero que saio no dado na jogada
	 * @param versusBot determina se o bot esta jogando
	 */
	void geraArmadilha(tabuleiro *tab, peca *pecaPega, int numdado,int versusBot){
		int numArmadilha = (rand() % 5)+1;
		
		if (numArmadilha == 1){
			
		if (numdado != 6){
			printf("Armadilha: Desvio na avenida local! \n sua peça foi bloqueada por isso terá que esperar,vc perdeu essa jogada se a peça antes da jogada estiver no tabuleiro\n");
	
			sleep(5);
			voltePeca(tab,pecaPega,numdado);
			
			
		}
		}else if (numArmadilha == 2){
			
			printf("Armadilha Greve dos caminhoneiros!!\n Gasolina Acabando e o posto a frente cobra muito caro! \n Retorne 2 espaços para abastecer no posto anterior\n");
			printf("Sua peça voltou 2 espaços");
			sleep(5);
			voltePeca(tab,pecaPega,2);
			
		
		}else if (numArmadilha == 3){
			printf("Armadilha: Blitz na Rodovia! \n Se tirou par no Dado, indica que você tem carteira e foi liberado, caso não, pagou multa de 5 espaços\n");
			if (numdado % 2 != 0){
					printf("sua peça voltou 5 espaços\n");
					sleep(5);
					voltePeca(tab,pecaPega,5);
					
					
			}
		}else if (numArmadilha == 4){
			printf("Armadilha: Dia de Emplacamento! \n Pague o Emplacamento e volte a metade da quantidade de casas que você andou até agora!\n");
			
			voltePeca(tab,pecaPega,(pecaPega->casasAndadas) / 2);
			
			sleep(5);
			if(pecaPega->casasAndadas == 0){
				printf("Como a sua peça não andou ainda no tabuleiro a armadilha não teve efeito\n");
			}else{
				printf("Sua peça voltou %d espaços",(pecaPega->casasAndadas) / 2);
			}
			sleep(5);
		}
		
		else if (numArmadilha == 5){
			printf("Armadilha Positiva :\n Deu Sorte: Carona na abertura de ambulancia!\nSua peça se moveu de forma bônus mais %d espaços\n",numdado);
		
			sleep(5);
			movePeca(tab,numdado,versusBot);
			
		}
	
	}
	/**
	 * tenta mover uma peça do time A
	 * @param t tabuleiro
	 * @param p peça
	 * @param qtdeCasas quantidade de casas que a peça irá avançar
	 * @param numeroPeca determina se a peça é 1 ou 2
	 * 
	 * @return retorna se o movimento foi valido ou não
	 */
	int moveTimeA(tabuleiro *t, peca *p, int qtdeCasas,int numeroPeca){
		

		if(p->x == -1 && qtdeCasas == 6){ 
			p->x = 0;
			p->y = 1;
			t->matriz[1][0]++; 
			vez_do_timeB = !vez_do_timeB; 
			qtdeCasas = 0; 
			p->casasAndadas = 0;
		}
		int dado = qtdeCasas;
		
		if(p->x == -1 && qtdeCasas < 6){
			printf("Para a peça %d sair da base é necessário tirar 6 no dado\n",numeroPeca);
			return 0;
		}
		if(p->x == 1 && p->y < 6 && p->y+qtdeCasas > 6){ 
		}
		if(p->x == 1 && p->y == 6){ 
			printf("Peca %d ja terminou o trajeto\n",numeroPeca);
			return 0;
		}
		if(qtdeCasas == 6){
			vez_do_timeB = !vez_do_timeB;
		}
		t->matriz[p->y][p->x]--; 
		
		if(p->x == 0){ 
			while(p->y < 20 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->y == 20){ 
			while(p->x < 4 && qtdeCasas > 0){
				p->x++;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->x == 4){ 
			while(p->y > 0 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->y == 0){
			while(p->x > 1 && qtdeCasas > 0){
				p->x--;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->x == 1 && p->y < 6){
			while(p->y < 6 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		
		if(p->x == 1 && p->y == 6){
			vez_do_timeB = !vez_do_timeB;
		} 
		if(t->matriz[p->y][p->x] == 1){ 
			if(t->jogadorB.peca1.x == p->x && t->jogadorB.peca1.y == p->y){
				t->jogadorB.peca1.x = -1;
				t->jogadorB.peca1.y = -1;						
				t->jogadorB.peca1.casasAndadas = 0;
				t->matriz[p->y][p->x] = 0;
			}
			else if(t->jogadorB.peca2.x == p->x && t->jogadorB.peca2.y == p->y){
				t->jogadorB.peca2.x = -1;
				t->jogadorB.peca2.y = -1;	
				t->jogadorB.peca2.casasAndadas = 0;
				t->matriz[t->jogadorA.peca1.y][t->jogadorA.peca1.x] = 0;
			}
		}
		t->matriz[p->y][p->x]++; 
		if(t->armadilhas[p->y][p->x]){
			geraArmadilha(t, p, dado,0);
		}
		return 1;
	}

	/**
	 * move uma peça do time B
	 * @param t tabuleiro
	 * @param p peça
	 * @param qtdeCasas quantidade de casas que a peça irá avançar
	 * @param numeroPeca determina se a peça é 1 ou 2
	 * 
	 *@return retorna se o movimento foi valido ou não
	 */
	int moveTimeB(tabuleiro *t, peca *p, int qtdeCasas,int versusBot,int numeroPeca){

		int dado = qtdeCasas;
		if(p->x == -1 && qtdeCasas == 6){
			p->x = 4;
			p->y = 19;
			t->matriz[19][4]++;
			vez_do_timeB = !vez_do_timeB;	
			qtdeCasas = 0;				
		}
		
		if(p->x == -1 && qtdeCasas < 6){
			if(versusBot == 0 ){
				printf("Para a peça %d sair da base é necessário tirar 6 no dado\n",numeroPeca);
			}
			return 0;
		}
		if(p->x == 3 && p->y > 14 && p->y-qtdeCasas < 14){
			return 0;
		}
		if(p->x == 3 && p->y == 14){
			if(versusBot == 0 ){
				printf("Peca %d ja terminou o trajeto\n",numeroPeca);
			}
			return 0;
		}
		if(qtdeCasas == 6){
			vez_do_timeB = !vez_do_timeB;
		}
		t->matriz[p->y][p->x]--;
		if(p->x == 4){
			while(p->y > 0 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->y == 0){
			while(p->x > 0 && qtdeCasas > 0){
				p->x--;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}

		if(p->x == 0){
			while(p->y < 20 && qtdeCasas > 0){
				p->y++;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->y == 20){
			while(p->x < 3 && qtdeCasas > 0){
				p->x++;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		
		if(p->x == 3 && p->y > 14){
			while(p->y > 14 && qtdeCasas > 0){
				p->y--;
				qtdeCasas--;
				p->casasAndadas++;
			}
		}
		if(p->x == 3 && p->y == 14){
			vez_do_timeB = !vez_do_timeB;
		} 
		if(t->matriz[p->y][p->x] == 1){
			if(p->x == t->jogadorA.peca1.x && p->y == t->jogadorA.peca1.y){
				t->jogadorA.peca1.x = -1;
				t->jogadorA.peca1.y = -1;			
				t->jogadorA.peca1.casasAndadas = 0;							
				t->matriz[p->y][p->x] = 0;
			}
			else if(p->x == t->jogadorA.peca2.x && p->y == t->jogadorA.peca2.y){
				t->jogadorA.peca2.x = -1;
				t->jogadorA.peca2.y = -1;	
				t->jogadorA.peca2.casasAndadas = 0;
				t->matriz[p->y][p->x] = 0;
			}
		}
		t->matriz[p->y][p->x]++;
		if(t->armadilhas[p->y][p->x]){
			geraArmadilha(t, p, dado,versusBot);
		}
		return 1;
	}
	/**
	 * move uma peça 
	 * @param t tabuleiro
	 * @param qtdeCasas quantidade de casas que a peça irá avançar
	 * @param versusBot determina se o bot esta jogando ou nãp
	 * 
	 * @return retorna se o movimento foi valido ou não
	 */
	int movePeca(tabuleiro *t, int qtdeCasas,int versusBot) {
			
		int numPeca; 
		
		if(vez_do_timeB == 0){ 
			if(t->jogadorA.peca1.x == -1 && t->jogadorA.peca2.x == -1 && qtdeCasas != 6){ 
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
		}else{
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
			if(versusBot == 1){
				numPeca = (rand() % 2)+1;
			}	
			
		}
		if(versusBot == 0 || (vez_do_timeB == 0)){
			while(1){
					printf("Escolha uma peça pra mover 1 ou 2: ");
					setbuf(stdin, NULL); 
					scanf("%d", &numPeca);
					printf("\n");
					if(numPeca == 1 || numPeca == 2){
						break;
					}
					else{
						printf("Peça Invalida \n escolha uma peça valida para o movimento\n");
					}
				}
		}
		if(vez_do_timeB == 0){
				
			if(numPeca == 1){
				return moveTimeA(t, &(t->jogadorA.peca1), qtdeCasas,1);
			}
			if(numPeca == 2){
				return moveTimeA(t, &(t->jogadorA.peca2), qtdeCasas,2);
			}
		}else{
			if(numPeca == 1){
				return moveTimeB(t, &(t->jogadorB.peca1), qtdeCasas, versusBot,1);
			}
			if(numPeca == 2){
				return moveTimeB(t, &(t->jogadorB.peca2), qtdeCasas, versusBot,2);
			}
		}
		return 1;
	}

	/**
	 * imprime o tabuleiro
	 * @param t tabuleiro
	 */
	void printaTabuleiro(tabuleiro *t) {

	    int i, j;
	   
	    background(GREEN);
	    printf("        ");
	    
	    style(RESETALL);
		printf("  casa inicial para o time verde => x:00 y:01\n");
		
		background(GREEN);
		printf("   %s   ", t->jogadorA.peca1.x == -1 ? "A1" : "  ");
		style(RESETALL);
		if(t->jogadorA.peca1.x == 1 && t->jogadorA.peca1.y == 6){
			printf("  peça1: final\n");
		}
		else{
			t->jogadorA.peca1.x == -1? printf("  peça1: base\n") : printf("  peça1: x:0%d y:%d%d\n", t->jogadorA.peca1.x, t->jogadorA.peca1.y/10, t->jogadorA.peca1.y%10);
		}
		background(GREEN);
		printf("   %s   \n", t->jogadorA.peca2.x == -1 ? "A2" : "  ");
		printf("        ");
		style(RESETALL);
		
	   	if(t->jogadorA.peca2.x == 1 && t->jogadorA.peca2.y == 6){
			printf("  peça2: final\n");
		}
		else{
			t->jogadorA.peca2.x == -1? printf("  peça2: base\n") : printf("  peça2: x:0%d y:%d%d\n", t->jogadorA.peca2.x, t->jogadorA.peca2.y/10, t->jogadorA.peca2.y%10);
		}
		printf("\n   ");
		for(i = 0; i < 21; i++){
			if(i < 10){
				printf("0");
			}
			printf("%d ",i);
			
		}
		
		
		printf("\n");
		
		for(i = 0; i < 2; i++){
			style(RESETALL);
			printf("00");
			background(WHITE);
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
		
		
		for(i = 0; i < 2; i++){
			style(RESETALL);
			printf("01");
			
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
					if(j >=6 && j < 10){
						background(GREEN);	
					}else if(j > 10 && j < 15){
						background(BLUE);	
					}else if( j == 10){
						background(YELLOW);
					}else{
						background(BLACK);
					}
					
					printf("   ");
					
				}
				
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			style(RESETALL);
			printf("02");
			
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
					if(j >=6 && j < 10){
						background(GREEN);	
					}else if(j > 10 && j < 15){
						background(BLUE);	
					}else if( j == 10){
						background(YELLOW);
					}else{
						background(BLACK);
					}
					printf("   ");
				}
					
			}
			
			printf("\n");
			
			
		}
		
		for(i = 0; i < 2; i++){
			style(RESETALL);
			printf("03");
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
				else{
					if(j >=6 && j < 10){
						background(GREEN);	
					}else if(j > 10 && j < 15){
						background(BLUE);	
					}else if( j == 10){
						background(YELLOW);
					}else{
						background(BLACK);
					}	
					printf("   ");
			    }
				
					
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			style(RESETALL);
			printf("04");
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
		printf("   ");
		for(i = 0; i < 21; i++){
			if(i < 10){
				printf("0");
			}
			printf("%d ",i);
			
		}
		
	    printf("                                                         \n");
		

		style(RESETALL);
		 if(t->jogadorB.peca1.x == 3 && t->jogadorB.peca1.y == 14){
			printf("                                         peça1: final  ");
		}
		else{
			t->jogadorB.peca1.x == -1? printf("                                          peça1: base  ") : printf("                                     peça1: x:0%d y:%d%d  ", t->jogadorB.peca1.x, t->jogadorB.peca1.y/10, t->jogadorB.peca1.y%10);
		} 
		background(BLUE);
		printf("        \n");
		style(RESETALL);	
		printf("                                                       ");
		background(BLUE);
		printf("   %s   \n", t->jogadorB.peca1.x == -1 ? "B1" : "  ");
		style(RESETALL);
		if(t->jogadorB.peca2.x == 3 && t->jogadorB.peca2.y == 14){
			printf("                                         peça2: final  ");
		}
		else{
			t->jogadorB.peca2.x == -1? printf("                                          peça2: base  ") : printf("                                     peça2: x:0%d y:%d%d  ", t->jogadorB.peca2.x, t->jogadorB.peca2.y/10, t->jogadorB.peca2.y%10);	
		}
		background(BLUE);
		printf("   %s   \n", t->jogadorB.peca2.x == -1 ? "B2" : "  ");
		style(RESETALL);
		printf("  	   casa inicial para o time verde => x:04 y:19 ");
		background(BLUE);
		printf("        \n\n");	
		style(RESETALL);
	}

	/**
	 * Preenche o tabuleiro com 0(determina que não tem peça na casa) em todas as casas e gera o local da armadilha da jogada
	 * @param t tabuleiro
	 */
	void geraTabuleiro(tabuleiro *t) {

	    int i, j;
		int x, y;
	    for (i = 0; i < 5; i++) {
			for (j = 0; j < 21; j++) {
		    	t->matriz[j][i] = 0;
				t->armadilhas[j][i] = 0;
			}
	    }
		
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
	/**
	 * executa o jogo solo ou multiplayer
	 * @param versusBot determina se o bot esta jogando
	 */
	void jogo(int versusBot) {
		
	    peca peca1A;
	    peca peca2A;
	    peca peca1B;
	    peca peca2B;

	   
	    jogador jogadorA;
	    jogador jogadorB;

	    
	    tabuleiro tabuleiro;

	
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
	
	    int dado;
	    int continua = 1;
		char p[1000];
		while (continua) {
			
			system("clear"); 
			printaTabuleiro(&tabuleiro);
			dado = rodaDado();
			
			if(!versusBot){
				if(!vez_do_timeB){
					printf("Vez do Player 1  => digite qualquer coisa para rodar o dado ou desistir para sair:\n");
				}else{
					printf("Vez do Player 2 => digite qualquer coisa para rodar o dado ou desistir para sair:\n");
					
				}
				
			}else{
				if(vez_do_timeB == 0){
					printf("Sua vez => digite qualquer coisa para rodar o dado ou desistir para sair:\n");
				}else{
					sleep(1);
					printf("Vez do bot : o bot vai jogar o dado...\n");
					sleep(3); 
				}
				
			}
			
			if((versusBot && vez_do_timeB == 0) || (versusBot == 0)){	
				
				setbuf(stdin, NULL); 
				scanf("%[^\n]s", p); 
				
				if (strcmp(p, "desistir") == 0) { 
					if(versusBot){
						printf("Você desistiu, consequentemente... Voce perdeu!\n");
					}else{
					
						if(!vez_do_timeB){
							printf("Player 1 desistiu\n");
							printf("Player 2 ganhou\n");
							
						}else{
							printf("Player 2 desistiu\n");
							printf("Player 1 ganhou\n");
						}
						
						
					}
					
					break;
				}
			}
			
			printf("Saiu no dado %d\n", dado);
			sleep(1);
			
			while(1){ 
				if (movePeca(&tabuleiro, dado,versusBot)){
					break;
				}
				else{
					printf("Movimento invalido\n");
				}
			}
		
			if(tabuleiro.matriz[6][1] == 2){ 
					if(!versusBot){
						printf("Parabens, player 1 ganhou!!\n");
					}else{
						printf("Parabens, voce ganhou!!\n");
						
					}
				break;
			}
	

			if(tabuleiro.matriz[14][3] == 2){
				if(versusBot){
					printf("Parabens, player 2 ganhou!!\n");
				}else{
					printf("Voce perdeu :(\n");
						
				}
				
				
				break;
			}
			
			vez_do_timeB = !vez_do_timeB;
		
		}
		
	}
	

#endif  /*PLP_H*/

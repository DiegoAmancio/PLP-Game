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
	 * ... retorna a quantidade de pecas ocupadas na posicao dada ...
	 *
	 * @param t o tabuleiro do jogo
	 * @param posicao qual celula a verificar
	 * @param timeOcupado o time no qual quer verificar se estah ocupado
	 * @return a quantidade de pecas na celula dada [0-2]
	 */
	int qtdeOcupado(tabuleiro *t, int posicao, char timeOcupado) {
	    int qtde = 0;
	    jogador jogadorOcupado;
	    if (timeOcupado == PLAYER_A) {
		jogadorOcupado = t->jogadorA;
	    } else {
		jogadorOcupado = t->jogadorB;
	    }

	    qtde += (jogadorOcupado.peca1.casasAndadas == posicao);
	    qtde += (jogadorOcupado.peca2.casasAndadas == posicao);

	    return qtde;
	}

	/**
	 *  ... Move a peca a quantidade dada de casas indicadas  ...
	 * @param pecaAMover a peca a ser movimentada
	 * @param qtdeCasas A quantidade de casas a ser movido
	 * @return Retorna ERRO se nao for possivel mover
	 */
	int movePeca(peca *pecaAMover, char qtdeCasas) {
	    char status = ERRO;
	    char posicaoInicial = pecaAMover->casasAndadas;
	    //TODO: VERIFICAR SE EH POSSIVEL VOLTAR CASAS
	    char posicaoAbsoluta = (pecaAMover->time == PLAYER_A) ? posicaoInicial : (posicaoInicial + OFFSET_PLAYER_B) %
		                                                                     INDICE_MAXIMO_TABULEIRO;
	    char novaPosicao = posicaoAbsoluta + qtdeCasas;
	    if (novaPosicao >= 0 && novaPosicao <= INDICE_MAXIMO_TABULEIRO) {
		pecaAMover->casasAndadas = novaPosicao;
		status = SEM_ERRO;
	    }
	    return status;
	}

	/**
	 *  ... Move a peca para o inicio  ...
	 *  .... Na forma de numero de casas + (-numero de casas) totalizando zero ...
	 * @param pecaAMover a peca a ser movimentada
	 * @param qtdeCasas A quantidade de casas a ser movido
	 * @return Retorna ERRO se nao for possivel mover
	 */
	int voltaParaInicio(peca *pecaAMover) {
	    return movePeca(pecaAMover, -pecaAMover->casasAndadas);
	}

	/**
	 * ... Verifica se todas as pecas do jogador dado estao na ultima celula ...
	 * @param t o tabuleiro do jogo
	 * @param jogador o jogador a ser verificado se ganhou (Note que utiliza as macros PLAYER_ definida no inicio do cod )
	 * @return Booleano definido na macro no inicio do codigo
	 */
	char ganhou(jogador j) {
	    return (j.peca1.casasAndadas == INDICE_MAXIMO_TABULEIRO) && (j.peca2.casasAndadas == INDICE_MAXIMO_TABULEIRO);
	}

	/**
	 * ... Verifica se pode comer peca do adversario ...
	 * @param t o tabuleiro do jogo
	 * @param pecaComedora a peca movida que quer verificar se pode comer alguma outra
	 * @return Booleano definido na macro no inicio do codigo se for possivel comer peca adversaria
	 */
	char podeComer(tabuleiro t, peca pecaComedora) {
	    char adversario = (pecaComedora.time == PLAYER_A) ? PLAYER_B : PLAYER_A;
	    return qtdeOcupado(&t, pecaComedora.casasAndadas, adversario) == 1;
	}

	void printaTabuleiro(tabuleiro *t) {

	    int i, j;
		
	    printf(" ______ \n");
		t->jogadorA.peca1.x == -1? printf("|      |  peca1: base\n") : printf("|      |  peca1: x:%d y:%d\n", t->jogadorA.peca1.x, t->jogadorA.peca1.y);
		printf("|  %s  |\n", t->jogadorA.peca1.x == -1 ? t->jogadorA.peca1.representacao : "  ");
		printf("|  %s  |\n", t->jogadorA.peca2.x == -1 ? t->jogadorA.peca2.representacao : "  ");
		t->jogadorA.peca2.x == -1? printf("|______|  peca2: base\n") : printf("|______|  peca2: x:%d y:%d\n", t->jogadorA.peca2.x, t->jogadorA.peca2.y);
		
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
					t->matriz[0][j] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[0][j]);
				}
			}
			printf("\n");
		}
		
		for(i = 0; i < 2; i++){
			printf("|");
			for(j = 0; j < 21; j++){
				
				if(i == 0 && j < 6){
					t->matriz[1][j] == 0 ? printf("->|") : printf(" %d|" ,t->matriz[1][j]);
				}
				else if(j == 19){
					printf("  |");
				}
				else if(i == 0 && j ==20){
					t->matriz[1][j] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[1][j]);
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
					t->matriz[2][j] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[2][j]);
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
					t->matriz[3][j] == 0 ? printf("<-|") : printf(" %d|" ,t->matriz[3][j]);
				}
				else if(i == 1 && (j == 0 || j >= 14)){
					printf("__|");
				}
				else if(i == 0 && (j == 0 || j == 14)){
					t->matriz[3][j] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[3][j]);
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
					t->matriz[4][j] == 0 ? printf("  |") : printf(" %d|" ,t->matriz[4][j]);
				}
			}
			printf("\n");
		}		
	    printf("                                                         ______ \n");
		t->jogadorB.peca1.x == -1? printf("                                           peca1: base  |      |\n") : printf("                                        peca1: x:%d y:%d  |      |\n", t->jogadorB.peca1.x, t->jogadorB.peca1.y);	
		printf("                                                        |  %s  |\n", t->jogadorB.peca1.x == -1 ? t->jogadorB.peca1.representacao : "  ");
		printf("                                                        |  %s  |\n", t->jogadorB.peca2.x == -1 ? t->jogadorB.peca2.representacao : "  ");
		t->jogadorB.peca1.x == -1? printf("                                           peca1: base  |______|\n\n") : printf("                                        peca1: x:%d y:%d  |______|\n\n", t->jogadorB.peca1.x, t->jogadorB.peca1.y);	

	}

	void geraTabuleiro(tabuleiro *t) {

	    int i, j;
	    for (i = 0; i < 5; i++) {
			for (j = 0; j < 21; j++) {
		    	t->matriz[i][j] = 0; //Sim, realmente é [i][j], bizarro
			}
	    } //Define tudo como 0, quando tiver alguem será 1
	    //Se quiser pode gerar as armadilhas ja aqui
	}

	/**
	 * ... Funcao que modela dado simples ...
	 * @return Valor entre 1 e 6
	 */
	int rodaDado() {
	    srand(time(0));
	    int saidaDado = rand() % 7;
	    if(saidaDado == 0){
			saidaDado++;
	    }
	    return saidaDado;
	}


	void singlePlayer() {
		
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
	    int dadoA, dadoB;
		char p[1000];
	    while (1) {

		printaTabuleiro(&tabuleiro);
		printf("\nsua vez\n");
		printf("\ndigitar qualquer coisa para rodar o dado ou desistir para sair:\n");
		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado
		if (strcmp(p, "desistir") == 0) { //desistir do jogo
		    break;
		}
		system("clear"); //limpa a tela
		
		dadoA = rodaDado();
		printf("\nSaiu no dado %d\n", dadoA);
		printf("vez do bot\no bot joga o dado...");
		
		sleep(2);
		dadoB = rodaDado();
		printf("\nSaiu no dado %d\n", dadoB);
		
	    }
	}


	void multiPlayer() {

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
	    while (TRUE) {

		printaTabuleiro(&tabuleiro);


		setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
		scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado

		if (strcmp(p, "desistir") == 0) { //desistir do jogo
		    break;
		}
		system("clear"); //limpa a tela
	    }
	}

#endif  /*PLP_H*/

#include <stdio.h>
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
    int casasAndadas; //Quando chegar em 56 (algo assim) o jogador vence
    char time; //Para representar as peças no tabuleiro
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
int qtdeOcupado(tabuleiro t, int posicao, char timeOcupado) {
    int qtde = 0;
    jogador jogadorOcupado;
    if (timeOcupado == PLAYER_A) {
        jogadorOcupado = t.jogadorA;
    } else {
        jogadorOcupado = t.jogadorB;
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
    return qtdeOcupado(t, pecaComedora.casasAndadas, adversario) == 1;
}

void printaTabuleiro(tabuleiro *t) {

    int i, j;

    //print jogador A

    //print jogador B
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
    return rand() % 6 + 1;
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

        printf("digitar qualquer coisa para rodar o dado ou desistir para sair");
        setbuf(stdin, NULL); //limpa todo o lixo que tava pendente no scanf
        scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado
        if (strcmp(p, "desistir") == 0) { //desistir do jogo
            break;
        }
        system("clear"); //limpa a tela

        printf("\nTeste1\n");
        printf("\nValor do dado %d\n", rodaDado());
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
                printf("teste1\n");
                break;
            case 4  :
                printf("teste2\n");
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

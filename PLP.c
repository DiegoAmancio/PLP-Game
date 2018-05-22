#include <stdio.h>
#include <string.h>
#include <stdlib.h>// necessario p as funçoes rand() e srand()
#include <time.h> //necessario p funçao time()


#ifndef FALSE
#define FALSE (0)
#define TRUE (!(FALSE))
#endif

#define ERRO -1
#define SEM_ERRO 0


//IDENTIFICADORES DO JOGADOR
const char PLAYER_A = 10;
const char PLAYER_B = 20;

// PARA ABORDAGEM UTILIZANDO ARRAY SIMPLES TEM-SE UMA DISTANCIA DE 26 CASAS DO INICIO DE UM PARA O DO OUTRO ADVERSARIO
#define OFFSET_PLAYER_B 26
// TAMANHO DO TABULEIRO COM 51 CELULAS SEM O "CAMINHO DOURADO"
#define TAMANHO_TABULEIRO 51
#define INDICE_MAXIMO_TABULEIRO (TAMANHO_TABULEIRO-1)
//TAMANHO
#define TAMANHO_CAMINHO_DOURADO 6
#define INDICE_MAXIMO_CAMINHO_DOURADO (TAMANHO_CAMINHO_DOURADO-1)
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
    char matriz[TAMANHO_TABULEIRO][4]; //TABULEIRO COM 4 SLOTS EM CADA CELULA PARA REPRESENTAR OS ESPACOS PARA
    // ... CADA PECA ORGANIZADO NO SENTIDO [ A1, A2, B1, B2 ]
    char caminho_dourado[TAMANHO_CAMINHO_DOURADO][4]; //CAMINHO DOURADO COM 4 SLOTS EM CADA CELULA PARA REPRESENTAR OS ESPACOS PARA
    /* ... CADA PECA ORGANIZADO NO SENTIDO [ A1, A2, B1, B2 ], assim:
     *  o caminho_dourado[x][i] referesse a i-esima peca citada acima da x-esima celula
    */
} tabuleiro;

/**
 * ... Verifica se a posicao dada possui a peca especificada ...
 *
 * @param matrizAChecar A matriz a checar se estah ocupado
 * @param posicao qual celula a verificar
 * @param o indice de qual peca da celula a verificar
 */
int ocupado(char *matrizAChecar[], int posicao, int peca) {
    return matrizAChecar[posicao][peca];
}
/**
 *  ... Move a peca a quantidade dada de casas indicadas  ...
 * @param t
 * @param posicaoInicial A sua posicao de partida para o movimento
 * @param qtdeCasas A quantidade de casas a ser movido
 * @param jogador O identificador (definido em macro) do jogador para poder calcular sua posicao na matriz
 * @param peca a peca a ser movida
 * @return Retorna ERRO se nao for possivel mover
 */
int movePeca(tabuleiro *t, char posicaoInicial, char qtdeCasas, int jogador, int peca) {
    //TODO: Desta forma a peca nao volta de um array dourado para o comum
    char status = ERRO;
    char posicaoAbsoluta = (jogador == PLAYER_A) ? posicaoInicial : (posicaoInicial % OFFSET_PLAYER_B);
    char novaPosicao = posicaoAbsoluta + qtdeCasas;
    if (novaPosicao <= INDICE_MAXIMO_TABULEIRO) {
        t->matriz[posicaoInicial][peca] = FALSE;
        t->matriz[novaPosicao][peca] = TRUE;
        status = SEM_ERRO;
    }else if(novaPosicao <= INDICE_MAXIMO_TABULEIRO+INDICE_MAXIMO_CAMINHO_DOURADO){
        //Caso passe para o caminho dourado
        t->matriz[posicaoInicial][peca] = FALSE;
        t->caminho_dourado[novaPosicao][peca] = TRUE;
    }
    return status;
}

/**
 * ... Verifica se todas as pecas do jogador dado estao na ultima celula ...
 * @param t o tabuleiro do jogo
 * @param jogador o jogador a ser verificado se ganhou (Note que utiliza as macros PLAYER_ definida no inicio do cod )
 * @return Booleano definido na macro no inicio do codigo
 */
char ganhou(tabuleiro t, int jogador) {
    int i, limite;
    if (jogador == PLAYER_A) {
        i = 0;
        limite = 2;
    } else {
        i = 2;
        limite = 4;
    }
    char qtdePecasNaCelula = 0;
    for (; i < limite; ++i) {
        if (ocupado(t.caminho_dourado, INDICE_MAXIMO_CAMINHO_DOURADO, i)) qtdePecasNaCelula++;
    }
    return qtdePecasNaCelula == MAX_PECAS_JOGADOR;
}

/**
 * ... Verifica se pode comer peca do adversario ...
 * @param t o tabuleiro do jogo
 * @param posicao o indice da celula no qual quer verificar
 * @param jogador o jogador a ser verificado se pode comer (Note que utiliza as macros PLAYER_ definida no inicio do cod )
 * @return Booleano definido na macro no inicio do codigo
 */
char podeComer(tabuleiro t, int posicao, char jogador) {
    int i, limite;  //as pecas a serem verificadas dependem de ql jogador que quer comer
    if (jogador == PLAYER_A) {
        i = 2;
        limite = 4;
    } else {
        i = 0;
        limite = 2;
    }
    int qtdePecaAdversario = 0;
    for (; i < limite; ++i) {
        if (ocupado(t.matriz, posicao, i)) qtdePecaAdversario++;
    }
    return qtdePecaAdversario == 1;
}

void printaTabuleiro(tabuleiro *t) {

    int i, j;

    //print jogador A

    //print jogador B
}

void geraTabuleiro(tabuleiro *t) {

    int i, j;
    for (int i = 0; i < TAMANHO_TABULEIRO; i++) {
        for (int j = 0; j < 2 * MAX_PECAS_JOGADOR; j++) {
            t->matriz[i][j] = FALSE; //Sim, realmente é [i][j], bizarro
        }
    } //Define tudo como 0, quando tiver alguem será 1
    //Se quiser pode gerar as armadilhas ja aqui

    // preenche o caminho dourado com False
    for (i = 0; i < TAMANHO_CAMINHO_DOURADO; i++) {
        for (j = 0; j < 2 * MAX_PECAS_JOGADOR; j++) {
            t->caminho_dourado[i][j] = FALSE;
        }
    }
}

// Modelagem do Dado
int rodaDado() {
    srand(time(0));
    return rand() % 6 + 1;
}


void singlePlayer() {

    //Cria as peças
    peca peca1A = {
            .casasAndadas = 0,
            .time = 'A'
    };
    peca peca2A = {
            .casasAndadas = 0,
            .time = 'A'
    };
    peca peca1B = {
            .casasAndadas = 0,
            .time = 'B'
    };
    peca peca2B = {
            .casasAndadas = 0,
            .time = 'B'
    };

    //Cria os jogadores
    jogador jogadorA;
    jogador jogadorB;

    //Cria o tabuleiro
    tabuleiro tabuleiro;

    //Atribuições

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
        printf("\ndigitar qualquer coisa para rodar o dado\n");
        scanf("%[^\n]s", p); //digitar qualquer coisa para rodar o dado

        printf("\nValor obtido: %d\n", rodaDado());
        if (strcmp(p, "desistir") == 0) { //desistir do jogo
            break;
        }
        system("clear"); //limpa a tela

        printf("\nTeste1\n");
    }
}

void multiPlayer() {

    //Cria as peças
    peca peca1A = {
            .casasAndadas = 0,
            .time = 'A'
    };
    peca peca2A = {
            .casasAndadas = 0,
            .time = 'A'
    };
    peca peca1B = {
            .casasAndadas = 0,
            .time = 'B'
    };
    peca peca2B = {
            .casasAndadas = 0,
            .time = 'B'
    };

    //Cria os jogadores
    jogador jogadorA;
    jogador jogadorB;

    //Cria o tabuleiro
    tabuleiro tabuleiro;

    //Atribuições

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

        printf("\ndigitar qualquer coisa para rodar o dado\n");
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

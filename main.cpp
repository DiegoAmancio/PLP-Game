#include <iostream>
#include <random>
#include <ctime>

using namespace std;

#define AZUL 1
#define VERDE 2

int rodaDado(){
    srand(time(0));
    return rand() % 6 + 1;
}

struct celula{
    short azul,verde;
};
struct celula tabuleiro[56];

void movePeao(short cor,int casas, bool crescente, int posicaoAtual){
    int novaPosicao = posicaoAtual + casas;
    if(cor == AZUL){
        tabuleiro[posicaoAtual].azul++;
    }else{
        crescente ? tabuleiro[posicaoAtual++].verde++ : tabuleiro[posicaoAtual++].verde--;

    }
}


int main() {
    for (int i = 0; i < sizeof(tabuleiro); ++i) {
        tabuleiro[i].azul = 0;
        tabuleiro[i].verde = 0;
    }
    return 0;
}
// Pra sair precisa de um 6
//  Pode jogar dados de novo comqndo tira 6
//  Ou "comendo" piao do adversario
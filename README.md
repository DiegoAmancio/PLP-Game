# Jogo de Ludo - PLP

[Versão em C](https://github.com/DiegoAmancio/PLP-Game/tree/master/versao%20C) |
[Versão em Haskell](https://github.com/DiegoAmancio/PLP-Game/tree/master/versao%20haskell) |
[Versão em Prolog](#)

Jogo de ludo do projeto de PLP

## Regras Gerais

* Os jogadores se revezam no sentido horário.

* A cada lance, o jogador decide qual peça mover, caso tenha mais de
uma em campo.

* Uma peca simplesmente se move no sentido horário direção ao redor da pista dada pelo numero lancado.

* Se nenhuma peça pode legalmente se mover de acordo com o número jogado, o jogo passa para o proximo jogador.

* Um lance de 6 no dado da direito ao outro turno.

* Um lance de 6 no dado da direito a colocar outra peça do banco no jogo caso tenha.

* Caso sua peça caia na mesma casa onde já exista outra peça, a outra peça e enviada novamente ao banco.

### Condição de Vitória

* O jogador que conseguir colocar suas duas pecas na parte central do tabuleiro ganha a partida!

## Compilando

Após o download do repositorio e estando no diretorio da versao C executar o comando `gcc PLP.c -o ludo`

## Executando

Após a compilação, você pode executar o jogo na seguinte forma:
* Em um terminal aberto no diretorio do binário gerado, executar o comando `./ludo`

## Integrantes

* Aislan Jefferson de Souza Brito
* Diego Amancio Pereira
* Gustavo Figueireido Lino
* Kleberson Canuto

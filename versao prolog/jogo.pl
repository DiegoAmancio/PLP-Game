:- initialization main.

make_peca(X,Y,Casas,Num,peca(X,Y,Casas,Num)).
make_jogador(Peca1, Peca2, Time, jogador(Peca1,Peca2,Time)).
make_tabuleiro(JogadorA, JogadorB, Matriz, tabuleiro(JogadorA,JogadorB,Matriz)).

get_x(peca(X,_,_,_),X).
get_y(peca(_,Y,_,_),Y).
get_casas(peca(_,_,Casas,_),Casas).
get_num(peca(_,_,_,Num),Num).

get_peca1(jogador(Peca1,_,_),Peca1).
get_peca2(jogador(_,Peca2,_),Peca2).
get_time(jogador(_,_,Time),Time).

get_jogadorA(tabuleiro(JogadorA,_,_),JogadorA).
get_jogadorB(tabuleiro(_,JogadorB,_),JogadorB).
get_matriz(tabuleiro(_,_,Matriz),Matriz).

contaJogador(Jog, X, Y, Ret) :-
    get_peca1(Jog, Peca1),
    get_peca2(Jog, Peca2),
    get_x(Peca1, Peca1X),
    get_x(Peca2, Peca2X),
    get_y(Peca1, Peca1Y),
    get_y(Peca2, Peca2Y).
/*    (Peca1X == X /\ Peca1Y == Y /\ Peca2X == X /\ Peca2Y == Y -> Ret = [2];
    (Peca1X == X /\ Peca1Y == Y) \/ (Peca2X == X /\ Peca2Y == Y) -> Ret = [1];
    Ret = [0] ).
    */

contaLinha(Jog1, Jog2, X, Y, Ret) :-
    Ret = [0].

gera_matriz(Jog1, Jog2, X) :-
    contaLinha(Jog1, Jog2, 0, 0, X1),
    contaLinha(Jog1, Jog2, 1, 0, X2),
    contaLinha(Jog1, Jog2, 2, 0, X3),
    contaLinha(Jog1, Jog2, 3, 0, X4),
    contaLinha(Jog1, Jog2, 4, 0, X5),
	X = [X1,X2,X3,X4,X5].

jogo(X):-
    repeat,
    (X == 0 -> write("Iniciando VS"),nl; write("Iniciando BOT"),nl),
	make_peca(-1,-1,0,1,Peca1A),
	make_peca(-1,-1,0,2,Peca2A),
	make_peca(-1,-1,0,1,Peca1B),
	make_peca(-1,-1,0,2,Peca2B),
	make_jogador(Peca1A,Peca2A,"A",JogadorA),
	make_jogador(Peca1B,Peca2B,"B",JogadorB),
	gera_matriz(JogadorA, JogadorB, Tab),
	make_tabuleiro(JogadorA,JogadorB,Tab,Tabuleiro),
    contaJogador(JogadorA, -1, -1, Num),
    write(Num),nl,
	write(Tabuleiro),nl,
    halt(0).

readHelp():-
    repeat,
    halt(0).

readRules():-
    repeat,
    halt(0).

main:-
    repeat,
    write("1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"),nl,
    read_line_to_codes(user_input, X1),
    string_to_atom(X1, X2),
    atom_number(X2, X),
    (X == 1 -> jogo(0); X == 2 -> jogo(1); X == 3 -> readHelp(); X == 4 -> readRules()),
    halt(0).

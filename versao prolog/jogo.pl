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

pecaAqui(Pec, X, Y, Ret) :-
	get_casas(Pec,Casas),
	get_num(Pec,Num),
	make_peca(X,Y,Casas,Num,Peca),
    (Pec == Peca -> Ret is 1; Ret is 0).

contaJogador(Jog, X, Y, Ret) :-
    get_peca1(Jog, Peca1),
    get_peca2(Jog, Peca2),
    pecaAqui(Peca1, X, Y, Peca1Aqui),
    pecaAqui(Peca2, X, Y, Peca2Aqui),
    Ret is Peca1Aqui + Peca2Aqui.	

contaLocal(Jog1, Jog2, X, Y, Ret) :-
	contaJogador(Jog1, X, Y, Jogador1),
	contaJogador(Jog2, X, Y, Jogador2),
	Ret is Jogador1 + Jogador2.

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
	write(Tabuleiro),nl,
    halt(0).

linhaTabuleiro(_,21,-1,Resposta):-write(Resposta),nl.
linhaTabuleiro(_,21,_,Resposta):-string_concat(Resposta,"|",Saida),write(Saida),nl.

linhaTabuleiro(_,Index,-1,Resposta):-string_concat(Resposta,"__ ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-1,Saida).

linhaTabuleiro(_,-1,0,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro(_,0,0,Saida).   
linhaTabuleiro([H|T],Index,0,Resposta):-write(H),validaPecaPrint(H,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,0,Saida).    

linhaTabuleiro(_,-1,1,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro(_,0,1,Saida).
linhaTabuleiro(_,Index,1,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,1,Saida).

validaPecaPrint(Numero,Saida):-number_string(Numero, ToString),string_concat("|",ToString,Concat),string_concat(Concat," ",Saida).
printTabuleiro():- write("   "),
    linhaTabuleiro([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],0,-1,""),
    linhaTabuleiro([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],-1,0,""),
    linhaTabuleiro([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],-1,1,"").
    

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
    printTabuleiro,
    (X == 1 -> jogo(0); X == 2 -> jogo(1); X == 3 -> readHelp(); X == 4 -> readRules()),
    halt(0).

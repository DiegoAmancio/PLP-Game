:- initialization main.

make_peca(X,Y,Casas,Num,peca(X,Y,Casas,Num)).
make_jogador(Peca1, Peca2, Time, jogador(Peca1,Peca2,Time)).
make_tabuleiro(JogadorA, JogadorB, Matriz, tabuleiro(JogadorA,JogadorB,Matriz)).

get_x(peca(X,_,_,_),X).
get_y(peca(_,Y,_,_),Y).
get_casas(peca(_,_,Casas,_),Casas).
get_num(peca(_,_,_,Num),Num).

get_peca1(jogador(Peca1,_,_),Peca1).
set_peca1(jogador(_,Peca2,Time),Nova,jogador(Nova,Peca2,Time)).
get_peca2(jogador(_,Peca2,_),Peca2).
set_peca2(jogador(Peca1,_,Time),Nova,jogador(Peca1,Nova,Time)).
get_time(jogador(_,_,Time),Time).

get_jogadorA(tabuleiro(JogadorA,_,_),JogadorA).
get_jogadorB(tabuleiro(_,JogadorB,_),JogadorB).
get_matriz(tabuleiro(_,_,Matriz),Matriz).

get_linha1([X,_,_,_,_], X).
get_linha2([_,X,_,_,_], X).
get_linha3([_,_,X,_,_], X).
get_linha4([_,_,_,X,_], X).
get_linha5([_,_,_,_,X], X).

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

contaLinha(_, _, _, 21, List, List) :- !.  
contaLinha(Jog1, Jog2, X, Y, List, Ret) :-
    contaLocal(Jog1, Jog2, X, Y, Local),
    NovoInd is Y+1,
    append(List,[Local],NovaLista),   
	contaLinha(Jog1, Jog2, X, NovoInd, NovaLista, Aux),
    Ret = Aux.

gera_matriz(Jog1, Jog2, X) :-
    contaLinha(Jog1, Jog2, 0, 0, [], X1),
    contaLinha(Jog1, Jog2, 1, 0, [], X2),
    contaLinha(Jog1, Jog2, 2, 0, [], X3),
    contaLinha(Jog1, Jog2, 3, 0, [], X4),
    contaLinha(Jog1, Jog2, 4, 0, [], X5),
	X = [X1, X2, X3, X4, X5].

movePecaA(Peca,0,Peca).
movePecaA(Peca, Dado, NovaPeca):-
    get_x(Peca,X),
    get_y(Peca,Y),
    get_casas(Peca, Casas),
    get_num(Peca, Num),
    MaisX is X+1,
    MaisY is Y+1,
    MenosX is X-1,
    MenosY is Y-1,
    NovaCasa is Casas+1,
    (X == -1 -> make_peca(0,1,0,Num,PecaAtt), NovoDado is 0; 
    X == 0 , Y < 20 -> make_peca(X,MaisY,NovaCasa, Num,PecaAtt), NovoDado is Dado - 1;
    X < 4 , Y == 20 -> make_peca(MaisX,Y,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X == 4 , Y > 0 -> make_peca(X,MenosY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X > 1 , Y == 0 -> make_peca(MenosX,Y,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X == 1 , Y+Dado < 6 -> make_peca(X,MaisY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
    movePecaA(PecaAtt,NovoDado,NovaPeca).

movePecaB(Peca,0,Peca).
movePecaB(Peca, Dado, NovaPeca):-
    get_x(Peca,X),
    get_y(Peca,Y),
    get_casas(Peca, Casas),
    get_num(Peca, Num),
    MaisX is X+1,
    MaisY is Y+1,
    MenosX is X-1,
    MenosY is Y-1,
    NovaCasa is Casas+1,
    (X == -1 -> make_peca(4,19,0,Num,PecaAtt), NovoDado is 0; 
    X == 4 , Y > 0 -> make_peca(X,MenosY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X > 0 , Y == 0 -> make_peca(MenosX,Y,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X == 0 , Y < 20 -> make_peca(X,MaisY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X < 3 , Y == 20 -> make_peca(MaisX,Y,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    X == 3, Y-Dado > 14 -> make_peca(X,MenosY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
    make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
    movePecaA(PecaAtt,NovoDado,NovaPeca).

movePeca(Peca, Dado, "A", NovaPeca) :- movePecaA(Peca,Dado,NovaPeca).
movePeca(Peca, Dado, "B", NovaPeca) :- movePecaB(Peca,Dado,NovaPeca).

verifica(-1,_,6,_,1).
verifica(-1,_,_,_,0).
verifica(3,16,_,_,0).
verifica(1,6,_,_,0).
verifica(X,Y,Dado,Time,Ret) :- 
    (X == 1 , Y+Dado > 6 , Time == "A" -> Ret is 0;
    X == 3, Y-Dado < 14, Time == "B" -> Ret is 0;
    Ret is 1).
    
verificaJogadaPeca(Peca, Dado, Time, Ret) :-
    get_x(Peca,X),
    get_y(Peca,Y),
    verifica(X,Y,Dado,Time,Ret).

verificaJogadaJogador(Jog, Dado, Ret) :-
    get_peca1(Jog, Peca1),
    get_peca2(Jog, Peca2),
    get_time(Jog, Time),
    verificaJogadaPeca(Peca1, Dado, Time, Ret1),
    verificaJogadaPeca(Peca2,Dado, Time, Ret2),
    Ret is Ret1 + Ret2.

muda(1,0).
muda(0,1).

comePeca(Jog, X, Y, NovoJog) :-
    get_peca1(Jog, Peca1),
    get_x(Peca1, X1),
    get_y(Peca1, Y1),
    (X1 == X , Y1 == Y -> Num is 1;
        Num is 2),
    make_peca(-1,-1, 0, Num, NovaPeca),
    (X1 == X , Y1 == Y -> set_peca1(Jog, NovaPeca, NovoJog);
         set_peca2(Jog, NovaPeca, NovoJog)).    



movePlayer(Bot, Vez, Peca, Num, Dado, Tabuleiro) :-
    (Vez == 0 -> get_jogadorA(Tabuleiro,Jog), get_jogadorB(Tabuleiro,Ini);
        get_jogadorA(Tabuleiro,Ini), get_jogadorB(Tabuleiro,Jog)),
    get_time(Jog, Time),
    movePeca(Peca,Dado,Time,NovaPeca),
    get_x(NovaPeca, X),
    get_y(NovaPeca, Y),
    (Dado == 6 -> Proximo is Vez;
        X == 3 , Y == 14 -> Proximo is Vez;
        X == 1 , Y == 6 -> Proximo is Vez;
        muda(Vez,Proximo)),
    (Num == 1 -> set_peca1(Jog, NovaPeca, NovoJogador), get_peca2(NovoJogador, OutraPeca);
    set_peca2(Jog, NovaPeca, NovoJogador), get_peca1(NovoJogador, OutraPeca)),
    contaJogador(Ini, X, Y, Cont),
    (Cont == 1 -> comePeca(Ini, X, Y, NovoIni);
        NovoIni = Ini),
    (Vez == 0 -> gera_matriz(NovoJogador, NovoIni, Matriz),make_tabuleiro(NovoJogador,NovoIni,Matriz,NovoTab);
        gera_matriz(NovoIni, NovoJogador, Matriz),make_tabuleiro(NovoIni,NovoJogador,Matriz,NovoTab)),
    get_x(OutraPeca, X1),
    get_y(OutraPeca, Y1),
    (X == 3 , X1 == 3 , Y == 14 , Y1 == 14 -> encerrou(Bot,Vez);
    X == 1 , X1 == 1 , Y == 6, Y1 == 6 -> encerrou(Bot, Vez);
    jogo(Bot, Proximo,NovoTab)).


jogaPlayer(Bot, Vez, Dado, Tabuleiro) :-
    (Vez == 0 -> get_jogadorA(Tabuleiro, Jogador);
     get_jogadorB(Tabuleiro,Jogador)),
     write("Escolha uma peca: "),
     get_time(Jogador, Time),
     get_single_char(X),
     (X == 49 -> get_peca1(Jogador, Peca);
        get_peca2(Jogador, Peca)),
     verificaJogadaPeca(Peca, Dado, Time, Pode),
     (X \= 49 , X \= 50 -> write("Escolha uma peca valida"),nl,jogaPlayer(Bot, Vez, Dado, Tabuleiro);
        Pode == 0 -> write("Essa peca não pode se mover"),nl,jogaPlayer(Bot, Vez, Dado, Tabuleiro);
        movePlayer(Bot,Vez,Peca,X,Dado,Tabuleiro)).


moveBot(Peca,Num,Dado,Tabuleiro) :-
    get_jogadorA(Tabuleiro,JogA),
    get_jogadorB(Tabuleiro,Bot),
    movePeca(Peca, Dado,"B",NovaPeca),
    get_x(NovaPeca, X),
    get_y(NovaPeca, Y),
    (Dado == 6 -> Proximo is 1;
        X == 3 , Y == 14 -> Proximo is 1;
        Proximo is 0),
    (Num == 1 -> set_peca1(Bot, NovaPeca, NovoJogador),get_peca2(NovoJogador,OutraPeca);
        set_peca2(Bot, NovaPeca, NovoJogador),get_peca1(NovoJogador,OutraPeca)),

    contaJogador(JogA, X, Y, Cont),
    (Cont == 1 -> comePeca(JogA, X, Y, NovoJogA);
        NovoJogA is JogA),
    gera_matriz(NovoJogA, NovoJogador, Matriz),
    make_tabuleiro(NovoJogA, NovoJogador, Matriz, NovoTab),
    get_x(OutraPeca, X1),
    get_y(OutraPeca, Y1),
    (X == 3 , X1 == 3 , Y == 14 , Y1 == 14 -> encerrou(1,1);
        jogo(1,Proximo,NovoTab)).


jogaBot(Dado,Tabuleiro):-
    pecaBot(X),
    get_jogadorB(Tabuleiro, Jogador),
    (X == 1 -> get_peca1(Jogador, Peca);
        get_peca2(Jogador, Peca)),
    verificaJogadaPeca(Peca, Dado, "B", Pode),
    (Pode == 0 -> jogaBot(Dado, Tabuleiro);
        moveBot(Peca,X,Dado,Tabuleiro)).


joga(Bot, Vez, Dado, Tabuleiro) :-
    (Bot == 0 -> jogaPlayer(Bot,Vez, Dado, Tabuleiro);
        Bot == 1 , Vez == 0 -> jogaPlayer(Bot, Vez, Dado, Tabuleiro);
        jogaBot(Dado, Tabuleiro)).

continuaJogo(Bot, Vez, Tabuleiro, Jogador) :-
    sleep(1),dado(Dado),
    write("Saiu "),write(Dado),write(" no dado"),nl,
    verificaJogadaJogador(Jogador, Dado, PodeJogar),
    muda(Vez,Proximo),
    (PodeJogar == 0 -> jogo(Bot, Proximo, Tabuleiro);
        joga(Bot, Vez, Dado, Tabuleiro)).

verificaDesistencia(Bot,Vez,Tabuleiro,Jogador) :- 
    get_single_char(X),
    (X == 100 -> desistir(Bot,Vez);continuaJogo(Bot,Vez,Tabuleiro,Jogador)).

jogo(Bot, Vez, Tabuleiro) :-
    sleep(2),
    shell(clear),
    printTabuleiro(Tabuleiro),
    (Vez == 0 -> get_jogadorA(Tabuleiro, Jogador);
        get_jogadorB(Tabuleiro, Jogador)),
    vez(Bot,Vez),
    (Vez == 1 , Bot == 1 -> continuaJogo(Bot,Vez,Tabuleiro,Jogador);
        verificaDesistencia(Bot, Vez, Tabuleiro,Jogador)).


encerrou(Bot, TimeVencedor) :-
    
    (Bot == 1 , TimeVencedor == 1 -> write("o bot ganhou\n");
    Bot == 1 , TimeVencedor == 0 -> write("Parabéns você ganhou\n");
    Bot == 0 , TimeVencedor == 1 -> write("Player 2 ganhou!\n");
    write("Player 1 ganhou!\n")),
    main.

desistir(Bot,Vez) :- 
	(Bot == 1 , Vez == 0 -> write("Voce desistiu, consequentemente... Voce perdeu!\n");
    Bot == 0 , Vez == 0 -> write("Player 1 desistiu\n");
    write("Player 2 desistiu\n")),
    muda(Vez,Ganhador),
    encerrou(Bot,Ganhador).
           
vez(Bot, Vez) :- 
    (Bot == 1,Vez == 1 -> write("Vez do bot : o bot vai jogar o dado...");Bot == 1 ,Vez == 0 -> write("Sua vez  => digite qualquer coisa para rodar o dado ou d para sair:");
    Bot == 0,Vez == 0 -> write("Vez do Player 1  => digite qualquer coisa para rodar o dado ou d para sair:");
    write("Vez do Player 2  => digite qualquer coisa para rodar o dado ou d para sair:")),nl.
    
inicia(Bot):-
    (Bot == 0 -> write("Iniciando VS"),nl; write("Iniciando BOT"),nl),
	make_peca(-1,-1,0,1,Peca1A),
	make_peca(-1,-1,0,2,Peca2A),
	make_peca(-1,-1,0,1,Peca1B),
	make_peca(-1,-1,0,2,Peca2B),
	make_jogador(Peca1A,Peca2A,"A",JogadorA),
	make_jogador(Peca1B,Peca2B,"B",JogadorB),
	gera_matriz(JogadorA, JogadorB, Tab),
	make_tabuleiro(JogadorA,JogadorB,Tab,Tabuleiro),
    jogo(Bot, 0, Tabuleiro).

toStringCaso2(String,Index,Saida):- (Index < 10 -> string_concat("0",String,Saida);string_concat(String,"",Saida)).
    
linhaTabuleiro(_,21,-2,Resposta):-write(Resposta),nl.
linhaTabuleiro(_,21,-1,Resposta):-write(Resposta),nl.
linhaTabuleiro(_,21,_,Resposta):-string_concat(Resposta,"|",Saida),write(Saida),nl.

linhaTabuleiro(_,Index,-2,Resposta):-number_string(Index,ToString1),toStringCaso2(ToString1,Index,ToString2),string_concat(ToString2," ",ToString),string_concat(Resposta,ToString, Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-2,Saida).
linhaTabuleiro(_,Index,-1,Resposta):-string_concat(Resposta,"__ ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-1,Saida).

linhaTabuleiro([H|T],-1,0,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro([H|T],0,0,Saida).   
linhaTabuleiro([H|T],Index,0,Resposta):-validaPecaPrint(H,0,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,0,Saida).    

linhaTabuleiro(_,-1,1,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro(_,0,1,Saida).
linhaTabuleiro(_,Index,1,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,1,Saida).

linhaTabuleiro([H|T],-1,2,Resposta):-string_concat(Resposta,"01", Saida),linhaTabuleiro([H|T],0,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-Index < 6,validaPecaPrint(H,2,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,2,Saida).    
linhaTabuleiro([H|T],Index,2,Resposta):-(Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-(Index > 5 , Index < 19),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-Index < 20,string_concat(Resposta,"   ", Saida),CasoMenos is 2 - 2,IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,CasoMenos,Saida).

linhaTabuleiro(_,-1,3,Resposta):-string_concat(Resposta,"01", Saida),linhaTabuleiro(_,0,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):-(Index < 6; Index == 20),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,3,Saida).    
linhaTabuleiro(_,Index,3,Resposta):-(Index == 4 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):- Index == 20,string_concat(Resposta,"   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):-(Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):-(Index >  5 ; Index < 19),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,3,Saida).

linhaTabuleiro([H|T],-1,4,Resposta):-string_concat(Resposta,"02", Saida),linhaTabuleiro([H|T],0,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-(Index == 1;Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-(Index >  1 , Index < 20),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-validaPecaPrint(H,4,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).


linhaTabuleiro(_,-1,5,Resposta):-string_concat(Resposta,"02", Saida),linhaTabuleiro(_,0,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-(Index == 1;Index == 6 ; Index == 11 ),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index == 15,string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index > 14, Index < 20,string_concat(Resposta," __", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index > 1, Index < 20,string_concat(Resposta,"   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).

linhaTabuleiro([H|T],-1,6,Resposta):-string_concat(Resposta,"03", Saida),linhaTabuleiro([H|T],0,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-(Index == 1;Index == 6 ; Index == 11 ),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-Index > 1, Index < 15,string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H- H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-Index > 14, Index < 21,validaPecaPrint(H,6,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H -H,linhaTabuleiro(T,IndexP,6,Saida).    
linhaTabuleiro([H|T],Index,6,Resposta):-validaPecaPrint(H,1,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,6,Saida).    
   
linhaTabuleiro(_,-1,7,Resposta):-string_concat(Resposta,"03", Saida),linhaTabuleiro(_,0,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-(Index == 6;Index == 11),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-Index > 1, Index < 15,string_concat(Resposta," __", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).

linhaTabuleiro([H|T],-1,8,Resposta):-string_concat(Resposta,"04", Saida),linhaTabuleiro([H|T],0,0,Saida).
linhaTabuleiro(_,-1,8,Resposta):-string_concat(Resposta,"04", Saida),linhaTabuleiro(_,0,1,Saida).

validaPecaPrint(Numero,6,Saida):-(Numero > 0 -> (number_string(Numero, ToString));string_concat("","<-",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,2,Saida):-(Numero > 0 -> (number_string(Numero, ToString));string_concat("","->",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,_,Saida):-(Numero > 0 -> number_string(Numero, ToString);string_concat(""," ",ToString)),string_concat("|",ToString,Concat),string_concat(Concat," ",Saida).

printaCaixa(Tabuleiro, Jog):-
	(Jog == 1 -> get_jogadorA(Tabuleiro, Jogador);
	get_jogadorB(Tabuleiro, Jogador)),
	get_time(Jogador, Time),
	get_peca1(Jogador, Peca1),
	get_peca2(Jogador, Peca2),
	get_x(Peca1,X1),
	get_x(Peca2,X2),
	get_y(Peca1,Y1),
	get_y(Peca2,Y2),
	write(" ______ "),nl,
    write("|      |"),nl,
    (X1 == -1 -> write("|  "),write(Time),write("1  | "),write(Time),write("1: base"),nl; 
    write("|      | "), write(Time), write("1: x: "), write(X1), write("; y: "), write(Y1),nl), 
    (X2 == -1 -> write("|  "),write(Time),write("2  | "),write(Time),write("2: base"),nl;
    write("|      | "), write(Time), write("2: x: "), write(X2), write("; y: "), write(Y2),nl),
    write("|______|"),nl.

printTabuleiro(Tabuleiro):- 
	printaCaixa(Tabuleiro, 1),
	get_matriz(Tabuleiro,Tab),
	get_linha1(Tab, L1),
	get_linha2(Tab, L2),
	get_linha3(Tab, L3),
	get_linha4(Tab, L4),
	get_linha5(Tab, L5),
    write("   "),
    linhaTabuleiro(1,0,-2,""),
    write("   "),   
    linhaTabuleiro([],0,-1,""),
    linhaTabuleiro(L1,-1,0,""),
    linhaTabuleiro([],-1,1,""),
    linhaTabuleiro(L2,-1,2,""),
    linhaTabuleiro([],-1,3,""),
    linhaTabuleiro(L3,-1,4,""),
    linhaTabuleiro([],-1,5,""),
    linhaTabuleiro(L4,-1,6,""),
    linhaTabuleiro([],-1,7,""),
    linhaTabuleiro(L5,-1,8,""),
    linhaTabuleiro([],-1,8,""),
    printaCaixa(Tabuleiro,2).

pecaBot(X) :-
    random(1,3,X).
  
dado(X):-
    random(5,7,X).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).
printando([T]):- T == 'end_of_file',nl.
printando([H|T]):- write(H),nl,printando(T).
readHelp():-
    open('help.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    printando(Lines),
    main.
  

readRules():-
    open('rules.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    printando(Lines),
    main.
    
sair():-
    write("Até mais!"),nl.

main:-
    repeat,
    write("1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"),nl,
    get_single_char(X),
    (X == 49 -> inicia(0); X == 50 -> inicia(1); X == 51 -> readHelp(); X == 52 -> readRules(); X == 53 -> sair()),
    halt(0).

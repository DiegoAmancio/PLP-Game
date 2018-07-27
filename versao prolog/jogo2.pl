:- initialization main.

make_peca(X,Y,Casas,Num,peca(X,Y,Casas,Num)).
make_jogador(Peca1, Peca2, Time, jogador(Peca1,Peca2,Time)).
make_tabuleiro(JogadorA, JogadorB, Matriz, tabuleiro(JogadorA,JogadorB,Matriz)).
make_local(X,Y,local(X,Y)).

get_x(local(X,_),X).
get_x(peca(X,_,_,_),X).
get_y(local(_,Y),Y).
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

muda(1,0).
muda(0,1).

main :-
    repeat,
    menu(),
    get_single_char(X),
    (X == 49 -> inicia(0); 
     X == 50 -> inicia(1); 
     X == 51 -> readArq('help.txt'); 
     X == 52 -> readArq('rules.txt'); 
     X == 53 -> sair(); 
     main),
    halt(0).

menu() :- leArquivo('apresentacao.txt').

readArq(Arquivo) :-
    leArquivo(Arquivo),
    main.

leArquivo(Arquivo) :-
    open(Arquivo, read, Str),
    read_file(Str,Lines),
    close(Str),
    printando(Lines).

read_file(Stream,[]) :- at_end_of_stream(Stream).
read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

printando([T]) :- T == 'end_of_file',nl.
printando([H|T]) :- write(H),nl,printando(T).

sair() :-
    write("Até mais!"),nl.

inicia(Bot) :-
    (Bot == 0 -> write("Iniciando VS"),nl; 
     write("Iniciando BOT"),nl),

    make_peca(-1,-1,0,1,Peca1A),
    make_peca(-1,-1,0,2,Peca2A),
    make_peca(-1,-1,0,1,Peca1B),
    make_peca(-1,-1,0,2,Peca2B),
    make_jogador(Peca1A,Peca2A,"A",JogadorA),
    make_jogador(Peca1B,Peca2B,"B",JogadorB),
    
    geraTabuleiro(JogadorA, JogadorB, Tab),
    locaisArmadilhas(Arm),
    make_tabuleiro(JogadorA,JogadorB,Tab,Tabuleiro),
    
    jogo(Bot, 0, Arm, Tabuleiro).

jogo(Bot, Vez, Arm, Tabuleiro) :-
    sleep(2),
    shell(clear),
    printTabuleiro(Tabuleiro),
    
    (Vez == 0 -> get_jogadorA(Tabuleiro, Jogador);
     get_jogadorB(Tabuleiro, Jogador)),
    vez(Bot,Vez),
    (Vez == 1 , Bot == 1 -> continuaJogo(Bot,Vez,Arm,Tabuleiro,Jogador);
     verificaDesistencia(Bot, Vez, Arm, Tabuleiro,Jogador)).

verificaDesistencia(Bot,Vez,Arm,Tabuleiro,Jogador) :- 
    get_single_char(X),
    (X == 100 -> desistir(Bot,Vez); continuaJogo(Bot,Vez,Arm,Tabuleiro,Jogador)).

continuaJogo(Bot, Vez, Arm, Tabuleiro, Jogador) :-
    sleep(1),dado(Dado),
    write("Saiu "),write(Dado),write(" no dado"),nl,
    
    verificaJogadaJogador(Jogador, Dado, PodeJogar),
    muda(Vez,Proximo),
    (PodeJogar == 0 -> jogo(Bot, Proximo, Arm, Tabuleiro);
     joga(Bot, Vez, Dado, Arm, Tabuleiro)).
    
joga(Bot, Vez, Dado, Arm, Tabuleiro) :-
    (Bot == 0 -> jogaPlayer(Bot,Vez, Dado, Arm, Tabuleiro);
     Vez == 0 -> jogaPlayer(Bot, Vez, Dado, Arm, Tabuleiro);
     jogaBot(Dado, Arm, Tabuleiro)).

jogaBot(Dado, Arm, Tabuleiro) :-
    pecaBot(X),
    get_jogadorB(Tabuleiro, Jogador),
    (X == 1 -> get_peca1(Jogador, Peca);
     get_peca2(Jogador, Peca)),

    verificaJogadaPeca(Peca, Dado, "B", Pode),
    (Pode == 0 -> jogaBot(Dado, Arm, Tabuleiro);
     jogada(1,1,Peca,Dado,Arm,Tabuleiro)).

jogaPlayer(Bot, Vez, Dado, Arm, Tabuleiro) :-
    write("Escolha uma peca: "),
    get_single_char(X),
    
    (Vez == 0 -> get_jogadorA(Tabuleiro, Jogador);
     get_jogadorB(Tabuleiro,Jogador)),
    get_time(Jogador, Time),
    (X == 49 -> get_peca1(Jogador, Peca);
     get_peca2(Jogador, Peca)),

    verificaJogadaPeca(Peca, Dado, Time, Pode),
    (X \= 49 , X \= 50 -> write("Escolha uma peca valida"),nl,jogaPlayer(Bot, Vez, Dado, Arm, Tabuleiro);
     Pode == 0 -> write("Essa peca não pode se mover"),nl,jogaPlayer(Bot, Vez, Dado, Arm, Tabuleiro);
     jogada(Bot,Vez,Peca,Dado,Arm,Tabuleiro)).

jogada(Bot, Vez, Peca, Dado, Arm, Tabuleiro) :-
    (Vez == 0 -> get_jogadorA(Tabuleiro,Jog), get_jogadorB(Tabuleiro,Ini);
     get_jogadorA(Tabuleiro,Ini), get_jogadorB(Tabuleiro,Jog)),
    get_time(Jog, Time),
    get_num(Peca, Num),

    movePeca(Peca,Dado,Time,PecaAux),
    get_x(PecaAux, XAux),
    get_y(PecaAux, YAux),

    verificaArmadilha(XAux,YAux,Arm,TemArm),
    (TemArm == 0 -> NovaPeca = PecaAux;
     aplicaArmadilha(PecaAux,Dado,Time,NovaPeca)),

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
    (Vez == 0 -> geraTabuleiro(NovoJogador, NovoIni, Matriz),make_tabuleiro(NovoJogador,NovoIni,Matriz,NovoTab);
     geraTabuleiro(NovoIni, NovoJogador, Matriz),make_tabuleiro(NovoIni,NovoJogador,Matriz,NovoTab)),
    
    get_x(OutraPeca, X1),
    get_y(OutraPeca, Y1),
    (X == 3 , X1 == 3 , Y == 14 , Y1 == 14 -> encerrou(Bot,Vez);
     X == 1 , X1 == 1 , Y == 6, Y1 == 6 -> encerrou(Bot, Vez);
     jogo(Bot,Proximo,Arm,NovoTab)).

movePeca(Peca, Dado, "A", NovaPeca) :- movePecaA(Peca,Dado,NovaPeca).
movePeca(Peca, Dado, "B", NovaPeca) :- movePecaB(Peca,Dado,NovaPeca).

movePecaA(Peca,0,Peca).
movePecaA(Peca, Dado, NovaPeca) :-
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
     X == 1 , Y < 6 -> make_peca(X,MaisY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
     make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
     movePecaA(PecaAtt,NovoDado,NovaPeca).

movePecaB(Peca,0,Peca).
movePecaB(Peca, Dado, NovaPeca) :-
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
     X == 3, Y > 14 -> make_peca(X,MenosY,NovaCasa,Num,PecaAtt), NovoDado is Dado - 1;
     make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
     movePecaB(PecaAtt,NovoDado,NovaPeca).

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

comePeca(Jog, X, Y, NovoJog) :-
    get_peca1(Jog, Peca1),
    get_x(Peca1, X1),
    get_y(Peca1, Y1),

    (X1 == X , Y1 == Y -> Num is 1;
     Num is 2),
    make_peca(-1,-1, 0, Num, NovaPeca),
    (X1 == X , Y1 == Y -> set_peca1(Jog, NovaPeca, NovoJog);
     set_peca2(Jog, NovaPeca, NovoJog)).  

verificaLocalArmadilha(X,Y,local(X,Y),1).
verificaLocalArmadilha(_,_,_,Ret):- Ret is 0.
verificaArmadilha(X,Y,[A1,A2,A3,A4,A5],Ret) :-
    verificaLocalArmadilha(X,Y,A1,R1),
    verificaLocalArmadilha(X,Y,A2,R2),
    verificaLocalArmadilha(X,Y,A3,R3),
    verificaLocalArmadilha(X,Y,A4,R4),
    verificaLocalArmadilha(X,Y,A5,R5),
    Ret is R1+R2+R3+R4+R5.

voltaPeca(Peca, Casas, "A", NovaPeca) :- voltaPecaA(Peca,Casas,NovaPeca).
voltaPeca(Peca, Casas, "B", NovaPeca) :- voltaPecaB(Peca,Casas,NovaPeca).

voltaPecaA(Peca,0,Peca).
voltaPecaA(Peca, Casas, NovaPeca):-
    get_x(Peca,X),
    get_y(Peca,Y),
    get_casas(Peca, Casa),
    get_num(Peca, Num),

    MaisX is X+1,
    MaisY is Y+1,
    MenosX is X-1,
    MenosY is Y-1,
    NovaCasa is Casa-1,

    (X < 4 , Y == 0 -> make_peca(MaisX,Y,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X == 4 , Y < 20 -> make_peca(X,MaisY,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X > 0 , Y == 20 -> make_peca(MenosX,Y,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X == 0 , Y > 1 -> make_peca(X,MenosY,NovaCasa, Num,PecaAtt), NovoDado is Casas - 1;
     make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
     voltaPecaA(PecaAtt,NovoDado,NovaPeca).

voltaPecaB(Peca,0,Peca).
voltaPecaB(Peca, Casas, NovaPeca) :-
    get_x(Peca,X),
    get_y(Peca,Y),
    get_casas(Peca, Casa),
    get_num(Peca, Num),

    MaisX is X+1,
    MaisY is Y+1,
    MenosX is X-1,
    MenosY is Y-1,
    NovaCasa is Casa-1,

    (X > 0 , Y == 20 -> make_peca(MenosX,Y,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X == 0 , Y > 0 -> make_peca(X,MenosY,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X < 4 , Y == 0 -> make_peca(MaisX,Y,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     X == 4 , Y < 19 -> make_peca(X,MaisY,NovaCasa,Num,PecaAtt), NovoDado is Casas - 1;
     make_peca(X,Y,Casas,Num,PecaAtt), NovoDado is 0),
     voltaPecaB(PecaAtt,NovoDado,NovaPeca).

verifica(-1,_,6,_,1).
verifica(-1,_,_,_,0).
verifica(3,16,_,_,0).
verifica(1,6,_,_,0).
verifica(X,Y,Dado,Time,Ret) :- 
    (X == 1 , Y+Dado > 6 , Y \= 0 , Time == "A" -> Ret is 0;
     X == 3, Y-Dado < 14, Y \= 20, Time == "B" -> Ret is 0;
     Ret is 1).
       
geraTabuleiro(Jog1, Jog2, X) :-
    contaLinha(Jog1, Jog2, 0, 0, [], X1),
    contaLinha(Jog1, Jog2, 1, 0, [], X2),
    contaLinha(Jog1, Jog2, 2, 0, [], X3),
    contaLinha(Jog1, Jog2, 3, 0, [], X4),
    contaLinha(Jog1, Jog2, 4, 0, [], X5),
    X = [X1, X2, X3, X4, X5].

contaLinha(_, _, _, 21, List, List).  
contaLinha(Jog1, Jog2, X, Y, List, Ret) :-
    NovoInd is Y+1,
    contaLocal(Jog1, Jog2, X, Y, Local),
    append(List,[Local],NovaLista),   
    contaLinha(Jog1, Jog2, X, NovoInd, NovaLista, Aux),
    Ret = Aux.

contaLocal(Jog1, Jog2, X, Y, Ret) :-
    contaJogador(Jog1, X, Y, Jogador1),
    contaJogador(Jog2, X, Y, Jogador2),
    Ret is Jogador1 + Jogador2.

contaJogador(Jog, X, Y, Ret) :-
    get_peca1(Jog, Peca1),
    get_peca2(Jog, Peca2),
    pecaAqui(Peca1, X, Y, Peca1Aqui),
    pecaAqui(Peca2, X, Y, Peca2Aqui),
    Ret is Peca1Aqui + Peca2Aqui.   

pecaAqui(Pec, X, Y, Ret) :-
    get_casas(Pec,Casas),
    get_num(Pec,Num),
    make_peca(X,Y,Casas,Num,Peca),
    (Pec == Peca -> Ret is 1; Ret is 0).

locaisArmadilhas(Armadilhas) :-
%    make_local(0,6,Local1),
%    make_local(0,7,Local2),
%    make_local(4,14,Local3),
%    make_local(4,13,Local4),
    geraLocal(Local1),
    geraLocal(Local2),
    geraLocal(Local3),
    geraLocal(Local4),
    geraLocal(Local5),
    Armadilhas = [Local1,Local2,Local3,Local4,Local5].

geraLocal(Local) :-
    geraX(X),
    geraY(X, Y),
    make_local(X,Y,Local).

geraX(X) :- random(0,5,X).

geraY(X, Y) :-
    (X == 0 -> random(0,21,Y);
     X == 4 -> random(0,21,Y);
     escolhe(Y)).

escolhe(Y) :-
    random(0,2,Aux),
    (Aux == 0 -> Y = 0;
     Y = 20).

aplicaArmadilha(Peca,Dado,Time,NovaPeca) :-
    numArmadilha(X),
    get_casas(Peca,Casas),
    Metade is Casas/2,

    (X == 1,Dado < 6 ->write("Armadilha: Desvio na avenida local! \nSua peça foi bloqueada por isso terá que esperar, você perdeu essa jogada\n"),
    sleep(4), voltaPeca(Peca,Dado,Time,NovaPeca);

     X == 2 ->write("Armadilha Greve dos caminhoneiros!!\n Gasolina Acabando e o posto a frente cobra muito caro! \nRetorne 2 espaços para abastecer no posto anterior\n"),
    sleep(4), voltaPeca(Peca,2,Time,NovaPeca), write("Sua peça voltou 2 espaços");
    
     X == 3 ->write("Armadilha: Blitz na Rodovia! \nSe tirou par no Dado, indica que você tem carteira e foi liberado, caso não, pagou multa de 5 espaços\n"),
    (Dado mod 2 > 0 -> sleep(4), voltaPeca(Peca,5,Time,NovaPeca), write("sua peça voltou 5 espaços\n"));
     
     X == 4 -> write("Armadilha: Dia de Emplacamento! \nPague o Emplacamento e volte a metade da quantidade de casas que você andou até agora!\n"),
    sleep(4), voltaPeca(Peca,Metade,Time,NovaPeca), number_string(Metade,Formatado), 
    string_concat("Sua peça voltou ",Formatado,ToString), string_concat(ToString," espacos",ToString1), write(ToString1);
    
     number_string(Dado,DadoStr), string_concat("Armadilha Positiva :\n Deu Sorte: Carona na abertura de ambulancia!\nSua peça se moveu de forma bônus mais ",DadoStr,ToString2),
    string_concat(ToString2," espacos",ToString3), movePeca(Peca,Dado,Time,NovaPeca), sleep(4), write(ToString3)).

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
    (Bot == 1,Vez == 1 -> write("Vez do bot : o bot vai jogar o dado...\n");
     Bot == 1 ,Vez == 0 -> write("Sua vez  => digite qualquer caracter para rodar o dado ou d para sair:\n");
     Bot == 0,Vez == 0 -> write("Vez do Player 1  => digite qualquer caracter para rodar o dado ou d para sair:\n");
     write("Vez do Player 2  => digite qualquer caracter para rodar o dado ou d para sair:\n")).

pecaBot(X) :- random(1,3,X).
  
dado(X) :- random(5,7,X).

numArmadilha(X) :- random(1,6,X).

toStringCaso2(String,Index,Saida) :- (Index < 10 -> string_concat("0",String,Saida);string_concat(String,"",Saida)).
    
linhaTabuleiro(_,21,-2,Resposta) :- write(Resposta).
linhaTabuleiro(_,21,-1,Resposta) :- write(Resposta).
linhaTabuleiro(_,21,9,Resposta) :- write(Resposta).
linhaTabuleiro(_,21,_,Resposta) :- string_concat(Resposta,"|",Saida),write(Saida).

linhaTabuleiro(_,Index,-2,Resposta) :- number_string(Index,ToString1),toStringCaso2(ToString1,Index,ToString2),string_concat(ToString2," ",ToString),string_concat(Resposta,ToString, Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-2,Saida).
linhaTabuleiro(_,Index,-1,Resposta) :- string_concat(Resposta,"__ ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-1,Saida).

linhaTabuleiro([H|T],Index,0,Resposta) :- validaPecaPrint(H,0,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,0,Saida).    

linhaTabuleiro(_,Index,1,Resposta) :- string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,1,Saida).

linhaTabuleiro([H|T],-1,2,Resposta) :- string_concat(Resposta,"01", Saida),linhaTabuleiro([H|T],0,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta) :- Index < 6,validaPecaPrint(H,2,A),string_concat(Resposta, A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta) :- Index == 11,write(Resposta),write("\033[44m"),string_concat(" ","  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta) :- Index == 15,write(" "),write(Resposta),write("\033[49m"),string_concat("","  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).    
linhaTabuleiro([H|T],Index,2,Resposta) :- (Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta) :- (Index > 5 , Index < 19),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta) :- Index == 19,string_concat(Resposta,"   ", Saida),write(Saida),write("\033[47m"), write("\033[30m"),CasoMenos is 2 - 2,IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,CasoMenos,"").


linhaTabuleiro(_,-1,3,Resposta) :- string_concat(Resposta,"01", Saida),linhaTabuleiro(_,0,3,Saida).
linhaTabuleiro(_,Index,3,Resposta) :- Index < 6,string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta) :- Index  == 6,string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta) :- Index == 11,write(Resposta),write("\033[44m"),string_concat("","   ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta) :- Index == 15,write(" "),write(Resposta),write("\033[49m"),string_concat("","  ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta) :- Index == 19,string_concat(Resposta,"   ", Saida),write(Saida),write("\033[47m"), write("\033[30m"),CasoMenos is 3 - 2,IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,CasoMenos,"").
linhaTabuleiro(_,Index,3,Resposta) :- (Index >  5 ; Index < 19),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,3,Saida).

linhaTabuleiro([H|T],Index,4,Resposta) :- (Index >  1 , Index < 6),write(Resposta),write("\033[49m"),string_concat("","   ", Saida),IndexP is Index + 1+ H - H ,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta) :- Index == 11,write(Resposta),write("\033[44m"),string_concat("","   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta) :- Index == 15,write(" "),write(Resposta),write("\033[49m"),string_concat("","  ", Saida),IndexP is Index + 1+ H - H ,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta) :- Index == 1,string_concat(Resposta,"|", Saida),write(Saida),write("\033[49m"),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,"  ").
linhaTabuleiro([H|T],Index,4,Resposta) :- Index == 6,write(Resposta),write("\033[42m"),string_concat("","   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([_|T],Index,4,_) :- Index == 19,write("      "),IndexP is Index + 1 ,linhaTabuleiro(T,IndexP,4,"").
linhaTabuleiro([H|T],Index,4,Resposta) :- (Index >  15 , Index < 19),write(Resposta),write("\033[49m"),string_concat("","   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta) :- (Index >  6 , Index < 15),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta) :- write("\033[30m"),write("\033[47m"),validaPecaPrint(H,4,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).

linhaTabuleiro(_,Index,5,Resposta) :- Index == 1,string_concat(Resposta,"|", Saida),write(Saida),write("\033[49m"),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,5,"  ").
linhaTabuleiro(_,Index,5,Resposta) :- Index == 15,write(" "),write(Resposta),write("\033[49m"),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,5,"  ").
linhaTabuleiro(_,Index,5,Resposta) :- Index >  1 , Index < 6,write(Resposta),write("\033[49m"),string_concat("","   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta) :- Index == 6,write(Resposta),write("\033[42m"),string_concat("","   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta) :- Index >  10 , Index < 16,write(Resposta),write("\033[44m"),string_concat("","   ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta) :- Index >  6 , Index < 11,write(Resposta),write("\033[42m"),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,5,"   ").
linhaTabuleiro(_,Index,5,_) :- Index == 19,write("      "),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,5,"").
linhaTabuleiro(_,Index,5,Resposta) :- Index == 0,write("\033[47m"),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta) :- Index > 15, Index < 19,write(Resposta),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,"   ").
linhaTabuleiro(_,Index,5,Resposta) :- Index == 20,write("\033[47m"),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).

linhaTabuleiro([H|T],Index,6,Resposta) :- Index == 1,string_concat(Resposta,"|", Saida),write(Saida),write("\033[49m"),IndexP is Index + 1 + H - H ,linhaTabuleiro(T,IndexP,6,"  ").
linhaTabuleiro([H|T],Index,6,Resposta) :- Index == 6,write(Resposta),write("\033[42m"),string_concat("","   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta) :- Index >  1 , Index < 6,write(Resposta),write("\033[49m"),string_concat("","   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta) :- Index >  10 , Index < 15,write(Resposta),write("\033[44m"),string_concat("","   ", Saida),IndexP is Index + 1+ H - H ,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta) :- Index >  6 , Index < 11,write(Resposta),write("\033[42m"),IndexP is Index + 1+ H - H ,linhaTabuleiro(T,IndexP,6,"   ").
linhaTabuleiro([H|T],Index,6,Resposta) :- Index > 14, Index < 21,validaPecaPrint(H,6,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H -H,linhaTabuleiro(T,IndexP,6,Saida).    
linhaTabuleiro([H|T],Index,6,Resposta) :- validaPecaPrint(H,1,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,6,Saida).    
   
linhaTabuleiro(_,-1,7,Resposta) :- string_concat(Resposta,"03", Saida),linhaTabuleiro(_,0,7,Saida).
linhaTabuleiro(_,Index,7,Resposta) :- Index == 1,string_concat(Resposta,"|", Saida),write(Saida),write("\033[49m"),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,7,"  ").
linhaTabuleiro(_,Index,7,Resposta) :- Index == 6,write(Resposta),write("\033[42m"),string_concat("","   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta) :- Index >  1 , Index < 6,write(Resposta),write("\033[49m"),string_concat("","   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta) :- Index >  10 , Index < 15,write(Resposta),write("\033[44m"),string_concat("","   ", Saida),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta) :- Index >  6 , Index < 11,write(Resposta),write("\033[42m"),IndexP is Index + 1 ,linhaTabuleiro(_,IndexP,7,"   ").
linhaTabuleiro(_,Index,7,Resposta) :- string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).

linhaTabuleiro([H|T],-1,8,Resposta) :- string_concat(Resposta,"04", Saida),linhaTabuleiro([H|T],0,0,Saida).
linhaTabuleiro(_,-1,8,Resposta) :- string_concat(Resposta,"04", Saida),linhaTabuleiro(_,0,1,Saida).

validaPecaPrint(Numero,6,Saida) :- (Numero > 0 -> (number_string(Numero, ToString));string_concat("","<-",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,2,Saida) :- (Numero > 0 -> (number_string(Numero, ToString));string_concat("","->",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,_,Saida) :- (Numero > 0 -> number_string(Numero, ToString);string_concat(""," ",ToString)),string_concat("|",ToString,Concat),string_concat(Concat," ",Saida).

printaCaixa(Tabuleiro, Jog) :-
    (Jog == 1 -> get_jogadorA(Tabuleiro, Jogador), Cor = "\033[42m";
    get_jogadorB(Tabuleiro, Jogador), Cor = "\033[44m"),
    
    get_time(Jogador, Time),
    get_peca1(Jogador, Peca1),
    get_peca2(Jogador, Peca2),
    get_x(Peca1,X1),
    get_x(Peca2,X2),
    get_y(Peca1,Y1),
    get_y(Peca2,Y2),
    
    write("       "),nl,
    write(Cor), write("        "),nl,
    (X1 == -1 -> write("   "),write(Time),write("1   "),write("\033[0m"),write("  "),write(Time),write("1: base"),nl; 
    write("        "),  write("\033[0m"),write("  "), write(Time),write("1: x: "), write(X1), write("; y: "), write(Y1),nl),write(Cor), 
    (X2 == -1 -> write("   "),write(Time),write("2   "),write("\033[0m"),write("  "),write(Time),write("2: base"),nl;
    write(Cor),write("        "),write("\033[0m"),write("  "), write(Time), write("2: x: "), write(X2), write("; y: "), write(Y2),nl),
    write(Cor),write("        "),write("\033[0m"),nl.

printTabuleiro(Tabuleiro) :- 
    printaCaixa(Tabuleiro, 1),
    
    get_matriz(Tabuleiro,Tab),
    get_linha1(Tab, L1),
    get_linha2(Tab, L2),
    get_linha3(Tab, L3),
    get_linha4(Tab, L4),
    get_linha5(Tab, L5),

    write("   "),
    linhaTabuleiro(1,0,-2,""),nl,

    write("00"),
    write("\033[30m"),
    write("\033[47m"),
    linhaTabuleiro(L1,0,0,""),nl,

    write("\033[0m"),
    write("00"),
    write("\033[30m"),
    write("\033[47m"),
    linhaTabuleiro([],0,1,""),nl,

    write("\033[0m"),
    write("01"),
    write("\033[30m"),
    write("\033[42m"),
    linhaTabuleiro(L2,0,2,""),nl,

    write("\033[0m"),
    write("01"),
    write("\033[30m"),
    write("\033[42m"),
    linhaTabuleiro([],0,3,""),nl,

    write("\033[0m"),
    write("02"),
    linhaTabuleiro(L3,0,4,""),nl,

     write("\033[0m"),
    write("02"),
    write("\033[30m"),
    linhaTabuleiro([],0,5,""),nl,

    write("\033[0m"),
    write("03"),
    write("\033[30m"),
    write("\033[47m"), 
    linhaTabuleiro(L4,0,6,""),nl,

    write("\033[0m"),
    write("03"),
    write("\033[30m"),
    write("\033[47m"), 
    linhaTabuleiro([],0,7,""),nl,

    write("\033[0m"),
    write("04"),
    write("\033[30m"),
    write("\033[47m"),
    linhaTabuleiro(L5,0,0,""),nl,

    write("\033[0m"),
    write("04"),
    write("\033[30m"),
    write("\033[47m"),
    linhaTabuleiro([],0,1,""),nl,

    write("\033[0m"),
    printaCaixa(Tabuleiro,2).
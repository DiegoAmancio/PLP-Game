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

concat([],L,L).
concat(L,[],L).
concat([X|L1],L2,[X,L3]) :- concat(L1,L2,L3).

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
    contaLinha(Jog1, Jog2, 0, 0, [0], X1),
    contaLinha(Jog1, Jog2, 1, 0, [0], X2),
    contaLinha(Jog1, Jog2, 2, 0, [0], X3),
    contaLinha(Jog1, Jog2, 3, 0, [0], X4),
    contaLinha(Jog1, Jog2, 4, 0, [0], X5),
	X = [X1, X2, X3, X4, X5].

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
	%write(printTabuleiro()),nl,
    halt(0).
linhaTabuleiro(_,22,-2,Resposta):-write(Resposta),nl.
linhaTabuleiro(_,22,-1,Resposta):-write(Resposta),nl.
linhaTabuleiro(_,22,_,Resposta):-string_concat(Resposta,"|",Saida),write(Saida),nl.

linhaTabuleiro(_,Index,-2,Resposta):-number_string(Index,ToString1),toStringCaso2(ToString1,Index,ToString2),string_concat(ToString2," ",ToString),string_concat(Resposta,ToString, Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-2,Saida).
toStringCaso2(String,Index,Saida):- (Index < 10 -> string_concat("0",String,Saida);string_concat(String,"",Saida)).
linhaTabuleiro(_,Index,-1,Resposta):-string_concat(Resposta,"__ ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,-1,Saida).

linhaTabuleiro([H|T],-1,0,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro([H|T],0,0,Saida).   
linhaTabuleiro([H|T],Index,0,Resposta):-validaPecaPrint(H,0,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,0,Saida).    

linhaTabuleiro(_,-1,1,Resposta):-string_concat(Resposta,"00", Saida),linhaTabuleiro(_,0,1,Saida).
linhaTabuleiro(_,Index,1,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,1,Saida).

linhaTabuleiro([H|T],-1,2,Resposta):-string_concat(Resposta,"01", Saida),linhaTabuleiro([H|T],0,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-Index < 6,validaPecaPrint(H,2,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,2,Saida).    
linhaTabuleiro([H|T],Index,2,Resposta):-(Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-(Index > 5 , Index < 20),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,2,Saida).
linhaTabuleiro([H|T],Index,2,Resposta):-Index < 21,string_concat(Resposta,"   ", Saida),CasoMenos is 2 - 2,IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,CasoMenos,Saida).

linhaTabuleiro([H|T],-1,3,Resposta):-string_concat(Resposta,"01", Saida),linhaTabuleiro([H|T],0,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index < 6; Index == 21),string_concat(Resposta,"|__", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).    
linhaTabuleiro([H|T],Index,3,Resposta):-(Index == 4 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):- Index == 20,string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index >  5 ; Index < 20),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro(_,Index,3,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,3,Saida).

linhaTabuleiro([H|T],-1,4,Resposta):-string_concat(Resposta,"02", Saida),linhaTabuleiro([H|T],0,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-(Index == 1;Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-(Index >  1 , Index < 21),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).
linhaTabuleiro([H|T],Index,4,Resposta):-validaPecaPrint(H,4,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,4,Saida).


linhaTabuleiro(_,-1,5,Resposta):-string_concat(Resposta,"02", Saida),linhaTabuleiro(_,0,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-(Index == 1;Index == 6 ; Index == 11 ),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index == 15,string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index > 14, Index < 21,string_concat(Resposta," __", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-Index > 1, Index < 21,string_concat(Resposta,"   ", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).
linhaTabuleiro(_,Index,5,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,5,Saida).

linhaTabuleiro([H|T],-1,6,Resposta):-string_concat(Resposta,"03", Saida),linhaTabuleiro([H|T],0,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-(Index == 1;Index == 6 ; Index == 11 ),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-Index > 1, Index < 15,string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H- H,linhaTabuleiro(T,IndexP,6,Saida).
linhaTabuleiro([H|T],Index,6,Resposta):-Index > 14, Index < 22,validaPecaPrint(H,6,A),string_concat(Resposta,A, Saida),IndexP is Index + 1 + H -H,linhaTabuleiro(T,IndexP,6,Saida).    
linhaTabuleiro([H|T],Index,6,Resposta):-validaPecaPrint(H,1,A),string_concat(Resposta,A, Saida),IndexP is Index + 1,linhaTabuleiro(T,IndexP,6,Saida).    
   
linhaTabuleiro([H|T],-1,7,Resposta):-string_concat(Resposta,"03", Saida),linhaTabuleiro([H|T],0,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-(Index == 6;Index == 11),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-Index > 1, Index < 15,string_concat(Resposta," __", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).

validaPecaPrint(Numero,6,Saida):-(Numero > 0 -> (number_string(Numero, ToString));string_concat("","<-",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,2,Saida):-(Numero > 0 -> (number_string(Numero, ToString));string_concat("","->",ToString)),(Numero > 0 -> string_concat(ToString," ",Saida1);string_concat("",ToString,Saida1)),string_concat("|",Saida1,Saida).
validaPecaPrint(Numero,_,Saida):-(Numero > 0 -> number_string(Numero, ToString);string_concat(""," ",ToString)),string_concat("|",ToString,Concat),string_concat(Concat," ",Saida).

printTabuleiro():- 
    write(" ______ "),nl,
    write("|      |"),nl,
    write("|______|"),nl,
    write("   "),
    linhaTabuleiro(1,0,-2,""),
    write("   "),   
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],0,-1,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,0,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1,1],-1,1,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,2,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,3,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,4,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,5,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,0,7,8,9,0,1],-1,6,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,0,7,8,9,0,1],-1,7,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,0,1],-1,0,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1,1],-1,1,""),
    write(" ______ "),nl,
    write("|      |"),nl,
    %if (x(peca1 jogador2)) == -1 then putStrLn "|  B1  | B1: base" else putStrLn ("|      | B1: x: " ++ show (x (peca1 jogador2)) ++ "; y: " ++ show (y (peca1 jogador2)))
    %if (x(peca2 jogador2)) == -1 then putStrLn "|  B2  | B2: base" else putStrLn ("|      | B2: x: " ++ show (x (peca2 jogador2)) ++ "; y: " ++ show (y (peca2 jogador2)))
    write("|______|"),nl.
    
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

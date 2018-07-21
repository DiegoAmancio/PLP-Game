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

inicia(X):-
    (X == 0 -> write("Iniciando VS"),nl; write("Iniciando BOT"),nl),
	make_peca(-1,-1,0,1,Peca1A),
	make_peca(-1,-1,0,2,Peca2A),
	make_peca(-1,-1,0,1,Peca1B),
	make_peca(-1,-1,0,2,Peca2B),
	make_jogador(Peca1A,Peca2A,"A",JogadorA),
	make_jogador(Peca1B,Peca2B,"B",JogadorB),
	gera_matriz(JogadorA, JogadorB, Tab),
	make_tabuleiro(JogadorA,JogadorB,Tab,Tabuleiro),
    dado(Dado),
    write("saiu "),write(Dado),write(" no dado"),nl,
	write(Tabuleiro),nl,
	printTabuleiro(Tabuleiro).


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

linhaTabuleiro([H|T],-1,3,Resposta):-string_concat(Resposta,"01", Saida),linhaTabuleiro([H|T],0,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index < 6; Index == 20),string_concat(Resposta,"|__", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).    
linhaTabuleiro([H|T],Index,3,Resposta):-(Index == 4 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):- Index == 20,string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index == 6 ; Index == 11 ; Index == 15),string_concat(Resposta,"|  ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
linhaTabuleiro([H|T],Index,3,Resposta):-(Index >  5 ; Index < 19),string_concat(Resposta,"   ", Saida),IndexP is Index + 1 + H - H,linhaTabuleiro(T,IndexP,3,Saida).
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
   
linhaTabuleiro([H|T],-1,7,Resposta):-string_concat(Resposta,"03", Saida),linhaTabuleiro([H|T],0,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-(Index == 6;Index == 11),string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-Index > 1, Index < 15,string_concat(Resposta," __", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).
linhaTabuleiro(_,Index,7,Resposta):-string_concat(Resposta,"|__", Saida),IndexP is Index + 1,linhaTabuleiro(_,IndexP,7,Saida).

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
    (X1 == -1 -> write("|  "),write(Time),write("1  | "),write(Time),write("1: base"),nl;
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
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],0,-1,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,0,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,1,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,2,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,3,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,4,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,1],-1,5,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,0,7,8,9,1],-1,6,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,0,7,8,9,1],-1,7,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,2],-1,0,""),
    linhaTabuleiro([0,1,2,0,1,1,1,1,8,9,1,1,1,1,1,1,1,7,8,9,2],-1,1,""),
    printaCaixa(Tabuleiro,2).
    
dado(X):-
    random(1,7,X).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).
printando([T]):- nl.
printando([H|T]):- write(H),nl,printando(T).
readHelp():-
    repeat,
    open('help.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    printando(Lines),
    main.
    halt(0).

readRules():-
    repeat,
    open('rules.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    printando(Lines),
    main.
    halt(0).

main:-
    repeat,
    write("1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"),nl,
    read_line_to_codes(user_input, X1),
    string_to_atom(X1, X2),
    atom_number(X2, X),
    (X == 1 -> inicia(0); X == 2 -> inicia(1); X == 3 -> readHelp(); X == 4 -> readRules()),
    halt(0).

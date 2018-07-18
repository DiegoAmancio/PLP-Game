:- initialization main.

jogo(X):-
    repeat,
    (X == "BOT" -> write("Iniciando BOT"),nl; write("Iniciando Player"),nl),
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
    (X == 1 -> jogo("Player"); X == 2 -> jogo("BOT"); X == 3 -> readHelp(); X == 4 -> readRules()),
    halt(0).

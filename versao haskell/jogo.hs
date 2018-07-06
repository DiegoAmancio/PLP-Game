import System.IO
import System.Random
import Control.Concurrent

--Caso tenha problemas com System.Random execute os seguintes comandos:
--sudo apt-get install cabal-instal
--cabal update
--cabal install random

data Peca = Peca { x :: Int
                 , y :: Int
                 , casas :: Int
                 , equipe :: String
                 , num :: Int} deriving Show

data Jogador = Jogador { peca1 :: Peca
                       , peca2 :: Peca
                       , time :: String} deriving Show

data Tabuleiro = Tabuleiro { jogadorA :: Jogador
                           , jogadorB :: Jogador
                           , matriz :: [[Int]]
                           } deriving Show

temPeca :: Peca -> Int -> Int -> Int
temPeca peca a b
    | x peca == a && y peca == b = 1
    | otherwise = 0

aqui :: Peca -> Int -> Int -> Bool
aqui peca a b
    | x peca == a && y peca == b = True
    | otherwise = False


contaJogador :: Jogador -> Int -> Int -> Int
contaJogador jog x y = temPeca (peca1 jog) (x) (y) + temPeca (peca2 jog) (x) (y)


contaLocal :: Jogador -> Jogador -> Int -> Int -> Int
contaLocal jog1 jog2 x y = contaJogador jog1 x y + contaJogador jog2 x y

contaLinha :: Jogador -> Jogador -> Int -> Int -> [Int] -> [Int]
contaLinha jog1 jog2 x y list
    | y == 20 = list++(contaLocal (jog1) (jog2) (x) (y):[])
    | otherwise = contaLinha (jog1) (jog2) (x) (y+1) (list++(contaLocal jog1 jog2 x y:[]))

geraTabuleiro :: Jogador -> Jogador -> [[Int]]
geraTabuleiro jog1 jog2 = [contaLinha jog1 jog2 0 0 [], contaLinha jog1 jog2 1 0 [], contaLinha jog1 jog2 2 0 [], contaLinha jog1 jog2 3 0 [], contaLinha jog1 jog2 4 0 []]

linhaTabuleiro :: Int -> Int -> [Int] -> String
linhaTabuleiro (-1) 21 _ = ""
linhaTabuleiro 0 21 _ = ""
linhaTabuleiro _ 21 _ = "|"

linhaTabuleiro numeroCaso index lista
                        |numeroCaso == -1 && index == -1 = "  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == -1 && index < 10 = " 0" ++ (show index)  ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == -1  = " " ++ (show index)  ++ linhaTabuleiro numeroCaso (index + 1) lista  
                        |numeroCaso == 0 && index == -1= "  " ++ linhaTabuleiro numeroCaso (index + 1) lista 
                        |numeroCaso == 0 = " __" ++ linhaTabuleiro numeroCaso (index + 1) lista 
                        |numeroCaso == 1 && index == -1 = "00" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 1 && (lista !! index) == 0 = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 1 = "|" ++ (show (lista !! index)) ++ " " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 2 && index == -1 = "00" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 2 = "|__" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && index == -1 = "01" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && index < 6 && (lista !! index) == 0 = "|->" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && index < 6 && (lista !! index) > 0 = "|" ++ (show (lista !! index)) ++ " " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && (index == 6 || index == 11 || index == 15)  = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && index > 5 && index < 19 = "   " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 3 && index == 19 = "   " ++ linhaTabuleiro (numeroCaso-2) (index + 1) lista
                        |numeroCaso == 4 && index == -1 = "01" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 4  && index < 6= "|__" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 4 && (index == 6 || index == 11 || index == 15)  = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 4  && index == 19 =  "   " ++ linhaTabuleiro (numeroCaso-2) (index + 1) lista
                        |numeroCaso == 4 && index > 5 && index < 20 = "   " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5 && index == -1 = "02" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5 && (index == 6 || index == 11 || index == 15) = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5 && index > 1 && index < 20 = "   " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5 && (index == 0 || index ==20)  && (lista !! index) == 0 = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5 && index == 1 = "|  "++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 5  = "|" ++ (show (lista !! index)) ++ " " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && index == -1 = "02" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && (index == 6 || index == 11 )  = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && index == 15= "|__"++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && index > 1 && index < 15= "   "++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && index > 13 && index < 20= " __"++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && (index == 0 || index == 20 ) = "|__" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 6 && index == 1 = "|  "++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 && index == -1 = "03" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 && (index == 6 || index == 11)  = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 && index == 1 = "|  "++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 && index > 0 && index < 15 = "   "++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 && index > 14 && index < 22 && (lista !! index) == 0 = "|<-"++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7 &&  (lista !! index) == 0  = "|  " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 7   = "|" ++ (show (lista !! index)) ++ " " ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 8 && index == -1 = "03" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 8 && (index == 6 || index == 11)  = "|__" ++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 8 && index > 1 && index < 15 && not (index == 6) = " __"++ linhaTabuleiro numeroCaso (index + 1) lista
                        |numeroCaso == 8 = "|__" ++ linhaTabuleiro numeroCaso (index + 1) lista
              
printaTab :: [[Int]] -> Jogador -> Jogador -> IO()
printaTab lista jogador1 jogador2 = do
    putStrLn " ______ "
    putStrLn "|      |"
    if (x(peca1 jogador1)) == -1 then putStrLn "|  A1  | A1: base" else putStrLn ("|      | A1: x: " ++ show (x (peca1 jogador1)) ++ "; y: " ++ show (y (peca1 jogador1)))
    if (x(peca2 jogador1)) == -1 then putStrLn "|  A2  | A2: base" else putStrLn ("|      | A2: x: " ++ show (x (peca2 jogador1)) ++ "; y: " ++ show (y (peca2 jogador1)))
    putStrLn "|______|\n"
    putStrLn (linhaTabuleiro (-1) (-1) (lista !! 0))
    putStrLn (linhaTabuleiro 0 (-1) (lista !! 0))
    putStrLn (linhaTabuleiro 1 (-1) (lista !! 0))
    putStrLn (linhaTabuleiro 2 (-1) (lista !! 0))
    putStrLn (linhaTabuleiro 3 (-1) (lista !! 1))
    putStrLn (linhaTabuleiro 4 (-1) (lista !! 1))
    putStrLn (linhaTabuleiro 5 (-1) (lista !! 2))
    putStrLn (linhaTabuleiro 6 (-1) (lista !! 2))
    putStrLn (linhaTabuleiro 7 (-1) (lista !! 3))
    putStrLn (linhaTabuleiro 8 (-1) (lista !! 3))
    putStr "04"
    putStrLn (linhaTabuleiro 1 0 (lista !! 4))
    putStr "04"
    putStrLn (linhaTabuleiro 2 0 (lista !! 4))
    putStrLn " ______ "
    putStrLn "|      |"
    if (x(peca1 jogador2)) == -1 then putStrLn "|  B1  | B1: base" else putStrLn ("|      | B1: x: " ++ show (x (peca1 jogador2)) ++ "; y: " ++ show (y (peca1 jogador2)))
    if (x(peca2 jogador2)) == -1 then putStrLn "|  B2  | B2: base" else putStrLn ("|      | B2: x: " ++ show (x (peca2 jogador2)) ++ "; y: " ++ show (y (peca2 jogador2)))
    putStrLn "|______|"

verificaJogadaA :: Tabuleiro -> Int -> Bool
verificaJogadaA tab dado
    | (x (peca1 (jogadorA tab)) == -1) && (x (peca2 (jogadorA tab)) == -1) && dado /= 6 = False
    | (x (peca1 (jogadorA tab)) == -1) && (x (peca2 (jogadorA tab)) == 1) && ((y (peca2 (jogadorA tab)))+dado > 6) && dado /= 6 = False
    | (x (peca1 (jogadorA tab)) == 1) && ((y (peca1 (jogadorA tab)))+dado > 6) && (x (peca2 (jogadorA tab)) == -1) && dado /= 6 = False
    | (x (peca1 (jogadorA tab)) == 1) && ((y (peca1 (jogadorA tab)))+dado > 6) && (x (peca2 (jogadorA tab)) == 1) && ((y (peca2 (jogadorA tab)))+dado > 6) = False
    | otherwise = True

verificaJogadaB :: Tabuleiro ->  Int -> Bool
verificaJogadaB tab dado
        | (x (peca1 (jogadorB tab)) == -1) && (x (peca2 (jogadorB tab)) == -1) && dado /= 6 = False
        | (x (peca1 (jogadorB tab)) == -1) && (x (peca2 (jogadorB tab)) == 3) && ((y (peca2 (jogadorB tab)))-dado < 14) && dado /= 6 = False
        | (x (peca1 (jogadorB tab)) == 3) && (((y (peca1 (jogadorB tab)))-dado) < 14) && (x (peca2 (jogadorB tab)) == -1) && dado /= 6 = False
        | (x (peca1 (jogadorB tab)) == 3) && ((y (peca1 (jogadorB tab)))-dado < 14) && (x (peca2 (jogadorB tab)) == 3) && ((y (peca2 (jogadorB tab)))-dado < 14) = False
        | otherwise = True
    
verificaJogada :: Tabuleiro -> Bool -> Int -> Bool
verificaJogada tab timeB dado
    | timeB = verificaJogadaB tab dado
    | otherwise = verificaJogadaA tab dado

podeJogarA :: Peca -> Int -> Bool
podeJogarA peca dado
    | x peca == -1 && dado /= 6 = False
    | x peca == 1 && (y peca)+dado > 6 && (y peca) /= 20 = False
    | otherwise = True

podeJogarB :: Peca -> Int -> Bool
podeJogarB peca dado
    | x peca == -1 && dado /= 6 = False
    | x peca == 3 && (y peca)-dado < 14 && (y peca) /= 0 = False
    | otherwise = True

verificaCome :: Peca -> Jogador -> Jogador -> Jogador
verificaCome peca jog1 jog2
    | contaLocal (jog1) (jog2) (x peca) (y peca) == 1 && (aqui (peca1 jog2) (x peca) (y peca)) = Jogador (Peca (-1) (-1) (0) (time jog2) (1)) (peca2 jog2) (time jog2)
    | contaLocal (jog1) (jog2) (x peca) (y peca) == 1 && (aqui (peca2 jog2) (x peca) (y peca)) = Jogador (peca1 jog2) (Peca (-1) (-1) (0) (time jog2) (2)) (time jog2)
    | otherwise = jog2

jogaAux :: Tabuleiro -> Bool -> Int -> IO()
jogaAux tab timeB dado = do
    putStr "Escolha a peca: 1 ou 2\n"
    input <- getLine
    let numPeca = (read input :: Int)
    if(numPeca == 1) then do
        if (not timeB) then do
            if(podeJogarA (peca1 (jogadorA tab)) (dado)) then do
                let novaPeca = movePeca (peca1 (jogadorA tab)) (dado)
                let novoJogador = Jogador (novaPeca) (peca2 (jogadorA tab)) (time (jogadorA tab))
                let adversario = verificaCome (novaPeca) (novoJogador) (jogadorB tab) 
                let novoTab = Tabuleiro (novoJogador) (adversario) (geraTabuleiro (novoJogador) (jogadorB tab))
                if ((x novaPeca) == 1) && (y novaPeca) == 6 then if (x (peca1 novoJogador) == 1) && (y (peca1 novoJogador) == 6) then venceu "1" else joga (novoTab) (timeB)
                else if (dado == 6) then joga (novoTab) (timeB) else joga (novoTab) (not timeB)
            else do
                putStr "Peca invalida\n"
                jogaAux tab timeB dado
        else do
            if(podeJogarB (peca1 (jogadorB tab)) (dado)) then do
                let novaPeca = movePeca (peca1 (jogadorB tab)) (dado)
                let novoJogador = Jogador (novaPeca) (peca2 (jogadorB tab)) (time (jogadorB tab))
                let adversario = verificaCome (novaPeca) (novoJogador) (jogadorA tab) 
                let novoTab = Tabuleiro (adversario) (novoJogador) (geraTabuleiro (jogadorA tab) (novoJogador))
                if (x novaPeca == 3) && (y novaPeca == 14) then if (x (peca2 novoJogador) == 3) && (y (peca2 novoJogador) == 14) then venceu "2" else joga (novoTab) (timeB)
                else if (dado == 6) then joga (novoTab) (timeB) else joga (novoTab) (not timeB) 
            else do
                putStr "Peca invalida\n"
                jogaAux tab timeB dado
    else if (numPeca == 2) then do
        if (not timeB) then do
            if(podeJogarA (peca2 (jogadorA tab)) (dado)) then do
                let novaPeca = movePeca (peca2 (jogadorA tab)) (dado)
                let novoJogador = Jogador (peca1 (jogadorA tab)) (novaPeca) (time (jogadorA tab))
                let adversario = verificaCome (novaPeca) (novoJogador) (jogadorB tab) 
                let novoTab = Tabuleiro (novoJogador) (adversario) (geraTabuleiro (novoJogador) (jogadorB tab))
                if (x novaPeca == 1) && (y novaPeca == 6) then if (x (peca2 novoJogador) == 1) && (y (peca2 novoJogador) == 6) then venceu "1" else joga (novoTab) (timeB)
                else if (dado == 6) then joga (novoTab) (timeB) else joga (novoTab) (not timeB)
            else do
                putStr "Peca invalida\n"
                jogaAux tab timeB dado
        else do
            if(podeJogarB (peca2 (jogadorB tab)) (dado)) then do
                let novaPeca = movePeca (peca2 (jogadorB tab)) (dado)
                let novoJogador = Jogador (peca1 (jogadorB tab)) (novaPeca) (time (jogadorB tab))
                let adversario = verificaCome (novaPeca) (novoJogador) (jogadorA tab) 
                let novoTab = Tabuleiro (adversario) (novoJogador) (geraTabuleiro (jogadorB tab) (novoJogador))
                if (x novaPeca == 3) && (y novaPeca == 14) then if (x (peca1 novoJogador) == 3) && (y (peca1 novoJogador) == 14) then venceu "2" else joga (novoTab) (timeB)
                else if (dado == 6) then joga (novoTab) (timeB) else joga (novoTab) (not timeB)
            else do
                putStr "Peca invalida\n"
                jogaAux tab timeB dado
    else do
        putStr "Peca invalida\n"
        jogaAux (tab) (timeB) (dado)

joga :: Tabuleiro -> Bool ->  IO()
joga tab timeB = do
    
    threadDelay 500000
    printaTab (matriz tab) (jogadorA tab) (jogadorB tab)
    dado <- rollDice
    putStr (vez False timeB)
    input <- getLine
    if (input == "desistir") then do 
        putStrLn (desistir False timeB) 
        if(timeB) then venceu "1" else venceu "2"
        else putStr ""
    putStr ("Saiu " ++ show dado ++ " no dado\n")
    if (verificaJogada tab timeB dado) then
        jogaAux tab timeB dado
    else
        joga (tab) (not timeB)

jogaAuxBot :: Tabuleiro -> Bool -> Int -> IO()
jogaAuxBot tab timeB dado = do

    if (not timeB) then do
        input <- getLine
        let numPeca = (read input :: Int)
        if(numPeca == 1) then do
            if(podeJogarA (peca1 (jogadorA tab)) (dado)) then do
                let novaPeca = movePeca (peca1 (jogadorA tab)) (dado)
                let novoJogador = Jogador (novaPeca) (peca2 (jogadorA tab)) (time (jogadorA tab))
                let adversario = verificaCome (novaPeca) (novoJogador) (jogadorB tab) 
                let novoTab = Tabuleiro (novoJogador) (adversario) (geraTabuleiro (novoJogador) (jogadorB tab))
                if ((x novaPeca) == 1) && (y novaPeca) == 6 then if (x (peca1 novoJogador) == 1) && (y (peca1 novoJogador) == 6) then venceu "1" else jogaBot (novoTab) (timeB)
                else if (dado == 6) then jogaBot (novoTab) (timeB) else jogaBot (novoTab) (not timeB)
            else do
                putStr "Peca invalida\n"
                jogaAuxBot tab timeB dado
        else if (numPeca == 2) then do
                if(podeJogarA (peca2 (jogadorA tab)) (dado)) then do
                    let novaPeca = movePeca (peca2 (jogadorA tab)) (dado)
                    let novoJogador = Jogador (peca1 (jogadorA tab)) (novaPeca) (time (jogadorA tab))
                    let adversario = verificaCome (novaPeca) (novoJogador) (jogadorB tab) 
                    let novoTab = Tabuleiro (novoJogador) (adversario) (geraTabuleiro (novoJogador) (jogadorB tab))
                    if (x novaPeca == 1) && (y novaPeca == 6) then if (x (peca2 novoJogador) == 1) && (y (peca2 novoJogador) == 6) then venceu "1" else jogaBot (novoTab) (timeB)
                    else if (dado == 6) then jogaBot (novoTab) (timeB) else jogaBot (novoTab) (not timeB)
                else do
                    putStr "Peca invalida\n"
                    jogaAuxBot tab timeB dado
        else do
                putStr "Peca invalida\n"
                jogaAuxBot (tab) (timeB) (dado)
    else do
        aux <- escolheBot
        let numPeca = aux
        if(numPeca == 1) then do
            if(podeJogarB (peca1 (jogadorB tab)) (dado)) then do
                    let novaPeca = movePeca (peca1 (jogadorB tab)) (dado)
                    let novoJogador = Jogador (novaPeca) (peca2 (jogadorB tab)) (time (jogadorB tab))
                    let adversario = verificaCome (novaPeca) (novoJogador) (jogadorA tab) 
                    let novoTab = Tabuleiro (adversario) (novoJogador) (geraTabuleiro (jogadorA tab) (novoJogador))
                    if (x novaPeca == 3) && (y novaPeca == 14) then if (x (peca2 novoJogador) == 3) && (y (peca2 novoJogador) == 14) then venceu "2" else jogaBot (novoTab) (timeB)
                    else if (dado == 6) then jogaBot (novoTab) (timeB) else jogaBot (novoTab) (not timeB) 
                else
                    jogaAuxBot tab timeB dado
        else do
                if(podeJogarB (peca2 (jogadorB tab)) (dado)) then do
                    let novaPeca = movePeca (peca2 (jogadorB tab)) (dado)
                    let novoJogador = Jogador (peca1 (jogadorB tab)) (novaPeca) (time (jogadorB tab))
                    let adversario = verificaCome (novaPeca) (novoJogador) (jogadorA tab) 
                    let novoTab = Tabuleiro (adversario) (novoJogador) (geraTabuleiro (jogadorB tab) (novoJogador))
                    if (x novaPeca == 3) && (y novaPeca == 14) then if (x (peca1 novoJogador) == 3) && (y (peca1 novoJogador) == 14) then venceu "2" else jogaBot (novoTab) (timeB)
                    else if (dado == 6) then jogaBot (novoTab) (timeB) else jogaBot (novoTab) (not timeB)
                else
                    jogaAuxBot tab timeB dado


jogaBot :: Tabuleiro -> Bool ->  IO()
jogaBot tab timeB = do
            
    threadDelay 500000
    printaTab (matriz tab) (jogadorA tab) (jogadorB tab)
    dado <- rollDice
    putStr (vez True timeB)
    if(not timeB) then do
        input <- getLine
        if (input == "desistir") then do 
            putStrLn (desistir True timeB) 
            venceu "2"
        else putStr ""
    else threadDelay 500000
    putStr ("Saiu " ++ show dado ++ " no dado\n")
    if (verificaJogada tab timeB dado) then
        jogaAuxBot tab timeB dado
    else
        jogaBot (tab) (not timeB)


inicia :: IO()
inicia = do
    let peca1A = Peca (-1) (-1) 0 "A" 1
    let peca2A = Peca (-1) (-1) 0 "A" 2
    let peca1B = Peca (-1) (-1) 0 "B" 1
    let peca2B = Peca (-1) (-1) 0 "B" 2
    let jogador1 = Jogador peca1A peca2A "A"
    let jogador2 = Jogador peca1B peca2B "B"
    let tabuleiro = Tabuleiro jogador1 jogador2 (geraTabuleiro jogador1 jogador2)
    joga tabuleiro False

iniciaBot :: IO()
iniciaBot = do
    let peca1A = Peca (-1) (-1) 0 "A" 1
    let peca2A = Peca (-1) (-1) 0 "A" 2
    let peca1B = Peca (-1) (-1) 0 "B" 1
    let peca2B = Peca (-1) (-1) 0 "B" 2
    let jogador1 = Jogador peca1A peca2A "A"
    let jogador2 = Jogador peca1B peca2B "B"
    let tabuleiro = Tabuleiro jogador1 jogador2 (geraTabuleiro jogador1 jogador2)
    jogaBot tabuleiro False

movePecaA :: Peca -> Int -> Peca
movePecaA peca 0 = peca
movePecaA peca dado
    | (x peca == -1 && (dado == 6)) = movePeca (Peca 0 1 0 "A" (num peca)) (0) 
    | x peca == 0 && y peca < 20 = movePecaA (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca < 4 && y peca == 20 = movePecaA (Peca (x peca+1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 4 && y peca > 0 = movePecaA (Peca (x peca) (y peca-1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca > 1 && y peca == 0 = movePecaA (Peca (x peca-1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 1 && ((y peca)+dado) <= 6 = movePecaA (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | otherwise = peca

movePecaB :: Peca -> Int -> Peca
movePecaB peca 0 = peca
movePecaB peca dado
    | ((x peca) == -1) && (dado == 6) = movePeca (Peca 4 19 0 "B" (num peca)) (0) 
    | x peca == 4 && y peca > 0 = movePecaB (Peca (x peca) (y peca-1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca > 0 && y peca == 0 = movePecaB (Peca (x peca-1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 0 && y peca < 20 = movePecaB (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca < 3 && y peca == 20 = movePecaB (Peca (x peca+1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 3 && ((y peca)-dado) >= 14 = movePecaB (Peca (x peca) (y peca-1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | otherwise = peca

movePeca :: Peca -> Int ->  Peca
movePeca peca dado
    | equipe peca == "A" = movePecaA peca dado
    | otherwise = movePecaB peca dado


venceu :: String -> IO()
venceu time = do
    putStrLn ("O jogador " ++ time ++ " venceu!!")
    menuInicial

menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    input <- getLine
    if input == "1" then inicia
    else if input == "2" then iniciaBot
    else if input == "3" then ajuda
    else if input == "4" then regras
    else if input == "5" then putStrLn "jogo encerrado"
    else menuInicial
         
desistir ::  Bool -> Bool -> String
desistir versusBot timeB
           | versusBot  &&  not timeB  = "Você desistiu, consequentemente... Voce perdeu!\n"
           | not versusBot && not timeB = "Player 1 desistiu \n Player 2 ganhou\n"
           | otherwise =  "Player 2 desistiu \n Player 1 ganhou\n"
           

ganhou :: Bool -> Bool -> String
ganhou versusBot timeB
           | versusBot  &&  not timeB  = "voce ganhou\n"
           | not versusBot && timeB = "Player 2 ganhou\n"
           | otherwise =  "Player 1 ganhou\n"
           

vez :: Bool -> Bool -> String
vez versusBot timeB 
    | versusBot  &&  not timeB  = "Sua vez  => digite qualquer coisa para rodar o dado ou desistir para sair:\n"
    | not versusBot && not timeB  = "Vez do Player 1  => digite qualquer coisa para rodar o dado ou desistir para sair:\n"
    | versusBot && timeB = "Vez do bot : o bot vai jogar o dado...\n"
    | otherwise =  "Vez do Player 2  => digite qualquer coisa para rodar o dado ou desistir para sair:\n"


parouOuVolta :: Bool -> Bool  -> IO()
parouOuVolta versusBot timeB =  do
    putStrLn (desistir versusBot timeB)
    putStrLn "Se quiser voltar para o menu digite sim,qualquer outra coisa digitada encerrado jogo\n"
    reiniciar <- getLine
    if reiniciar == "sim" then menuInicial else putStrLn "jogo encerrado"                      
                        



regras :: IO ()
regras = do 
    arquivo <- openFile "rules.txt" ReadMode  
    arquivoStr <- hGetContents arquivo  
    putStr arquivoStr  
    hClose arquivo
    
    menuInicial
  
ajuda :: IO()
ajuda = do
    arquivo <- openFile "help.txt" ReadMode  
    arquivoStr <- hGetContents arquivo  
    putStr arquivoStr  
    hClose arquivo
    menuInicial 
   
escolheBot :: IO Int
escolheBot = getStdRandom (randomR (1,2))

rollDice :: IO Int
rollDice = getStdRandom (randomR (1,6))

main = do
    menuInicial
    
    

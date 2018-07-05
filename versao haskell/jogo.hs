import System.IO
import System.Random
import Control.Concurrent


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
                           , armadilhas :: [[Int]]} deriving Show

temPeca :: Peca -> Int -> Int -> Int
temPeca peca a b
    | x peca == a && y peca == b = 1
    | otherwise = 0

contaJogador :: Jogador -> Int -> Int -> Int
contaJogador jog x y = temPeca (peca1 jog) (x) (y) + temPeca (peca2 jog) (x) (y)


contaLocal :: Jogador -> Jogador -> Int -> Int -> Int
contaLocal jog1 jog2 x y = contaJogador jog1 x y + contaJogador jog2 x y

contaLinha :: Jogador -> Jogador -> Int -> Int -> [Int] -> [Int]
contaLinha jog1 jog2 x y list
    | y == 20 = list++(contaLocal (jog1) (jog2) (x) (y):[])
    | otherwise = contaLinha (jog1) (jog2) (x) (y+1) (list++(contaLocal jog1 jog2 x y:[]))

--colocaArmadilha :: Int -> Int -> [[Int]] -> [[Int]]

geraArmadilhas :: [[Int]]
geraArmadilhas = [[]]

geraTabuleiro :: Jogador -> Jogador -> [[Int]]
geraTabuleiro jog1 jog2 = [contaLinha jog1 jog2 0 0 [], contaLinha jog1 jog2 1 0 [], contaLinha jog1 jog2 2 0 [], contaLinha jog1 jog2 3 0 [], contaLinha jog1 jog2 4 0 []]

atualizaTabuleiro :: Tabuleiro -> Tabuleiro
atualizaTabuleiro tab = Tabuleiro (jogadorA tab) (jogadorB tab) (geraTabuleiro (jogadorA tab) (jogadorB tab)) (armadilhas tab)
--putStrLn (show ((lista !! 1) !!1) ++ "__|" ++ "dd")
linhaTabuleiro :: Int -> Int -> [Int] -> String
linhaTabuleiro 0 21 _ = ""
linhaTabuleiro _ 21 _ = "|"
linhaTabuleiro x y lista|x == 0 = " __" ++ linhaTabuleiro x (y + 1) lista 
                        |x == 1 && (lista !! y) == 0 = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 1 = "|" ++ (show (lista !! y)) ++ " " ++ linhaTabuleiro x (y + 1) lista
                        |x == 2 = "|__" ++ linhaTabuleiro x (y + 1) lista
                        |x == 3 && y < 6 && (lista !! y) == 0 = "|->" ++ linhaTabuleiro x (y + 1) lista
                        |x == 3 && y < 6 && (lista !! y) > 0 = "|" ++ (show (lista !! y)) ++ " " ++ linhaTabuleiro x (y + 1) lista
                        |x == 3 && (y == 6 || y == 11 || y == 15)  = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 3 && y > 5 && y < 19 = "   " ++ linhaTabuleiro x (y + 1) lista
                        |x == 3 && y == 19 = "   " ++ linhaTabuleiro (x-2) (y + 1) lista
                        |x == 4  && y < 6= "|__" ++ linhaTabuleiro x (y + 1) lista
                        |x == 4 && (y == 6 || y == 11 || y == 15)  = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 4  && y == 19 =  "   " ++ linhaTabuleiro (x-2) (y + 1) lista
                        |x == 4 && y > 5 && y < 20 = "   " ++ linhaTabuleiro x (y + 1) lista
                        |x == 5 && (y == 6 || y == 11 || y == 15) = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 5 && y > 1 && y < 20 = "   " ++ linhaTabuleiro x (y + 1) lista
                        |x == 5 && (y == 0 || y ==20)  && (lista !! y) == 0 = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 5 && y == 1 = "|  "++ linhaTabuleiro x (y + 1) lista
                        |x == 5  = "|" ++ (show (lista !! y)) ++ " " ++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && (y == 6 || y == 11 )  = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && y == 15= "|__"++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && y > 1 && y < 15= "   "++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && y > 13 && y < 20= " __"++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && (y == 0 || y == 20 ) = "|__" ++ linhaTabuleiro x (y + 1) lista
                        |x == 6 && y == 1 = "|  "++ linhaTabuleiro x (y + 1) lista
                        |x == 7 && (y == 6 || y == 11)  = "|  " ++ linhaTabuleiro x (y + 1) lista
                        |x == 7 && y == 1 = "|  "++ linhaTabuleiro x (y + 1) lista
                        |x == 7 && y > 0 && y < 15 = "   "++ linhaTabuleiro x (y + 1) lista
                        |x == 7 && y > 14 && y < 22 && (lista !! y) == 0 = "|<-"++ linhaTabuleiro x (y + 1) lista
                        |x == 7 &&  (lista !! y) == 0  = "|" ++ (show (lista !! y)) ++ " " ++ linhaTabuleiro x (y + 1) lista
                        |x == 7   = "|" ++ (show (lista !! y)) ++ " " ++ linhaTabuleiro x (y + 1) lista
                        |x == 8 && (y == 6 || y == 11)  = "|__" ++ linhaTabuleiro x (y + 1) lista
                        |x == 8 && y > 1 && y < 15 && not (y == 6) = " __"++ linhaTabuleiro x (y + 1) lista
                        |x == 8 = "|__" ++ linhaTabuleiro x (y + 1) lista
              
printaTab :: [[Int]] -> [Int] -> IO()
printaTab lista lista2= do
   
    putStrLn (linhaTabuleiro 0 0 (lista !! 0))
    putStrLn (linhaTabuleiro 1 0 (lista !! 0))
    putStrLn (linhaTabuleiro 2 0 (lista !! 0))
    putStrLn (linhaTabuleiro 3 0 (lista !! 1))
    putStrLn (linhaTabuleiro 4 0 (lista !! 1))
    putStrLn (linhaTabuleiro 5 0 (lista !! 2))
    putStrLn (linhaTabuleiro 6 0 (lista !! 2))
    putStrLn (linhaTabuleiro 7 0 (lista !! 3))
    putStrLn (linhaTabuleiro 8 0 (lista !! 3))
    putStrLn (linhaTabuleiro 1 0 (lista !! 4))
    putStrLn (linhaTabuleiro 2 0 (lista !! 4))
inicia :: IO()
inicia = do
    let peca1A = Peca (-1) (-1) 0 "A" 1
    let peca2A = Peca (-1) (-1) 0 "A" 2
    let peca1B = Peca (-1) (-1) 0 "B" 1
    let peca2B = Peca (-1) (-1) 0 "B" 2
    let jogador1 = Jogador peca1A peca2A "A"
    let jogador2 = Jogador peca1B peca2B "B"
    let tabuleiro = Tabuleiro jogador1 jogador2 (geraTabuleiro jogador1 jogador2) geraArmadilhas
    if(1 == 1) then putStr "OK" else putStr "OK";

movePecaA :: Peca -> Int -> Peca
movePecaA peca 0 = peca
movePecaA peca dado
    | x peca == 0 && y peca < 20 = movePecaA (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca < 4 && y peca == 20 = movePecaA (Peca (x peca+1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 4 && y peca > 0 = movePecaA (Peca (x peca) (y peca-1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca > 1 && y peca == 0 = movePecaA (Peca (x peca-1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | otherwise = movePecaA (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)

movePecaB :: Peca -> Int -> Peca
movePecaB peca 0 = peca
movePecaB peca dado
    | x peca == 4 && y peca > 0 = movePecaA (Peca (x peca) (y peca-1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca > 0 && y peca == 0 = movePecaA (Peca (x peca-1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca == 0 && y peca < 20 = movePecaA (Peca (x peca) (y peca+1) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | x peca < 3 && y peca == 20 = movePecaA (Peca (x peca+1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)
    | otherwise = movePecaA (Peca (x peca+1) (y peca) (casas peca+1) (equipe peca) (num peca)) (dado-1)

movePeca :: Peca -> Int -> Peca
movePeca peca dado
    | equipe peca == "A" = movePecaA peca dado
    | otherwise = movePecaB peca dado

podeMover :: Int -> Peca -> String
podeMover dado peca |x peca == -1 && y peca == -1 && dado < 6 = "é necessario tirar 6 no dado para a peça sair da base"
                    |x peca == 1 && (6-dado) > 0 = "para peça chegar no final é necessario tirar o numero restante de casas para o final" 
                    |otherwise = "ok"
menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    input <- getLine
    if input == "1" then inicioPlayer False False
    else if input == "2" then inicioPlayer True False
    else if input == "3" then ajuda
    else if input == "4" then regras
    else putStrLn "jogo encerrado"
         
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


inicioPlayer :: Bool -> Bool -> IO ()
inicioPlayer versusBot timeB = do  
                        putStrLn (vez versusBot timeB)
                        desistiu <- getLine
                        if desistiu == "desistir" then parouOuVolta versusBot timeB else vezPlayer versusBot timeB

vezBot :: Int -> IO()
vezBot dado = do 
    putStrLn (vez True True)
    --jogapeca
    threadDelay 2000000
    inicioPlayer True False



vezPlayer ::  Bool -> Bool -> IO()
vezPlayer versusBot timeB = do
   --dado
    --jogapeca
    
    if  (not versusBot)  then inicioPlayer versusBot (not timeB)
    else vezBot 2--fazer dado
    


parouOuVolta :: Bool -> Bool  -> IO()
parouOuVolta versusBot timeB =  do
    putStrLn (desistir versusBot timeB)
    putStrLn "Se quiser voltar para o menu digite sim,qualuqer outra coisa digitada encerrado jogo\n"
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
main = do
    menuInicial
    
    

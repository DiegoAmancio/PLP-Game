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
temPeca peca x y
    | ((x peca) == x && (y peca) == y) = 1
    | otherwise = 0

contaJogador :: Jogador -> Int -> Int -> Int
contaJogador jog x y = temPeca (peca1 jog) (x) (y) + temPeca (peca2 jog) (x) (y)


contaLocal :: Jogador -> Jogador -> Int -> Int -> Int
contaLocal jog1 jog2 x y = contaJogador jog1 x y + contaJogador jog2 x y

contaLinha :: Jogador -> Jogador -> Int -> Int -> [Int] -> [Int]
contaLinha jog1 jog2 x y list
    | y == 20 = (list:(contaLocal (jog1) (jog2) (x) (y)))
    | otherwise = contaLinha (jog1) (jog2) (x) (y+1) (list:contaLocal jog1 jog2 x y)

colocaArmadilha :: Int -> Int -> [[Int]] -> [[Int]]

geraArmadilhas :: [[Int]]


geraTabuleiro :: Jogador -> Jogador -> [[Int]]
geraTabuleiro jog1 jog2 = [contaLinha jog1 jog2 0 0, contaLinha jog1 jog2 1 0, contaLinha jog1 jog2 2 0, contaLinha jog1 jog2 3 0, contaLinha jog1 jog2 4 0]

inicia :: IO()
    let peca1A = Peca {x = -1, y = -1, casas = 0, equipe = "A", num = 1}
    let peca2A = Peca {x = -1, y = -1, casas = 0, equipe = "A", num = 2}
    let peca1B = Peca {x = -1, y = -1, casas = 0, equipe = "B", num = 1}
    let peca2B = Peca {x = -1, y = -1, casas = 0, equipe = "B", num = 2}
    let jogador1 = Jogador {peca1 = peca1A, peca2 = peca2A, time = "A"}
    let jogador2 = Jogador {peca1 = peca1B, peca2 = peca2B, time = "B"}
    let tabuleiro = Tabuleiro {jogadorA = jogador1, jogadorB = jogador2, matriz = geraTabuleiro jogador1 jogador2, armadilhas = geraArmadilhas}

movePecaA :: Peca -> Int -> Peca
movePecaA peca 0 = peca
movePecaA peca dado
    | x peca == 0 && y peca < 20 = movePecaA (Peca {x peca, (y peca)+1, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca < 4 && y peca == 20 = movePecaA (Peca {(x peca)+1, y peca, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca == 4 && y peca > 0 = movePecaA (Peca {x peca, (y peca)-1, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca > 1 && y peca == 0 = movePecaA (Peca {(x peca)-1, y peca, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | otherwise = movePecaA (Peca {x peca, (y peca)+1, (casas peca)+1, equipe peca, num peca}) (dado-1)

movePecaB :: Peca -> Int -> Peca
movePecaB peca 0 = peca
movePecaB peca dado
    | x peca == 4 && y peca > 0 = movePecaA (Peca {x peca, (y peca)-1, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca > 0 && y peca == 0 = movePecaA (Peca {(x peca)-1, y peca, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca == 0 && y peca < 20 = movePecaA (Peca {x peca, (y peca)+1, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | x peca < 3 && y peca == 20 = movePecaA (Peca {(x peca)+1, y peca, (casas peca)+1, equipe peca, num peca}) (dado-1)
    | otherwise = movePecaA (Peca {(x peca)+1, y peca, (casas peca)+1, equipe peca, num peca}) (dado-1)

movePeca :: Peca -> Int -> Peca
movePeca peca dado
    | equipe peca == "A" = movePecaA peca dado
    | otherwise = movePecaB peca dado

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
vez versusBot timeB | versusBot  &&  not timeB  = 	"Sua vez  => digite qualquer coisa para rodar o dado ou desistir para sair:\n"
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
    

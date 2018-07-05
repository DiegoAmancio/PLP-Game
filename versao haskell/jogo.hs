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
    
    if  (not versusBot) then inicioPlayer versusBot (not timeB)
    else vezBot 2--fazer dado
    
bloco1 :: Int -> [Int] -> String
bloco1 0 [] = ""
bloco1 _ [] = "|"
bloco1 a (x:xs) |a == 0 = " __" ++ bloco1 a xs
                |a == 1 = "|  " ++ bloco1 a xs
                |a == 2 = "|__" ++ bloco1 a xs
printTab ::  IO()
printTab  = do
    putStrLn (show (bloco1 0 [1..21]))
    putStrLn (show (bloco1 1 [1..21]))
    putStrLn (show (bloco1 2 [1..21]))
   


parouOuVolta :: Bool -> Bool  -> IO()
parouOuVolta versusBot timeB =  do
    putStrLn (desistir versusBot timeB)
    putStrLn "Se quiser voltar para o menu digite sim,qualuqer outra coisa digitada encerrado jogo\n"
    reiniciar <- getLine
    if reiniciar == "sim" then menuInicial else putStrLn "jogo encerrado"                      


regras :: IO ()
regras = do 
    arquivo <- openFile   "rules.txt" ReadMode  
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
    printTab 
    

import System.IO
import System.Random
import Control.Concurrent

menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    
    input <- getLine
    if input == "1" then inicioPlayer False False--jogo2p
    else if input == "2" then main --jogoVsBot
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
jogo :: Bool -> Bool -> IO()
jogo versusBot timeB =
    inicioPlayer versusBot timeB

inicioPlayer :: Bool -> Bool -> IO ()
inicioPlayer versusBot timeB = do  
                        putStrLn (vez versusBot timeB)
                        desistiu <- getLine
                        
                        if desistiu == "desistir" then parouOuVolta versusBot timeB else continuando versusBot timeB

inicioBot :: Int -> IO()
inicioBot dado = do 
    putStrLn (vez True True)
    --jogapeca
    threadDelay 2000000
    inicioPlayer True False




random :: Int -> IO Int
random n = randomRIO (1, n :: Int)                    

continuando ::  Bool -> Bool -> IO()
continuando versusBot timeB = 
   --dado
    --jogapeca
    if  (not versusBot)  then inicioPlayer versusBot (not timeB)
    else inicioBot 2 --dado
    


parouOuVolta :: Bool -> Bool  -> IO()
parouOuVolta versusBot timeB =  do
    putStrLn (desistir versusBot timeB)
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
    

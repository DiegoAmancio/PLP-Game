import System.IO
import System.Random

menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    
    input <- getLine
    if input == "1" then inicioPlayer False--jogo2p
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

inicioPlayer :: Bool -> IO ()
inicioPlayer versusBot timeB = do  
                        putStrLn (vez False timeB)
                        desistiu <- getLine
                        
                        if desistiu == "desistir" then parouVolta False timeB else continuando False timeB
inicioBot :: Int -> IO()
inicioBot dado = 
    putStrLn (vez True True)
    let ss = 2
    --jogapeca
    inicioPlayer False
random :: Int -> IO Int
random n = randomRIO (1, n :: Int)                    

continuando ::  Bool -> Bool -> IO()
continuando versusBot timeB = 
   --dado
    --jogapeca
    if not versusBot || timeB then inicioPlayer False
    else inicioBot 2 --dado
    


parouVolta :: Bool -> Bool  -> IO()
parouVolta versusBot timeB =  do
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
    

import System.IO

menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    
    input <- getLine
    if input == "1" then main --jogo2p
    else if input == "2" then main --jogoVsBot
    else if input == "3" then ajuda
    else if input == "4" then regras
    else putStrLn "jogo encerrado"
         
desistir ::  Int -> Int -> String
desistir versusBot timeB
           | versusBot == 1 &&  timeB == 0  = "Você desistiu, consequentemente... Voce perdeu!\n"
           | versusBot == 0 && timeB == 0 = "Player 1 desistiu \n Player 2 ganhou\n"
           | otherwise =  "Player 2 desistiu \n Player 1 ganhou\n"

ganhou :: Int -> Int -> String
ganhou versusBot timeB
           | versusBot == 1 &&  timeB == 0  = "voce ganhou\n"
           | versusBot == 0 && timeB == 1 = "Player 2 ganhou\n"
           | otherwise =  "Player 1 ganhou\n"


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
    

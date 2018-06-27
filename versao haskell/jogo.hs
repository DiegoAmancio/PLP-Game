import System.IO

menuInicial :: IO ()
menuInicial = do 
    putStrLn "1 - Versus Player        \n2 - Versus Computador         \n3 - Ajuda/Creditos\n4 - Regras        \n5 - Sair          \n"
    input <- getLine
    if input == "3" then ajuda
    else if input == "4" then regras
    else putStrLn "jogo encerrado"
         
   
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
    

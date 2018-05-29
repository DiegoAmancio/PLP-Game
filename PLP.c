#include "PLP.h"
 



int main() {

    //Aqui cuida do menu
    int continuar = 1;
    int num;
    char cont[3];
    int sair;
    int c;
    FILE *fp;
    char str[5000];
    while (continuar) {
        while (1) {
			
            printf("1 - Jogar         \n2 - Ajuda/Creditos\n3 - Regras        \n4 - Sair          \n");
		    scanf("%i", &num);
            if (num >= 1 && num <= 4) {
                break;
            } else {
                printf("Entrada invalida, digite 1, 2, 3 ou 4\n");
            }
           
        }
       

        switch (num) {
            case 1:
                jogo();
                break;
            case 2:
                fp = fopen("help.txt","r");
                if (fp) {
                    while ((c = getc(fp)) != EOF)
                        putchar(c);
                }
                fclose(fp);
                break;
            case 3:
                fp = fopen("rules.txt", "r");
                if (fp) {
                    while ((c = getc(fp)) != EOF)
                        putchar(c);
                }
                fclose(fp);
                break;

            default :
                continuar = 0;
                continue;
        }

        while (1) {
            printf("Deseja continuar? sim/nao\n");
            scanf("%s", cont);
            if (strcmp(cont, "nao") == 0) {
                continuar = 0;
                break;
            } else if (strcmp(cont, "sim") == 0) {
                break;
            } else {
                printf("Entrada invalida, digite sim ou nao\n");
            }
        }
        
    }
}

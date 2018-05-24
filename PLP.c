#include "PLP.h"


int main() {

    //Aqui cuida do menu
    int continuar = 1;
    int num;
    char cont[3];
    int sair;
    FILE *fp;
    while (continuar) {
        while (TRUE) {
            printf("1 - SinglePlayer\n2 - MultiPlayer\n3 - Ajuda/Creditos\n4 - Regras\n5 - Sair\n");
            scanf("%i", &num);
            if (num >= 1 && num <= 5) {
                break;
            } else {
                printf("Entrada invalida, digite 1, 2, 3, 4 ou 5\n");
            }
        }

        switch (num) {
            case 1:
                singlePlayer();
                break;
            case 2 :
                multiPlayer();
                break;
            case 3  :
                fp = fopen("help.txt","r");
                printf("Digite '1' para voltar");
                scanf("%i", &sair);
                
                if (sair==1) {
                    fclose(fp);
                    break;
                }
            case 4  :
                fp = fopen("rules.txt", "r");
                printf("Digite '1' para voltar");
                scanf("%i", &sair);
                if (sair == 1)
                {
                    fclose(fp);
                    break;
                }
            default :
                continuar = 0;
                continue;
        }

        while (TRUE) {
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
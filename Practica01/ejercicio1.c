#include <stdio.h>
#include <string.h>


int main(int argc, char const *argv[])
{
    char *nombre;
    int rendimiento = 0;
    if(argc==2){
        printf("Faltan argumentos");
        return 0;
    }
    if (argc>3)
    {
        printf("Solo me debes dar 2 argumentos");
        return 0;
    }
    if(strcmp(argv[1],"-R")==0){
        rendimiento = 1;
    }
    
    return 0;
}

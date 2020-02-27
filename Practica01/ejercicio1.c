#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
    char *nombre;
    int rendimiento = 0;
    if(argc==2)
    {
        printf("Faltan argumentos");
        return 0;
    }
    if (argc>3)
    {
        printf("Solo me debes dar 2 argumentos");
        return 0;
    }
    if(strcmp(argv[1],"-R")==0)
    {
        rendimiento = 1;
    }
    nombre = argv[2];
    FILE *datos = fopen(nombre,"r");
    int computadoras[1];
    int pruebas[1];
    fscanf(datos,"%i",computadoras);
    fscanf(datos,"%i",pruebas);
    float resultados[computadoras[0]][pruebas[0]];
    for(int i = 0;i<computadoras[0];i++)
    {
        for(int j = 0;j<pruebas[0];j++)
        {
            float resultado[1];
            fscanf(datos,"%f",resultado);
            resultados[i][j] = resultado[0];
        }
    }
    
    //calculo_mejor_computadora(datos,rendimiento);
    return 0;
}

/*void calculo_mejor_computadora(FILE *datos,int rendimiento)
{
    int computadoras = 0;
    char *prueba;
    int pruebas = 0;
    fscanf(datos,"%s",prueba);
    printf("%s",prueba);
}*/
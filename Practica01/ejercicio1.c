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
    int auxcomputadoras[1];
    int auxpruebas[1];
    fscanf(datos,"%i",auxcomputadoras);
    fscanf(datos,"%i",auxpruebas);
    int computadoras = auxcomputadoras[0];
    int pruebas = auxpruebas[0];
    float resultados[computadoras][pruebas];
    for(int i = 0;i<computadoras;i++)
    {
        for(int j = 0;j<pruebas;j++)
        {
            float resultado[1];
            fscanf(datos,"%f",resultado);
            resultados[i][j] = resultado[0];
        }
    }
    float medias_aritmeticas[computadoras];
    for(int i = 0;i<computadoras;i++)
    {
        float media = 0;
        for(int j = 0;j<pruebas;j++)
        {
            media += resultados[i][j]; 
        }
        media /= pruebas;
        medias_aritmeticas[i] = media;
    }
    float primeros_valores [pruebas];
    for(int i = 0;i<pruebas;i++)
        {
            primeros_valores[i] = resultados[0][i];
        }
    
    float medias_geometricas[computadoras];
        for(int i = 0;i<computadoras;i++)
        {
            float media = 0;
            for(int j = 0;j<pruebas;j++)
            {
                media += (resultados[i][j]/primeros_valores[j]); 
            }
            media /= pruebas;
            medias_geometricas[i] = media;
        }
           
    //calculo_mejor_computadora(resultados,rendimiento);
    return 0;
}



/*void calculo_mejor_computadora(int resultados[][],int rendimiento)
{
    int media_aritmetica = media_aritmetica(resultados);
}*/
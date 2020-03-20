#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int hib(int computadoras,float medias_geometricas[])
{
    int mejor = 0;
    float mayor = medias_geometricas[0];
    for (int i = 0; i < computadoras; i++)
    {
        if(medias_geometricas[i]>mayor)
        {
            mayor = medias_geometricas[i];
            mejor = i;
        }
    }
    return mejor;
}

int lib(int computadoras,float medias_geometricas[])
{
    int mejor = 0;
    float menor = medias_geometricas[0];
    for (int i = 0; i < computadoras; i++)
    {
        if(medias_geometricas[i]<menor)
        {   
            menor = medias_geometricas[i];
            mejor = i;
        }
    }
    return mejor;
}

void muestra_resultados(int computadoras,float medias_aritmeticas[],int mejor_computadora,int rendimiento){
    printf("%d\n",mejor_computadora);
    if (rendimiento)
    {
        for (int i = 0; i < computadoras; i++)
        {
            float veces_mejor = medias_aritmeticas[mejor_computadora]/medias_aritmeticas[i];
            printf("%f\n",veces_mejor);
        }
        
    }
    else
    {
        for (int i = 0; i < computadoras; i++)
        {
            float veces_mejor = medias_aritmeticas[i]/medias_aritmeticas[mejor_computadora];
            printf("%f\n",veces_mejor);
        }
    }
    
}

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
    if(strcmp(argv[1],"-R")!=0 && strcmp(argv[1],"-T")!=0)
    {
        printf("Solo puedo recibir las banderas -R y -T\n");
        return 0;
    }
    if(strcmp(argv[1],"-R")==0)
    {
        rendimiento = 1;
    }
    nombre = argv[2];
    FILE *datos = fopen(nombre,"r");
    int pruebas ;
    int computadoras ;
    fscanf(datos,"%i",&computadoras);
    fscanf(datos,"%i",&pruebas);
    float resultados[computadoras][pruebas];
    for(int i = 0;i<computadoras;i++)
    {
        for(int j = 0;j<pruebas;j++)
        {
            float resultado;
            fscanf(datos,"%f",&resultado);
            resultados[i][j] = resultado;
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
    int mejor_computadora = 0;
    if(rendimiento){
        mejor_computadora = hib(computadoras,medias_geometricas);
    }
    else
    {
       mejor_computadora = lib(computadoras,medias_geometricas);
    }
    muestra_resultados(computadoras,medias_aritmeticas,mejor_computadora,rendimiento);
    return 0;
}
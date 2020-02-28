#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>


typedef struct {
    int cicles;
    int n;
} instruction;

typedef struct {
    int linesc;
    bool frecuency;
    bool time;
    float duration;
    instruction lines[];    
} report;

void wtf(char *error){
    printf("%s\n",error);
    printf("saliendo del programa\n");
    exit(1);
}

void check_args(int argc)
{  
    int n = 2;
    if(argc>2) wtf("Demasiados argumentos fueron proporcionados");
    else if(argc<2) wtf("faltan argumentos");
}

bool is_flag(char *flag)
{
    return flag[0]=='-';
}

char* get_flag(char *flag){
    return strtok(flag, "-");
}

report* create_report_from_file(FILE *f)
{
    report *rep;
    int linesc = 0;
    fscanf(f, "%d", &linesc);
    rep = malloc(sizeof(rep)+sizeof(instruction)*linesc);
    rep->linesc = linesc;
    for(int alfa=0; alfa<rep->linesc; alfa++){
        instruction ins;
        fscanf(f, "%d ", &(ins.cicles));
        rep->lines[alfa] = ins;
    }
    for(int alfa=0; alfa<rep->linesc; alfa++){
        fscanf(f, "%d ", &(rep->lines[alfa].n));
    }
    char type;
    fscanf(f, "%c", &type);
    if(!(type=='F' || type=='T')) wtf("Opción no reconocida");
    rep->frecuency = type=='F';
    rep->time = type=='T';
    fscanf(f, "%f", &(rep->duration));
    return rep;
}

int tot_cicles(report* rep)
{
    int tot_cicles;
    for(int alfa=0; alfa<rep->linesc; alfa++)
        tot_cicles+=rep->lines[alfa].cicles*rep->lines[alfa].n;
    return tot_cicles;
}

float calc_from_cicles(report* rep)
{
    return ((float) tot_cicles(rep))*rep->duration;
}

float calc_from_frecuency(report* rep)
{
    return ((float) tot_cicles(rep))/rep->duration;
}

float calculate_from_report(report* rep)
{
    if(rep->time)
        return calc_from_cicles(rep);
    else
        return calc_from_frecuency(rep);
}

void calculate_from_file(char* name){
    FILE *file;
    file = fopen(name, "r");
    if(file==NULL) wtf("Ocurrio un error al leer el archivo");
    report* rep = create_report_from_file(file);
    int result = calculate_from_report(rep);
    printf("result: %d\n", result);
}

int main(int argc, char *argv[])
{
    check_args(argc);
    calculate_from_file(argv[1]);
    return 0;
}


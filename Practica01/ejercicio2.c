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

FILE parse_args(char *argv[])
{
    FILE *file;
    char *name = argv[1];
    file = fopen(name, "r");
    if(file==NULL) wtf("Ocurrio un error al leer el archivo");
    return *file;
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

void calculate_from_file(char* name){
    
}

int main(int argc, char *argv[])
{
    check_args(argc);
    FILE file = parse_args(argv);
    report* rep = create_report_from_file(&file);
    return 0;
}


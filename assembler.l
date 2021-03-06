    /* ASM to Obj Code Application */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <string.h>
    #include "helpers.c"

    /* I/O Files */
    extern FILE *yyin;
    extern FILE *yyout;
    FILE *out_endian;
    char *OUTFILE = "out.lst";
    char *OUTFILE_ENDIAN = "out.endian";

    int lineno = 1;             /* line number */
    int contador_hexa = 0;      /* Cuenta 1 por cada 2 digitos desplegados, muestra los números hexadecimales al inicio de cada línea */

    void yyerror(char *);       /* error log */
    void emitCode(char *s);
    void emitEndian(char *s);
    char* Conversor_string_hexa(char *n); 
    char* Conversor_contador_hexa(int cont);
%}

    /* Sección para reglas léxicas*/
%%

    /* Símbolos permitidos */
[;:,]                       {
                                
                            }

    /* Los comentarios empiezan con punto y coma, por lo tanto cuando se encuentra uno se ignora toda la línea */
;.*                         ;

    /* Cuando se encuentra el símbolo de nueva línea, se aumenta el número de línea para los errores y se pasa a la siguiente en el out*/

\n                          {
                                lineno++;
                                emitCode("\n");
                            }

    /* Cuando la línea comienza con una instrucción, si se desplegará el contador*/
^[ \t]*[1-9][0-9]*          {
                                       
                                size_t leng = strlen(Conversor_contador_hexa(contador_hexa));
                                if(leng == 1){
                                    emitCode("0");
                                }
                                emitCode(Conversor_contador_hexa(contador_hexa));
                                emitCode("   ");

                                contador_hexa += 2;
                                size_t lenght = strlen(Conversor_string_hexa(yytext));
                                if(lenght == 1){
                                    emitCode("000");
                                }
                                else if(lenght==2){
                                    emitCode("00");
                                }
                                else if(lenght==3){
                                    emitCode("0");
                                }
                                emitCode(Conversor_string_hexa(yytext));
                                emitCode(" ");
                            
                            }

    /* decimal zero */
0                           {
                            }

    /* Integer is a of digits not empty */
    
[1-9][0-9]*                 {
                                contador_hexa += 2;
                                size_t lenght = strlen(Conversor_string_hexa(yytext));
                                if(lenght == 1){
                                    emitCode("000");
                                }
                                else if(lenght==2){
                                    emitCode("00");
                                }
                                else if(lenght==3){
                                    emitCode("0");
                                }
                                emitCode(Conversor_string_hexa(yytext));
                                emitCode(" ");
                            }

    /* Operators */
[-+]                        {
                                contador_hexa++;
                                int value=strcmp(yytext, "-");
                                if(value==0){
                                    emitCode("00");
                                }            
                                else{
                                    emitCode("01");
                                }
                                emitCode(" ");
                            }

    /* Interruption */
h                           {
                                contador_hexa+= 3;
                                emitCode("0000 ");
                                emitCode("11");
                                emitCode(" ");
                            }


     /* Ignore empty spaces */
[ \t]+                      ;             


    /* Any other throws error */
.               {
                    yyerror(yytext);
                }

%%

// Default lex function for end of file
int yywrap(void) {
    return 1;
}

// Handles lexical errors
void yyerror(char *s) {
	fprintf(stderr, "Lexical error at line %d. Encountered: '%s'\n", lineno, s);
}

/* 
Descripción: imprime codigos en el archivo de output (out file)
Recibe: Un string para escribir en el archivo
*/

void emitCode(char *s) {
    fprintf(yyout, "%s", s);
}

void emitEndian(char *s) {
    fprintf(out_endian, "%s", s);
}

// Application entry point
int main(int argumentos, char* argumentosAnexos[]) {   
    // File passed as argument
    if (argumentos == 2) {
        FILE *arch = fopen(argumentosAnexos[1], "r");
        
        // Passed file was not found
        if (!arch) {
            printf("in file couldn't be opened %s.\n", argumentosAnexos[1]);
            exit(1);
        }
        yyin=arch;
    }

    // Opens output file
    yyout = fopen(OUTFILE, "w+");
    if(!yyout) {
        printf("out file couldn't be opened\n");
        exit(1);
    }

    // Opens output file for endian formatt
    out_endian = fopen(OUTFILE_ENDIAN, "w+");
    if(!out_endian) {
        printf("out endian file couldn't be opened\n");
        exit(1);
    }

    emitCode("00");

    // The function that starts the analysis
    yylex();
  
    // Closes the files
    fclose(yyin);
    fclose(yyout);
    fclose(out_endian);
    
    return 0;
}
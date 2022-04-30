    /* ASM to Obj Code Application */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdarg.h>
    #include <string.h>

    /* I/O Files */
    extern FILE *yyin;
    extern FILE *yyout;
    char *OUTFILE = "out.bin";

    int lineno = 1;             /* line number */

    static int CODESIZE = 50;   /* lenght of a line of code */

    void yyerror(char *);       /* error log */
    void emitCode(char *s);
%}


    /* Seccion for lexical rules */
%%
    /* Counts the line number */
\n                          {
                                lineno++;
                            }

    /* decimal zero */
0                           {
                            }

    /* Integer is a of digits not empty */
[1-9][0-9]*                 {
                                emitCode("000");
                                emitCode(yytext);
                                emitCode(" ");
                            }

    /* Operators */
[-+]                        {
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
[h]                         {
                                emitCode("11");
                                emitCode(" ");
                            }

    /* Symbols */
[:,]                        {
                            }

    /* Commentaries begin with doble semicolon */
;.*             ;

     /* Ignore empty spaces */
[ \t]+          ;

                        
    /* Any other throws error */
.               {
                    yyerror("Error lexico: simbolo desconocido");
                }

%%


int yywrap(void) {
    return 1;
}

// Handles lexical errors
void yyerror(char *s) {
	fprintf(stderr, "linea %d: %s\n", lineno, s);
}

// Writes code to the yyout file
void emitCode(char *s) {
    char codestr[CODESIZE];
    sprintf(codestr, s); 
    fflush(stdin);
    fputs(codestr, yyout);
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

    // The function that starts the analysis
    yylex();
  
    // Closes the files
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}
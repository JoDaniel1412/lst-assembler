
/*
Descripción: Convierte un número decimal a su versión hexadecimal y lo regresa en forma de string (char*) 
Recibe: Un string que contenga un número en su forma decimal
Retorna: Un string con la forma hexadecimal del número
*/

char* Conversor_string_hexa(char *n){

        int numero = atoi(n);
        char * num_hexa;
        num_hexa = malloc(sizeof(char)*10);
        sprintf(num_hexa, "%x",numero);        
     
        return num_hexa;
}

char* Conversor_contador_hexa(int cont){
    
    char* num_hexa_2;
    num_hexa_2 = malloc(sizeof(char)*10);
    sprintf(num_hexa_2, "%x",cont);        
    
    return num_hexa_2;
}

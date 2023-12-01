#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int get_diff_charachters(char *path){
    char ch, prev = '@';
    FILE *file;
    int n_char = 0, n_mem = 0;

    file = fopen(path, "r");
    while ((ch = getc(file)) != EOF){
        n_char++;
        if (ch == '\n'){
            n_mem -= 2;
        }
        if (prev == '\\'){
            switch(ch){
                case 'x':
                    n_mem -= 3; 
                    break;
                case '\"':
                    n_mem--; 
                    break;
                case '\\':
                    n_mem--; 
                    break;
            }
            prev = '@';
        } else {
            prev = ch;
        }
    }
    n_mem = n_char + n_mem;
    fclose(file);
    return n_char - n_mem;
}


int get_number_characters(char *path){
    char ch, prev = '@';
    FILE *file;
    int n_char = 0;

    file = fopen(path, "r");
    while ((ch = getc(file)) != EOF){
        if (ch != '\n'){
            if (ch == '\\' || ch == '\"'){
                n_char++;
            }
        } else {
            n_char += 2;
        }
    }
    fclose(file);
    return n_char;
}

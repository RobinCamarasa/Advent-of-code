#include <stdio.h>
#include <stdlib.h>


int get_floor(char *path){
    char ch;
    int i=0;
    FILE *file;
    file = fopen(path, "r");

    while ((ch = fgetc(file)) != EOF) {
        if (ch == ')'){
            i--;
        } else if (ch == '(') {
            i++;
        }
    }
    fclose(file);
    return i;
}


int get_first_basement(char *path){
    char ch;
    int i=0, j=0;
    FILE *file;
    file = fopen(path, "r");

    while ((ch = fgetc(file)) != EOF) {
        if (ch == ')'){
            i--;
        } else if (ch == '(') {
            i++;
        }
        j++;
        if (i < 0){
            fclose(file);
            return j;
        }
    }
    fclose(file);
    return -1;
}

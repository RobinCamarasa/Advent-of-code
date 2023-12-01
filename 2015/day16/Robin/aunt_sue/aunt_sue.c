#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int get_index(char *key){
    switch(key[0]){
        case 'c':
            switch(key[2]){
                case 'i':
                    return 0;
                case 't':
                    return 1;
                case 'r':
                    return 8;
            }
        case 's':
            return 2;
        case 'p':
            switch(key[1]){
                case 'o':
                    return 3;
                case 'e':
                    return 9;
            }
        case 'a':
            return 4;
        case 'v':
            return 5;
        case 'g':
            return 6;
        case 't':
            return 7;
    }
}


void init(int **aunts, char *path){
    FILE *file;
    char *line=NULL, *token=NULL;
    size_t n;
    ssize_t n_read;
    int i=0, index=0, value=0;

    for (i=0; i<500; i++){
        for (int j=0; j<10; j++){
            aunts[i][j] = -1;
        }
    }

    file = fopen(path, "r");
    i=0;
    while ((n_read = getline(&line, &n, file)) != -1){
        token = strtok(line, "\n");
        token = strtok(token, " ");
        token = strtok(NULL, " ");
        while (1){
            token = strtok(NULL, " ");
            if (token == NULL)
                break;
            index = get_index(token);

            token = strtok(NULL, " ");
            if (token == NULL)
                break;
            value = atoi(token);
            aunts[i][index] = value;
        }
        i++;
    }
    fclose(file);
}

int find_aunt(int **aunts, int mfcsam_output[10]){
    int is_aunt=1;
    for (int i=0; i<500; i++){
        for (int j=0; j<10; j++){
            if (
                    (aunts[i][j] != -1 && mfcsam_output[j] != aunts[i][j])
               ){
                is_aunt = 0;
                break;
            }
        }
        if (is_aunt)
            return i+1;
        is_aunt = 1;
    }
    return -1;
}


int find_aunt_with_instruction(int **aunts, int mfcsam_output[10]){
    int is_aunt=1;
    for (int i=0; i<500; i++){
        for (int j=0; j<10; j++){
            if (j==1 || j==7){
                if (aunts[i][j] != -1 && mfcsam_output[j] >= aunts[i][j]){
                    is_aunt = 0;
                    break;
                }
            } else if (j==3 || j==6) {
                if (aunts[i][j] != -1 && mfcsam_output[j] <= aunts[i][j]){
                    is_aunt = 0;
                    break;
                }
            } else if (aunts[i][j] != -1 && mfcsam_output[j] != aunts[i][j]){
                is_aunt = 0;
                break;
            }
        }
        if (is_aunt)
            return i+1;
        is_aunt = 1;
    }
    return -1;
}

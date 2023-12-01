#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "light_house.h"

int **init_grid(int n){
    int **grid;

    // Allocate memory
    grid=malloc(n * sizeof(int *));
    for (int i=0; i<n; i++){
        grid[i] = malloc(n * sizeof(int));
    }

    // Fill grid with zeros
    for (int i=0; i<n; i++){
         for (int j=0; j<n; j++){
             grid[i][j] = 0;
         }
    }
    return grid;
}


void apply_instructions(int **grid, char *path, int correct_translation){
    FILE *stream;
    char *line = NULL;
    size_t len = 0;
    size_t nread;
    char *pair_ptr=NULL, *int_ptr=NULL;
    int min_x, min_y, max_x, max_y;

    stream = fopen(path, "r");

    // Extract information line by line
    while ((nread = getline(&line, &len, stream)) != EOF) {

        // Parse line
        pair_ptr = malloc(strlen(line) * sizeof(char));
        strcpy(pair_ptr, line+5);
        pair_ptr = strtok(pair_ptr, " ");
        pair_ptr = strtok(NULL, " ");

        // Parse the first couple of numbers
        int_ptr=malloc(strlen(line) * sizeof(char));
        strcpy(int_ptr, pair_ptr);
        int_ptr = strtok(int_ptr, ",");
        min_x = atoi(int_ptr);
        int_ptr = strtok(NULL, " ");
        min_y = atoi(int_ptr);

        // Get the second couple of numbers
        pair_ptr = malloc(strlen(line) * sizeof(char));
        strcpy(pair_ptr, line+5);
        pair_ptr = strtok(pair_ptr, " ");
        for (int i=0; i < 3; i++)
            pair_ptr = strtok(NULL, " ");

        // Parse the second couple of numbers
        int_ptr=malloc(strlen(line) * sizeof(char));
        strcpy(int_ptr, pair_ptr);
        int_ptr = strtok(int_ptr, ",");
        max_x = atoi(int_ptr);
        int_ptr = strtok(NULL, "\n");
        max_y = atoi(int_ptr);

        if (line[6] == 'n'){
            turn_on(grid, min_x, max_x, min_y, max_y, correct_translation);
        } else if (line[6] == 'f'){
            turn_off(grid, min_x, max_x, min_y, max_y, correct_translation);
        } else {
            toggle(grid, min_x, max_x, min_y, max_y, correct_translation);
        }
    }
    fclose(stream);
}

void toggle(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation){
    for (int i = min_x; i <= max_x; i++){
        for (int j = min_y; j <= max_y; j++){
            if (correct_translation){
                grid[i][j] += 2;
            } else {
                grid[i][j] = 1 - grid[i][j];
            }
        }
    }
}

void turn_on(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation){
    for (int i = min_x; i <= max_x; i++){
        for (int j = min_y; j <= max_y; j++){
            if (correct_translation){
                grid[i][j]++;
            } else {
                grid[i][j] = 1;
            }
        }
    }
}

void turn_off(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation){
    for (int i = min_x; i <= max_x; i++){
        for (int j = min_y; j <= max_y; j++){
            if (correct_translation){
                grid[i][j]--;
                if (grid[i][j] < 0)
                    grid[i][j] = 0;
            } else {
                grid[i][j] = 0;
            }
        }
    }
}

int get_sum(int **grid, int n){
    int lit=0;
    for (int i=0; i < n; i++){
        for (int j=0; j < n; j++){
            lit += grid[i][j];
        }
    }
    return lit;
}

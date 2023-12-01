#include <stdio.h>
#include <stdlib.h>


void initialize(int **grid, int size, char *path){
    for (int k=0; k<size; k++)
        grid[k] = malloc(size * sizeof(int));

    // Parse file
    FILE *file;
    char ch;
    int i=0, j=0;

    file = fopen(path, "r");
    while ((ch = getc(file)) != EOF){
        if (ch == '#'){
            grid[i][j] = 1;
            i++;
        } else if (ch == '.'){
            grid[i][j] = 0;
            i++;
        }
        if (i==size){
            j++;
            i=0;
        }
    }
    fclose(file);
}


void print_grid(int **grid, int size){
    for (int j=0; j<size; j++){
        for (int i=0; i<size; i++)
            printf("%d", grid[i][j]);
        printf("\n");
    }
}

int get_number_neighbours(int **grid, int size, int i, int j){
    int min_i=i-1, min_j=j-1, max_i=i+1, max_j=j+1, neighbours=-grid[i][j];
    if (i==0)
        min_i = 0;
    if (i == size - 1)
        max_i = size - 1;
    if (j==0)
        min_j = 0;
    if (j == size - 1)
        max_j = size - 1;
    for (int ii=min_i; ii<=max_i; ii++){
        for (int jj=min_j; jj<=max_j; jj++){
            neighbours += grid[ii][jj];
        }
    }
    return neighbours;
}

void update_grid(int **grid, int size, int new_rule){
    // Initialize tmp grid
    int **tmp_grid;
    tmp_grid = malloc(size * sizeof(int*));
    for (int i=0; i<size; i++)
        tmp_grid[i] = malloc(size * sizeof(int));

    // Loop over the grid
    int n_neighbours=0;
    if (new_rule){
        grid[0][0]=1;
        grid[0][size-1]=1;
        grid[size-1][0]=1;
        grid[size-1][size-1]=1;
    }
    for (int i=0; i<size; i++){
        for (int j=0; j<size; j++){
            n_neighbours = get_number_neighbours(grid, size, i, j);
            if (grid[i][j] == 1 && n_neighbours >= 2 && n_neighbours <= 3){
                tmp_grid[i][j] = 1;
            } else if (grid[i][j] == 0 && n_neighbours == 3){
                tmp_grid[i][j] = 1;
            } else{
                tmp_grid[i][j] = 0;
            }
        }
    }
    for (int i=0; i<size; i++){
        for (int j=0; j<size; j++){
            grid[i][j] = tmp_grid[i][j];
        }
    }
    if (new_rule){
        grid[0][0]=1;
        grid[0][size-1]=1;
        grid[size-1][0]=1;
        grid[size-1][size-1]=1;
    }

    // Free tmp grid
    for (int i=0; i<size; i++)
        free(tmp_grid[i]);
    free(tmp_grid);
}

void update_n_times_grid(int **grid, int size, int n, int new_rule){
    for (int i=0; i<n; i++){
        update_grid(grid, size, new_rule);
    }
}

int sum(int **grid, int size){
    int acc=0;
    for (int i=0; i<size; i++){
        for (int j=0; j<size; j++){
            acc += grid[i][j];
        }
    }
    return acc;
}

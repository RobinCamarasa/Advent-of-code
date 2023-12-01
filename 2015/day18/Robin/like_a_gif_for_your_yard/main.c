#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "like_a_gif_for_your_yard.h"


int main(int argc, char *argv[]) {
    int **grid, **tmp_grid;
    int size=100;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day18/Robin/like_a_gif_for_your_yard/input.txt";

    // Part one
    grid = malloc(size * sizeof(int*));
    initialize(grid, size, path);
    update_n_times_grid(grid, size, 100, 0);
    printf("The number of lights on is %d\n", sum(grid, size));
    for (int i=0; i<size; i++)
        free(grid[i]);
    free(grid);

    // Part two
    grid = malloc(size * sizeof(int*));
    initialize(grid, size, path);
    update_n_times_grid(grid, size, 100, 1);
    printf("The number of lights on, with the four corner, is %d\n", sum(grid, size));
    for (int i=0; i<size; i++)
        free(grid[i]);
    free(grid);
    return 0;
}

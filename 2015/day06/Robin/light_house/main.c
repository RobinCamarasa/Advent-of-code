#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "light_house.h"


int main(int argc, char *argv[]) {
    int grid_size=1000, **grid=NULL, sum;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day06/Robin/light_house/input.txt";
    // Part one
    grid = init_grid(grid_size);
    apply_instructions(grid, path, 0);
    sum = get_sum(grid, grid_size);
    printf("The number of sum lights is %d (binary version).\n", sum);

    // Part two
    grid = init_grid(grid_size);
    apply_instructions(grid, path, 1);
    sum = get_sum(grid, grid_size);
    printf("The total brightness is %d (continuous version).\n", sum);
    return 0;
}

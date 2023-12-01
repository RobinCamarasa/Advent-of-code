#include <stdio.h>

void initialize(int **grid, int size, char *path);
void update_grid(int **grid, int size, int new_rule);
void print_grid(int **grid, int size);
void update_n_times_grid(int **grid, int size, int n, int new_rule);
int sum(int **grid, int size);

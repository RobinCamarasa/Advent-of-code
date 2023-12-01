#include <stdio.h>

int **init_grid(int n);

void apply_instructions(int **grid, char *path, int correct_translation);
void toggle(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation);
void turn_on(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation);
void turn_off(int **grid, int min_x, int max_x, int min_y, int max_y, int correct_translation);

int get_sum(int **grid, int n);

#include <stdio.h>

void parse_input(int *containers, char *path);
int get_number_combinations(int *containers, int size, int index, int total_volume);
void get_number(int *containers, int *accumulator, int size, int index, int number_elements, int total_volume);
int get_number_minimum(int *accumulator, int size);

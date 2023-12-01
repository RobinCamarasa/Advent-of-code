#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "no_such_thing_as_too_much.h"


int main(int argc, char *argv[]) {
    // Part one
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day17/Robin/no_such_thing_as_too_much/input.txt";
    int *containers=malloc(20 * sizeof(int)), number_of_combinations;
    parse_input(containers, path);

    number_of_combinations = get_number_combinations(containers, 20, 0, 150);
    printf("The number of containers is %d\n", number_of_combinations);

    // Part two
    int *accumulator=malloc(20 * sizeof(int));
    for (int i=0; i<20; i++)
        accumulator[i] = 0;
    get_number(containers, accumulator, 20, 0, 0, 150);
    number_of_combinations = get_number_minimum(accumulator, 20);
    printf("The number of combinations with the smallest amount of elements is %d\n", number_of_combinations);
    free(containers);
    free(accumulator);
    return 0;
}

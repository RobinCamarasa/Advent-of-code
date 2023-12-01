#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "aunt_sue.h"


int main(int argc, char *argv[]) {
    int **aunts, mfcsam_output[10]={3, 7, 2, 3, 0, 0, 5, 3, 2, 1};
    int aunt_number;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day16/Robin/aunt_sue/input.txt";

    // Part one
    aunts=malloc(500 * sizeof(int *));
    for (int i=0; i<500; i++)
        aunts[i]=malloc(10 * sizeof(int));
    init(aunts, path);
    aunt_number = find_aunt(aunts, mfcsam_output);
    printf("This is aunt Sue %d.\n", aunt_number);

    // Part two
    aunt_number = find_aunt_with_instruction(aunts, mfcsam_output);
    printf("With correct instruction, this is aunt Sue %d.\n", aunt_number);

    for (int i=0; i<500; i++)
        free(aunts[i]);
    free(aunts);
    return 0;
}

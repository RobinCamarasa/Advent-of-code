#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "nice_string.h"


int main(int argc, char *argv[]) {
    int n_nice_line;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day05/Robin/nice_string/input.txt";
    // Part one
    n_nice_line = analyse_file(path, 0);
    printf("The number of nice lines is %d.\n", n_nice_line);

    // Part two
    n_nice_line = analyse_file(path, 1);
    printf("The number of nice lines is %d.\n", n_nice_line);
    return 0;
}

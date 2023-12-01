#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "santalist.h"


int main(int argc, char *argv[]) {
    // Part one
    char *path = "/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day08/Robin/santalist/input.txt";
    int res;
    res = get_diff_charachters(path);
    printf("Difference between the number of characters and the number of allocated characters in memory: %d\n", res);

    // Part two
    res = get_number_characters(path);
    printf("Number of characters after expansion: %d\n", res);
    return 0;
}

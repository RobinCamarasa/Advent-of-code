#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "circuit.h"


int main(int argc, char *argv[]) {
    // Part one
    current_t *currents;
    unsigned short int result;

    currents = init();
    parse_file(currents, "/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day07/Robin/circuit/input.txt");
    result = get_final_value(currents + hash("a"));
    printf("The current of \"a\" for the part one is %u\n", result);

    // Part two
    int hash_b;
    currents = init();
    parse_file(currents, "/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day07/Robin/circuit/input.txt");
    hash_b = hash("b");
    (currents + hash_b)->left_val = result;
    (currents + hash_b)->operation = -1;
    result = get_final_value(currents + hash("a"));
    printf("The current of \"b\" for the part one is %u\n", result);
    return 0;
}

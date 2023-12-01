#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "reindeer_olympics.h"


int main(int argc, char *argv[]) {
    // Part one
    int end_distance, max_points;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day14/Robin/reindeer_olympics/input.txt";
    deer_t *deers;
    deers = malloc(sizeof(deer_t));
    parse(deers, path);
    end_distance = get_max_distance(deers, 2503);
    printf("Max distance: %d\n", end_distance);

    // Part two
    max_points = get_max_points(deers, 2503);
    printf("Max points: %d\n", max_points);
    free_deers(deers);
    return 0;
}

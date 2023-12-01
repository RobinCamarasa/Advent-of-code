#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "housegrid.h"


void usage(){
    /* Print usage
     * */
    fprintf(stderr, "Usage: out [h] n\n\n");
    fputs(
        "[-h] Manual\n" 
        , stderr
    );
    exit(1);
}


int main(int argc, char *argv[]) {
    int opt; 
    while ((opt = getopt(argc, argv, "h")) != -1) {
        switch (opt) {
            case 'h':
                usage(); break;
            case '?':
                usage(); break;
            default:
                usage(); break;
        }
    }
    char *path;
    int grid_size;
    path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day03/Robin/housegrid/input.txt";

    // Parse input
    Position *positions;
    grid_size = get_grid_size(path);
    positions = malloc(2 * (grid_size + 1) * sizeof(int));
    parse_input(path, positions);

    // Get the number of visited houses
    int number_of_houses;
    number_of_houses = get_number_visited_houses(positions, grid_size);
    printf("Number of visited houses: %d\n", number_of_houses);
    free(positions);

    // Treat the case of the robot
    int path_size[2];
    Position *positions_santa, *positions_robot;
    positions_santa = malloc(grid_size * sizeof(int));
    positions_robot = malloc(grid_size * sizeof(int));
    parse_input_with_robot(path, positions_santa, positions_robot, path_size);

    // Get the number of visited houses
    number_of_houses = get_number_visited_houses_with_robot(positions_santa, positions_robot, path_size);
    printf("Number of visited houses with the robot: %d\n", number_of_houses);
    free(positions_santa);
    free(positions_robot);
    return 0;
}


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "shortestpath.h"


int main(int argc, char *argv[]) {
    int **graph;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day09/Robin/shortestpath/input.txt";
    int size = 8, distance;

    // Initialize graph
    graph = init_graph(path, size);

    // Initialize visited nodes (first always visited)
    // Compute distance
    distance = shortest_path(graph, 0, size, NULL);
    printf("The shortest distance is %d.\n", distance);

    distance = longest_path(graph, 0, size, NULL);
    printf("The longest distance is %d.\n", distance);
    return 0;
}

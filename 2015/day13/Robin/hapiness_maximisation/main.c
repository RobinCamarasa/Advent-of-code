#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "hapiness_maximisation.h"


int main(int argc, char *argv[]) {
    // Part one
    char *path = "/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day13/Robin/hapiness_maximisation/input.txt";
    int **graph, number_of_persons=8, max_hapiness;
    graph = malloc(number_of_persons * sizeof(int *));
    init(graph, path, number_of_persons);
    max_hapiness = get_maximum_of_hapiness(0, graph, NULL, number_of_persons);
    printf("Part one: The maximum of hapiness is %d\n", max_hapiness);

    // Part two
    int **new_graph;
    new_graph = malloc((number_of_persons + 1) * sizeof(int *));
    add_yourself(new_graph, graph, number_of_persons);
    max_hapiness = get_maximum_of_hapiness(0, new_graph, NULL, number_of_persons + 1);
    printf("Part two: The maximum of hapiness is %d\n", max_hapiness);
    free_rec(graph, number_of_persons);
    free_rec(new_graph, number_of_persons + 1);
    return 0;
}

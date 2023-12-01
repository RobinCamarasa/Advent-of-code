#include <stdio.h>

void init(int **graph, char *path, int number_of_persons);
int get_maximum_of_hapiness(int current_node, int **graph, int *visited, int number_of_persons);
void free_rec(int **graph, int number_of_persons);
void add_yourself(int **new_graph, int **graph, int number_of_persons);

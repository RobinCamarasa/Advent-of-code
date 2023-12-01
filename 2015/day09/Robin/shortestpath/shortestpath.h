#include <stdio.h>


int hash(char *place);
int **init_graph(char *path, int size);
int shortest_path(int **graph, int current_node, int size, int *visited);
int longest_path(int **graph, int current_node, int size, int *visited);

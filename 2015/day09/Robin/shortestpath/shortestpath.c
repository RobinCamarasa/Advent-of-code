#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int hash(char *place){
    if (place[0] == 'F')
        return 0;
    if (place[0] == 'T' && place[1] == 'r')
        return 1;
    if (place[0] == 'T')
        return 2;
    if (place[0] == 'N')
        return 3;
    if (place[0] == 'S' && place[1] == 'n')
        return 4;
    if (place[0] == 'S')
        return 5;
    if (place[0] == 'A' && place[1] == 'r')
        return 6;
    if (place[0] == 'A')
        return 7;
    return -1;
}

int **init_graph(char *path, int size){
    // Initialise structure
    int **graph;
    int i, j;
    graph = malloc(size * sizeof(int *));
    for (i = 0; i < size; i++){
        graph[i] = malloc(size * sizeof(int));
        for (j = 0; j < size; j++){
            graph[i][j] = 0;
        }
    }

    // Initialise graph with values
    FILE *file;
    char *line;
    size_t n;
    ssize_t n_read;
    int input_node, output_node, distance;

    file = fopen(path, "r");

    while ((n_read = getline(&line, &n, file)) != -1){
        line = strtok(line, "\n");
        line = strtok(line, " ");
        input_node = hash(line);

        line = strtok(NULL, " ");
        line = strtok(NULL, " ");
        output_node = hash(line);

        line = strtok(NULL, " ");
        line = strtok(NULL, " ");
        distance = atoi(line);
        graph[input_node][output_node] = distance;
        graph[output_node][input_node] = distance;
    }
    for (i=0; i<size; i++){
        for (j = 0; j < size; j++){
            printf("%d\t", graph[i][j]);
        }
        printf("\n");
    }
    return graph;
}

int shortest_path(int **graph, int current_node, int size, int *visited){
    // Initialize visited if necessary
    int dist=2147483647, sub_dist;
    int node=-1;
    if (visited == NULL){
        int *visited_nodes;
        visited_nodes = malloc(size * sizeof(int));
        for (int i=0; i < size; i++){
            visited_nodes[i] = 0;
        }
        for (int i=0; i < size; i++){
            visited_nodes[i]++;
            sub_dist = shortest_path(graph, i, size, visited_nodes);
            visited_nodes[i]--;
            if (sub_dist < dist)
                dist = sub_dist;
        }
        return dist;
    }

    for (int i=0; i<size; i++){
        if (visited[i] == 0){
            visited[i]++;
            sub_dist = shortest_path(graph, i, size, visited) + graph[current_node][i];
            visited[i]--;
            if (node == -1 || sub_dist < dist){
                dist = sub_dist;
                node = i;
            }
        }
    }
    if (dist == 2147483647){
        return 0;
    }
    return dist;
}


int longest_path(int **graph, int current_node, int size, int *visited){
    // Initialize visited if necessary
    int dist=-1, sub_dist;
    int node=-1;
    if (visited == NULL){
        int *visited_nodes;
        visited_nodes = malloc(size * sizeof(int));
        for (int i=0; i < size; i++){
            visited_nodes[i] = 0;
        }
        for (int i=0; i < size; i++){
            visited_nodes[i]++;
            sub_dist = longest_path(graph, i, size, visited_nodes);
            visited_nodes[i]--;
            if (sub_dist > dist)
                dist = sub_dist;
        }
        return dist;
    }

    for (int i=0; i<size; i++){
        if (visited[i] == 0){
            visited[i]++;
            sub_dist = longest_path(graph, i, size, visited) + graph[current_node][i];
            visited[i]--;
            if (node == -1 || sub_dist > dist){
                dist = sub_dist;
                node = i;
            }
        }
    }
    if (dist == -1){
        return 0;
    }
    return dist;
}


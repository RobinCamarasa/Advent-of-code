#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void init(int **graph, char *path, int number_of_persons){
    FILE *file;
    char *line=NULL;
    char *token=NULL;
    size_t n;
    ssize_t n_read;

    file = fopen(path, "r");
    for (int i = 0; i<number_of_persons; i++){
        graph[i] = malloc(number_of_persons * sizeof(int));
        for (int j = 0; j<number_of_persons; j++){
            if (i == j){
                graph[i][j] = 0;
            } else {
                n_read = getline(&line, &n, file);
                token = strtok(line, "\n");
                token = strtok(token, " ");
                token = strtok(NULL, " ");
                token = strtok(NULL, " ");
                if (token[0] - 'g' == 0){
                    graph[i][j] = 1;
                } else {
                    graph[i][j] = -1;
                }
                token = strtok(NULL, " ");
                graph[i][j] *= atoi(token);
            }
        }
    }
    fclose(file);
}


int get_maximum_of_hapiness(int current_node, int **graph, int *visited, int number_of_persons){
    if (visited == NULL){
        int *visited_nodes;
        visited_nodes = malloc(number_of_persons * sizeof(int));
        for (int j=0; j<number_of_persons; j++)
            visited_nodes[j] = 0;
        visited_nodes[0] = 1;
        return get_maximum_of_hapiness(0, graph, visited_nodes, number_of_persons);
    }
    int best_hapiness=-1000, tmp_hapiness;
    for (int i=0; i<number_of_persons; i++){
        if (visited[i] == 0){
            visited[i]++;
            tmp_hapiness = get_maximum_of_hapiness(i, graph, visited, number_of_persons) + graph[i][current_node] + graph[current_node][i];
            visited[i]--;
            if (tmp_hapiness > best_hapiness){
                best_hapiness = tmp_hapiness;
            }
        }
    }
    if (best_hapiness == -1000){
        return graph[current_node][0] + graph[0][current_node];
    }
    return best_hapiness;
}


void add_yourself(int **new_graph, int **graph, int number_of_persons){
    for (int i=0; i<=number_of_persons; i++){
        new_graph[i] = malloc((number_of_persons + 1) * sizeof(int));
    }
    for (int i=0; i<=number_of_persons; i++){
        new_graph[i][0] = 0;
        new_graph[0][i] = 0;
    }
    for (int i=0; i<number_of_persons; i++){
        for (int j=0; j<number_of_persons; j++){
            new_graph[i+1][j+1] = graph[i][j];
        }
    }
}

void free_rec(int **graph, int number_of_persons){
    for(int i=0; i<number_of_persons; i++){
        free(graph[i]);
    }
    free(graph);
}


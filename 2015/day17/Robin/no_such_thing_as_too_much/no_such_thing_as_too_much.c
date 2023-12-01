#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void parse_input(int *containers, char *path){
    FILE *file;
    size_t n;
    ssize_t n_read;
    char *line;
    int value, i;

    file = fopen(path, "r");
    i = 0;
    while((n_read = getline(&line, &n, file)) != -1){
        containers[i] = atoi(line);
        i++;
    }
    fclose(file);
}

int get_number_combinations(int *containers, int size, int index, int total_volume){
    if (total_volume == 0){
        return 1;
    }
    if (total_volume < 0 || index >= size) {
        return 0;
    }
    return get_number_combinations(
            containers, size, index+1, total_volume - containers[index]
            ) + get_number_combinations(
            containers, size, index+1, total_volume
            );
}


void get_number(int *containers, int *accumulator, int size, int index, int number_elements,  int total_volume){
    if (total_volume == 0){
        accumulator[number_elements] += 1;
    } else if (total_volume >= 0 && index < size) {
        get_number(containers, accumulator, size, index+1, number_elements+1, total_volume - containers[index]);
        get_number(containers, accumulator, size, index+1, number_elements, total_volume);
    }
}


int get_number_minimum(int *accumulator, int size){
    for (int i=0; i<size; i++){
        if (accumulator[i] != 0)
            return accumulator[i];
    }
    return -1;
}

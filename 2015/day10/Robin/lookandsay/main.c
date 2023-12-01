#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "lookandsay.h"

#define OUT_SIZE 1000000

int main(int argc, char *argv[]) {
    // Initialise node
    node_t *list;
    char *input_string = "1321131112";

    list = malloc(sizeof(node_t));


    init(list, input_string);
    for (int i=0; i<40; i++){
        list = compute_next_iteration(list);
    }
    printf("Length of the list after 40 iterations: %d\n", listlen(list));

    for (int i=0; i<10; i++){
        list = compute_next_iteration(list);
    }
    printf("Length of the list after 50 iterations: %d\n", listlen(list));
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lookandsay.h"


void init(node_t *list, char *string){
    for (int i=0; i<strlen(string); i++){
        list->next = malloc(sizeof(node_t));
        list->value = string[i] - '0';
        list = list->next;
    }
    list->value = -1;
}


void print(node_t *list){
    while (list->value != -1){
        printf("%d", list->value);
        list = list->next;
    }
    printf("\n");
}

int listlen(node_t *list){
    int counter=0;
    while (list->value != -1){
        counter++;
        list = list -> next;
    }
    return counter;
}

node_t *compute_next_iteration(node_t *list){
    // Initialize variables
    int previous_value = -1, counter = -1;
    node_t *head=NULL, *output_head, *output_list;
    output_list = malloc(sizeof(node_t));
    output_head = output_list;

    while (list->value != -1){
        counter++;
        if (previous_value != -1 && list->value != previous_value){
            output_list->value = counter;
            output_list->next = malloc(sizeof(node_t));
            output_list = output_list->next;
            output_list->value = previous_value;
            output_list->next = malloc(sizeof(node_t));
            output_list = output_list->next;
            counter=0;
        }
        previous_value = list->value;
        head=list;
        list=list->next;
        free(head);
    }
    free(list);
    counter++;
    output_list->value = counter;
    output_list->next = malloc(sizeof(node_t));
    output_list = output_list->next;
    output_list->value = previous_value;
    output_list->next = malloc(sizeof(node_t));
    output_list = output_list->next;
    output_list->value = -1;
    return output_head;
}

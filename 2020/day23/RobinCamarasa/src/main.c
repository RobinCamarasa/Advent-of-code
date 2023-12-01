#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>


// Cup structure
struct Cup{
    int value;
    struct Cup *next_cup;
    struct Cup *previous_number_cup;
};


// Initialize structure
void init(int size, struct Cup *head){
    int i;

    head->value = 1;
    struct Cup *previous_cup, *new_cup;

    // Allocate memory
    previous_cup = malloc(sizeof(struct Cup*));

    // // Start list
    previous_cup = head;

    // First cup
    for (i=2; i < size + 1; i++){
        new_cup = malloc(sizeof(struct Cup*));
        new_cup->value = i;
        new_cup->next_cup = NULL;
        new_cup->previous_number_cup = previous_cup;
        previous_cup->next_cup = new_cup;
        previous_cup = new_cup;
    }
    previous_cup->next_cup = head;

    // Initialize with values of the cups
    struct Cup *tmp_cup;
    FILE *file;
    char ch;
    int number, nb_unordered_elements = 0;
    file = fopen("/home/robin/gitlab/robin_camarasa_personal/fun/advent-of-code/2020/day23/RobinCamarasa/data/23.txt", "r");
    tmp_cup = malloc(sizeof(struct Cup*));
    tmp_cup = head;
    while ((ch = fgetc(file)) != EOF) {
        number=atoi(&ch);
        if (number != 0){
            tmp_cup->value = number;
            tmp_cup = tmp_cup->next_cup;
            nb_unordered_elements++;
        }
    }

    // Keep structure
    struct Cup *current_cup, *predecessor_cup; 
    int predecessor_value;
    current_cup = malloc(sizeof(struct Cup*));
    predecessor_cup = malloc(sizeof(struct Cup*));
    current_cup = head;
    predecessor_cup = head->next_cup;
    for (i=0; i<nb_unordered_elements + 1; i++){
        predecessor_value = current_cup->value - 1;
        if (predecessor_value == 0){
            predecessor_value = size;
        }
        while (predecessor_cup->value != predecessor_value){
            predecessor_cup = predecessor_cup->next_cup;
        }
        current_cup->previous_number_cup = predecessor_cup;
        current_cup = current_cup->next_cup;
        predecessor_cup = current_cup->next_cup;
    }

    // Free memory
    fclose(file);
}

struct Cup *do_move(struct Cup *head){
    // Get three cups
    struct Cup *first, *second, *third;
    first = malloc(sizeof(struct Cup*));
    first = head->next_cup;
    second = malloc(sizeof(struct Cup*));
    second = first->next_cup;
    third = malloc(sizeof(struct Cup*));
    third = second->next_cup;

    // Link head to fourth cup
    head->next_cup = third->next_cup;

    // Get the predecessor
    struct Cup *predecessor;
    predecessor = malloc(sizeof(struct Cup*));
    predecessor = head->previous_number_cup;
    while (predecessor->value == first->value || predecessor->value == second->value || predecessor->value == third->value){
         predecessor = predecessor->previous_number_cup;
    }

    // Move cups
    third->next_cup=predecessor->next_cup;
    predecessor->next_cup=first;

    return head->next_cup;
}


void vizualize_part_two(struct Cup *head){
    struct Cup *tmp_cup;
    tmp_cup = malloc(sizeof(struct Cup*));
    tmp_cup = head;
    while (tmp_cup->value != 1){
        tmp_cup = tmp_cup->next_cup;
    }
    tmp_cup = tmp_cup->next_cup;
    printf("The answer of part two is: %d * %d\n", tmp_cup->value, tmp_cup->next_cup->value);
}


struct Cup *do_multiple_moves(int nb_moves, struct Cup *head){
    for (int i=0; i<nb_moves; i++){
        head = do_move(head);
    }
    return head;
}


void vizualize_part_one(struct Cup *head){
    struct Cup *tmp_cup;
    tmp_cup = malloc(sizeof(struct Cup*));
    tmp_cup = head;
    printf("The answer of part one is: ");
    while (tmp_cup->value != 1){
        tmp_cup = tmp_cup->next_cup;
    }
    tmp_cup = tmp_cup->next_cup;
    while (tmp_cup->value != 1){
        printf("%d", tmp_cup->value);
        tmp_cup = tmp_cup->next_cup;
    }
    printf("\n");
}


int main(int argc, char *argv[]) {
    // Initialize variables common to each part
    int nb_moves, nb_elements;
    struct Cup *head;
    head = malloc(sizeof(struct Cup*));

    // Part one
    nb_moves = 100;
    nb_elements = 9;
    init(nb_elements, head);
    head = do_multiple_moves(nb_moves, head);
    vizualize_part_one(head);

    // Part two
    head = malloc(sizeof(struct Cup*));
    nb_moves = 10000000;
    nb_elements = 1000000;
    init(nb_elements, head);
    do_multiple_moves(nb_moves, head);
    vizualize_part_two(head);
    return 0;
}

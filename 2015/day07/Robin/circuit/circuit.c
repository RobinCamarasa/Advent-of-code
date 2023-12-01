#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "circuit.h"

// Utils
int hash(char *s){
    if (strlen(s) == 1)
        return s[0] - 'a' + 1;
    return (s[0] - 'a' + 1) * 27 + (s[1] - 'a' + 1);
}

int strcnt(char *s, char sep){
    int count=0;
    for (int i=0; i < strlen(s); i++) {
        if (s[i] == sep)
            count++;
    }
    return count;
}

// Task specific

//Initialize structure
current_t *init(){
    // Allocate memory
    current_t *currents;
    int max_value = hash("zz");
    currents = malloc((max_value + 1) * sizeof(current_t *));

    for (int i=0; i <= max_value; i++){
        currents[i].value = 0;
        currents[i].operation = -1;
        currents[i].left_val = 0;
        currents[i].right_val = 0;
        
        currents[i].left = malloc(sizeof(current_t *));
        currents[i].left = NULL;

        currents[i].right = malloc(sizeof(current_t *));
        currents[i].right = NULL;
    }
    return currents;
}

//Parse file
void parse_file(current_t *currents, char *path){
    char *line=NULL, *parser=NULL;
    size_t n;
    ssize_t n_read;
    FILE *file;
    int n_space;

    int hash_item, hash_left, hash_right;
    int left, right, operation;

    file = fopen(path, "r");
    while ((n_read = getline(&line, &n, file)) != -1){
        hash_left = -1;
        hash_right = -1;
        left=0; 
        right=0;
        n_space = strcnt(line, ' ');
        parser = strtok(line, "\n");
        parser = strtok(parser, " ");
        if (n_space == 2){
            if (parser[0] - 'a' < 0){
                // Parse
                left = atoi(parser);
                parser = strtok(NULL, " ");
                parser = strtok(NULL, " ");
                hash_item = hash(parser);

                // Store
                currents[hash_item].operation = -1;
                currents[hash_item].left_val = left;
            } else {
                // Parse
                hash_left = hash(parser);
                parser = strtok(NULL, " ");
                parser = strtok(NULL, " ");
                hash_item = hash(parser);

                // Store
                currents[hash_item].operation = 5;
                currents[hash_item].left = currents + hash_left;
            }
        } else if (n_space == 3) {
            // Parse
            parser = strtok(NULL, " ");
            hash_left = hash(parser);
            parser = strtok(NULL, " ");
            parser = strtok(NULL, " ");
            hash_item = hash(parser);

            // Store
            currents[hash_item].operation = 4;
            currents[hash_item].left = currents + hash_left;
        } else if (n_space == 4){
            // Parse
            if (parser[0] - 'a' < 0){
                left = atoi(parser);
            } else {
                hash_left = hash(parser);
            }
            parser = strtok(NULL, " ");
            switch(parser[0]){
                case 'L':
                    operation = 0;
                    break;
                case 'R':
                    operation = 1;
                    break;
                case 'A':
                    operation = 2;
                    break;
                case 'O':
                    operation = 3;
                    break;
            }
            parser = strtok(NULL, " ");
            if (parser[0] - 'a' < 0){
                right = atoi(parser);
            } else {
                hash_right = hash(parser);
            }
            parser = strtok(NULL, " ");
            parser = strtok(NULL, " ");
            hash_item = hash(parser);

            // Store
            if (hash_left != -1){
                currents[hash_item].left = currents + hash_left;
            } else {
                currents[hash_item].left_val = left;
            }
            if (hash_right != -1){
                currents[hash_item].right = currents + hash_right;
            } else {
                currents[hash_item].right_val = right;
            }
            currents[hash_item].operation = operation;
        }
    }
    fclose(file);
}

unsigned short int get_final_value(current_t *current){
    if (current->operation == -1){
        return current->left_val;
    }
    unsigned short int left, right;
    if (current->left_val != 0){
        left = current->left_val;
    } else {
        left = get_final_value(current->left);
    }
    if (current->operation < 4){
            if (current->right_val != 0){
                right = current->right_val;
            } else {
                right = get_final_value(current->right);
            }
    }
    switch (current->operation){
        case 0:
            current->left_val = left << right;
            break;
        case 1:
            current->left_val = left >> right;
            break;
        case 2:
            current->left_val = left & right;
            break;
        case 3:
            current->left_val = left | right;
            break;
        case 4:
            current->left_val = ~left;
            break;
        case 5:
            current->left_val = left;
            break;
    }
    current->operation = -1;
    return current->left_val;
}

void display(current_t *current){
    printf("LOCATION: %p\n", current);
    switch (current->operation){
        case -1:
            printf("Operation: NONE\n");
            break;
        case 0:
            printf("Operation: LSHIFT\n");
            break;
        case 1:
            printf("Operation: RSHIFT\n");
            break;
        case 2:
            printf("Operation: AND\n");
            break;
        case 3:
            printf("Operation: OR\n");
            break;
        case 4:
            printf("Operation: NOT\n");
            break;
        case 5:
            printf("Operation: COPY\n");
            break;
    }
    if (current->operation == -1){
        printf("LEFT: %u\n", current->left_val);
    } else {
        if (current->left_val == 0){
            printf("LEFT: %p\n", current->left);
        } else {
            printf("LEFT: %u\n", current->left_val);
        }
        if (current->operation < 4){
            if (current->right_val == 0){
                printf("RIGHT: %p\n", current->right);
            } else {
                printf("RIGHT: %u\n", current->right_val);
            }
        } 
    }
    printf("\n");
}


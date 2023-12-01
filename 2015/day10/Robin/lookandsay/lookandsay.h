#include <stdio.h>

typedef struct Node{
    int value;
    struct Node *next ;
} node_t;

void init(node_t *list, char *string);
void print(node_t *list);
int listlen(node_t *list);
node_t *compute_next_iteration(node_t *list);

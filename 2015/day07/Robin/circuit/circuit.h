#include <stdio.h>

// Instructions
typedef struct Current{
    unsigned short int value;

    // 0: left shift, 1: right shift, 2: and, 3: or,
    // 4: not, 5: copy
    int operation;

    struct Current *left;
    unsigned short int left_val;

    struct Current *right;
    unsigned short int right_val;
} current_t;

// Utils
int hash(char *s);
int strcnt(char *s, char sep);

// Task specific
current_t *init();
void parse_file(current_t *currents, char *path);
unsigned short int get_final_value(current_t *current);
void display(current_t *current);

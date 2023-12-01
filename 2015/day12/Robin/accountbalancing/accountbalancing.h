#include <stdio.h>


typedef struct JSONobject{
    int key;
    struct JSONobject *child;
    struct JSONobject *next;

    int value_integer;
    char value_string[50];
} json_object_t;

int get_sum(char *path);
int get_sum_without_red(json_object_t *head);

FILE *parse_array(FILE *file, json_object_t *head);
FILE *parse_object(FILE *file, json_object_t *head);
json_object_t *parse_file(char *path);
void free_struct(json_object_t *head);

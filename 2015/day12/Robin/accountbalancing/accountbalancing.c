#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "accountbalancing.h"


int get_sum(char *path){
    char ch;
    FILE *file;
    int sign=0, sum=0, current_value=0;

    file = fopen(path, "r");
    while ((ch = getc(file)) != EOF){
        if (ch == '-'){
            sign = -1;
        } else if (ch - '0' <= 9 && ch - '0' >= 0){
            if (sign == 0){
                sign = 1;
            }
            current_value = 10 * current_value + (ch - '0');
        } else if (sign != 0){
            sum += sign * current_value;
            sign = 0;
            current_value = 0;
        }
    }
    fclose(file);
    return sum;
}


FILE *parse_object(FILE *file, json_object_t *head){
    char ch;
    json_object_t *working;
    int isvalue=0, sign=0;

    // Keep the head as a seperate point
    working = head;
    head->key=1;
    head->value_integer=0;
    while ((ch = getc(file)) != EOF){
        if (ch == '}'){
            // Finish the loop if encounter a closing curly bracket
            working->value_integer *= sign;
            working->next=NULL;
            working->child=NULL;
            break;
        } else if (ch == '{'){
            // Recursion on parse_object if encounter an opening curly bracket
            working->child = malloc(sizeof(json_object_t));
            working->child->value_integer = 0;
            file = parse_object(file, working->child);
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 1;
            working = working->next;
        } else if (ch == '['){
            // Recursion on parse_array if encounter an opening bracket
            working->child = malloc(sizeof(json_object_t));
            working->child->value_integer = 0;
            working->child->key = 1;
            file = parse_array(file, working->child);
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 1;
            working = working->next;
        } else if (ch == ',') {
            // Go to next element of the json_object_t
            isvalue--;
            working->value_integer *= sign;
            sign = 0;
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 1;
            working = working->next;
        } else if (ch == ':'){
            // Go to value
            isvalue++;
        } else if (ch == '-'){
            sign = -1;
        } else if (isvalue && ch - 'a' <= 25 && ch - 'a' >= 0){
            // Add the character
            strncat(working->value_string, &ch, 1);
        } else if (ch - '0' <= 9 && ch - '0' >= 0){
            if (sign == 0)
                sign = 1;
            working->value_integer = 10 * working->value_integer + ch - '0';
        }
    }
    return file;
}


FILE *parse_array(FILE *file, json_object_t *head){
    char ch;
    json_object_t *working;
    int sign=0;

    // Keep the head as a seperate point
    working = head;
    head->key=0;
    head->value_integer=0;
    while ((ch = getc(file)) != EOF){
        if (ch == ']'){
            // Finish the loop if encounter a closing curly bracket
            working->value_integer *= sign;
            working->next=NULL;
            working->child=NULL;
            break;
        } else if (ch == '{'){
            // Recursion on parse_object if encounter an opening curly bracket
            working->child = malloc(sizeof(json_object_t));
            working->child->value_integer = 0;
            file = parse_object(file, working->child);
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 0;
            working = working->next;
        } else if (ch == '['){
            // Recursion on parse_array if encounter an opening bracket
            working->child = malloc(sizeof(json_object_t));
            working->child->value_integer = 0;
            working->child->key = 0;
            file = parse_array(file, working->child);
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 0;
            working = working->next;
        } else if (ch == ',') {
            // Go to next element of the json_object_t
            working->value_integer *= sign;
            sign = 0;
            working->next = malloc(sizeof(json_object_t));
            working->next->value_integer = 0;
            working->next->key = 0;
            working = working->next;
        } else if (ch == '-'){
            sign = -1;
        } else if (ch - 'a' <= 25 && ch - 'a' >= 0){
            // Add the character
            strncat(working->value_string, &ch, 1);
        } else if (ch - '0' <= 9 && ch - '0' >= 0){
            if (sign == 0)
                sign = 1;
            working->value_integer = 10 * working->value_integer + ch - '0';
        }
    }
    return file;
}

json_object_t *parse_file(char *path){
    char ch;
    json_object_t *head;
    FILE *file;

    file = fopen(path, "r");
    head = malloc(sizeof(json_object_t));
    ch = getc(file);
    if(ch == '{')
        parse_object(file, head);
    if(ch == '[')
        parse_array(file, head);
    return head;
}


int get_sum_without_red(json_object_t *head){
    int sum = 0, array_or_not_contain_red = 1;
    while (1){
        sum += head->value_integer;
        if (head->child != NULL)
            sum += get_sum_without_red(head->child);
        if (
                strlen(head->value_string) == 3 && 
                head->value_string[0] == 'r' &&
                head->value_string[1] == 'e' &&
                head->value_string[2] == 'd'
                )
            array_or_not_contain_red = (1 - head->key);
        if (head->next == NULL){
            break;
        } else {
            head = head->next;
        }
    }
    return sum * array_or_not_contain_red;
}


void free_struct(json_object_t *head){
    if (head->child != NULL)
        free_struct(head->child);
    if (head->next != NULL)
        free_struct(head->next);
    free(head);
}

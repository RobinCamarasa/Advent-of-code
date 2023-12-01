#include <stdio.h>
#include <stdlib.h>
#include "housegrid.h"


ssize_t get_grid_size(char *path){
    ssize_t file_size=0;

    char ch;
    FILE *stream;

    stream = fopen(path, "r");

    while((ch = getc(stream)) != EOF){
        file_size++;
    }
    return file_size;
}


void parse_input(char *path, Position *positions){
    // Get file size
    ssize_t file_size=0, line_size;
    char ch;
    FILE *stream;

    stream = fopen(path, "r");

    // Declare structure
    int counter = 1, x = 0, y = 0;

    positions->x = x; 
    positions->y = y; 
    
    rewind(stream);

    while((ch = getc(stream)) != EOF){
        if (ch == '>'){
            x += 1;
        } else if (ch == '<'){
            x -= 1;
        } else if (ch == 'v'){
            y -= 1;
        } else if (ch == '^'){
            y += 1;
        }
        (positions + counter)->x = x;
        (positions + counter)->y = y;
        counter++;
    }
}


void parse_input_with_robot(char *path, Position *positions_santa, Position *positions_robot, int path_size[]){
    // Get file size
    ssize_t file_size=0, line_size;
    char ch;
    FILE *stream;

    stream = fopen(path, "r");

    // Declare structure
    int counter = 1, x[2], y[2];
    x[0] = 0;
    x[1] = 0;
    y[0] = 0;
    y[1] = 0;

    positions_robot->x = x[1]; 
    positions_robot->y = y[1]; 

    positions_santa->x = x[0]; 
    positions_santa->y = y[0]; 


    while((ch = getc(stream)) != EOF){
        if (ch == '>'){
            x[counter % 2] += 1;
        } else if (ch == '<'){
            x[counter % 2] -= 1;
        } else if (ch == 'v'){
            y[counter % 2] -= 1;
        } else if (ch == '^'){
            y[counter % 2] += 1;
        }
        if (counter % 2 == 0) {
            (positions_santa + counter/2)->x = x[0];
            (positions_santa + counter/2)->y = y[0];
            path_size[0] = counter/2 + 1;
        } else {
            (positions_robot + counter/2)->x = x[1];
            (positions_robot + counter/2)->y = y[1];
            path_size[1] = counter/2 + 1;
        }
        counter++;
    }
}


int get_number_visited_houses_with_robot(Position *positions_robot, Position *positions_santa, int path_size[]){
    int number_of_visited_houses=0;

    for (int i=0; i < path_size[0]; i++){
        int new_house=1;
        for (int j=0; j < i; j++){
            if (
                    (positions_santa + i)->x == (positions_santa + j)->x &&
                    (positions_santa + i)->y == (positions_santa + j)->y
               ){
                new_house = 0;
            }
        }
        number_of_visited_houses += new_house;
    }

    for (int i=0; i < path_size[0]; i++){
        int new_house=1;
        for (int j=0; j < i; j++){
            if (
                    (positions_robot + i)->x == (positions_robot + j)->x &&
                    (positions_robot + i)->y == (positions_robot + j)->y
               ){
                new_house = 0;
            }
        }
        for (int j=0; j < path_size[0]; j++){
            if (
                    (positions_robot + i)->x == (positions_santa + j)->x &&
                    (positions_robot + i)->y == (positions_santa + j)->y
               ){
                new_house = 0;
            }
        }
        number_of_visited_houses += new_house;
    }
    return number_of_visited_houses;
}


int get_number_visited_houses(Position *positions, ssize_t size){
    int number_of_visited_houses=0;
    for (int i=0; i < size; i++){
        int new_house=1;
        for (int j=0; j < i; j++){
            if (
                    (positions + i)->x == (positions + j)->x &&
                    (positions + i)->y == (positions + j)->y
               ){
                new_house = 0;
            }
        }
        number_of_visited_houses += new_house;
    }
    return number_of_visited_houses;
}


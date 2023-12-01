#include <stdio.h>

typedef struct Deer{
    int speed;
    int time;
    int rest_time;
    struct Deer *next;
} deer_t;

typedef struct Position{
    int time;
    int distance;
    struct Position *next;
} position_t;

void parse(deer_t *deers, char *path);
int get_max_distance(deer_t *deers, int end_time);
int get_max_points(deer_t *deers, int end_time);
void free_deers(deer_t *deers);

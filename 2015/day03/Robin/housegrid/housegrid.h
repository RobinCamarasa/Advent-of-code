#include <stdio.h>


struct Position{ int x; int y; };
typedef struct Position Position;
ssize_t get_grid_size(char *path);

void parse_input(char *path, Position *positions);
void parse_input_with_robot(char *path, Position *positions_santa, Position *positions_robot, int path_size[]);

int get_number_visited_houses(Position *positions, ssize_t size);
int get_number_visited_houses_with_robot(Position *positions_robot, Position *positions_santa, int path_size[]);

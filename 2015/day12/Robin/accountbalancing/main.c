#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "accountbalancing.h"


int main(int argc, char *argv[]) {
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day12/Robin/accountbalancing/input.txt";
    printf("The sum of the values is %d.\n", get_sum(path));

    json_object_t *parsed_json;
    parsed_json = malloc(sizeof(parsed_json));

    parsed_json = parse_file(path);
    printf("The sum of the values without red is %d.\n", get_sum_without_red(parsed_json));
    free_struct(parsed_json);
    return 0;
}

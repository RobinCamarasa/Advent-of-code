#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "floor.h"


void usage(){
    /* Print usage
     * */
    fprintf(stderr, "Usage: out [h] n\n\n");
    fputs(
        "[-h] Manual\n" 
        , stderr
    );
    exit(1);
}


int main(int argc, char *argv[]) {
    int opt; 
    while ((opt = getopt(argc, argv, "h")) != -1) {
        switch (opt) {
            case 'h':
                usage(); break;
            case '?':
                usage(); break;
            default:
                usage(); break;
        }
    }
    char *path = "/home/tuchekaki/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day01/Robin/floor/input.txt";
    printf("Solution part 1: %d\n", get_floor(path));
    printf("Solution part 2: %d\n", get_first_basement(path));
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "wrapping.h"


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
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day02/Robin/wrapping/input.txt";
    total_surface(path);
    return 0;
}

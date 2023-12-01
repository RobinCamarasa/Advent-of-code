#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "adventcoins.h"
#include <string.h>
#include <openssl/md5.h>


int main(int argc, char *argv[]) {
    int i=0;
    unsigned char input_string[] = "bgvyzdsv";
    i = get_minimal_number(input_string, 5);
    printf("First number with 5 zeros: %d\n", i);

    i = get_minimal_number(input_string, 6);
    printf("First number with 6 zeros: %d\n", i);
    return 0;
}

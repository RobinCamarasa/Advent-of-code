#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "password.h"


int main(int argc, char *argv[]) {
    char password[8]="vzbxkghb";
    size_t string_length = strlen(password);
    update_password(password, string_length);
    printf("First password: %s\n", password);
    update_password(password, string_length);
    printf("Second password: %s\n", password);
    return 0;
}

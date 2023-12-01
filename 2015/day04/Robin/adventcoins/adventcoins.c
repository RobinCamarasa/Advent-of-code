#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/md5.h>


void generate_string(unsigned char output[], unsigned char input_string[], int number){
    sprintf(output, "%s%d", input_string, number);
}

ssize_t get_power(int number){
    char output[50];
    sprintf(output, "%d", number);
    return strlen(output);
}


int get_minimal_number(unsigned char input_string[], int number_zeros){
    int i = 0;
    int j = 0;
    int max_second_output = 16;
    unsigned char *output, md_output[MD5_DIGEST_LENGTH];

    md_output[0]='1';
    md_output[1]='1';
    md_output[2]='1';
    md_output[3]='1';
    md_output[4]='1';
    if (number_zeros == 6)
        max_second_output = 0;

    while (md_output[0] > 0 || md_output[1] > 0 || md_output[2] > max_second_output){
        output = malloc(strlen(input_string) + get_power(i) * sizeof(char));
        generate_string(output, input_string, i);
        MD5(output, strlen(output), md_output);
        i++;
        free(output);
    }

    // printf("Number %d: ", i-1);
    // for(j = 0; j < MD5_DIGEST_LENGTH; j++){ 
    //     printf("%02x", md_output[j]);
    // }
    return i-1;
}


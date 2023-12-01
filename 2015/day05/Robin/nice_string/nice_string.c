#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int analyse_new_rule(char *input_string){
    char c=-1,previous_c=-1;
    int double_pairs=0, double_single=0;
    for (int i=0; i < strlen(input_string) - 4; i++){
        for (int j=i+2; j < strlen(input_string) - 2; j++){
            if (input_string[i] == input_string[j] && input_string[i+1] == input_string[j+1]){
                double_pairs = 1;
            }
        }
    }
    for (int i=0; i < strlen(input_string) - 3; i++){
        if (input_string[i] == input_string[i+2]){
            double_single = 1;
        }
    }
    return double_pairs * double_single;
}

int analyse_old_rule(char *input_string){
    char c=-1,previous_c=-1;
    int vowel_count=0, double_letter_count=0;
    for (int i=0; i < strlen(input_string) - 1; i++){
        previous_c = c;
        c = input_string[i];
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'){
            vowel_count++;
        }
        if (c == previous_c){
            double_letter_count++;
        }
        if ((previous_c == 'a' && c == 'b') || (previous_c == 'c' && c == 'd') || (previous_c == 'p' && c == 'q') || (previous_c == 'x' && c == 'y')){
            return 0;
        }
    }
    if (vowel_count < 3 || double_letter_count == 0){
        return 0;
    }
    return 1;
}

int analyse_file(char *path, int new_rule){
    // Read file line by line
    FILE *stream;
    ssize_t len=0, n_read;
    char *line=NULL;
    int n_nice_line = 0;

    stream = fopen(path, "r");
    
    while ((n_read = getline(&line, &len, stream)) != EOF){
        if (new_rule == 1){
            n_nice_line += analyse_new_rule(line);
        } else {
            n_nice_line += analyse_old_rule(line);

        }
    }
    fclose(stream);
    return n_nice_line;
}



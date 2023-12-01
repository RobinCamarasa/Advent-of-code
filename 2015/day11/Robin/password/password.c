#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void increment(char *string, size_t string_length){
    for (int i=string_length - 1; i>=0; i--){
        if (string[i] != 'z'){
            string[i]++;
            break;
        } else {
            string[i] = 'a';
        }
    }
}


void update_password(char *string, size_t string_length){
    int contains_letter, contains_sequence;
    char double_one, double_two, previous_character, previous_two_character;

    while (1){
        increment(string, string_length);

        // Initialize test password values
        contains_letter=0;
        contains_sequence=0;
        double_one='0';
        double_two='0';
        previous_character='1';
        previous_two_character='0';

        // Loop over the string
        for (int i=0; i<string_length; i++){
            // Check sequence
            if (previous_two_character + 2 == previous_character + 1 && previous_character + 1 == string[i])
                contains_sequence = 1;

            // Check if contain letter
            if (string[i] == 'i' || string[i] == 'o' || string[i] == 'l')
                contains_letter = 1;

            // Check doubles
            if (previous_character == string[i] && double_one == '0'){
                double_one = previous_character;
            } else if(previous_character == string[i] && double_one != previous_character){
                double_two = previous_character;
            }

            // Update previous characters
            previous_two_character = previous_character;
            previous_character = string[i];

        }
        if ((1 - contains_letter) && (contains_sequence) && (double_two != '0')){
            break;
        }
    }
}


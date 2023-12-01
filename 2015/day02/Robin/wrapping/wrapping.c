#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct Present {
    int l;
    int h;
    int w;
};


struct Present *init_present(char *line, size_t len){
    // Create present
    struct Present *present;
    present = malloc(3 * sizeof(int));

    // Get indices in the string that contains 'x' caracter
    int x_1=0, x_2=0;
    for (int i = 0; i < len; i++){
        if (x_1==0 && *(line + i) == 'x'){
            x_1 = i;
        } else if (*(line + i) == 'x') {
            x_2 = i;
        }
    } 

    // Transform the line into h, l and w values
    char *h_str, *l_str, *w_str;

    l_str = malloc(x_1 * sizeof(char));
    strncpy(l_str, line, x_1);

    w_str = malloc((x_2 - x_1 - 1) * sizeof(char));
    strncpy(w_str, line + x_1 + 1, x_2 - x_1 - 1);

    h_str = malloc((len - x_2 - 1) * sizeof(char));
    strncpy(h_str, line + x_2 + 1, len - x_2 - 1);

    // Transform h, l, w values into 
    present->l = atoi(l_str);
    present->w=atoi(w_str);
    present->h = atoi(h_str);

    // Free tamporary variables
    free(l_str);
    free(w_str);
    free(h_str);
    return present;
}


int get_ribbon_amount(struct Present* present){
    int area_1, area_2, area_3, area_4;
    if (present->h >= present->l && present->h >= present->w) {
        return 2 * (present->l + present->w) + present->w * present->h * present->l;
    } else if (present->l >= present->h && present->l >= present->w) {
        return 2 * (present->h + present->w) + present->w * present->h * present->l;
    } else {
        return 2 * (present->l + present->h) + present->w * present->h * present->l;
    }
}


int get_wrapping_paper_amount(struct Present* present){
    int area_1, area_2, area_3, area_4;
    area_1 = present->h * present->l;
    area_2 = present->l * present->w;
    area_3 = present->w * present->h;
    if (present->h >= present->l && present->h >= present->w) {
        return 2 * area_1 + 3 * area_2 + 2 * area_3;
    } else if (present->l >= present->h && present->l >= present->w) {
        return 2 * area_1 + 2 * area_2 + 3 * area_3;
    } else {
        return 3 * area_1 + 2 * area_2 + 2 * area_3;
    }
}


int total_surface(char *path){
    FILE *stream;
    char *line;
    size_t len, reading_status, number_of_line;
    struct Present **presents;

    // Parse file
    stream = fopen(path, "r");

    // Get the number of lines
    number_of_line = 0;
    while((reading_status = getline(&line, &len, stream)) != -1){
        number_of_line++;
    }

    // Parse file as presents
    int i=0;
    stream = fopen(path, "r");
    presents = malloc(number_of_line * sizeof(struct Present*));
    while((reading_status = getline(&line, &len, stream)) != -1){
        presents[i] = init_present(line, len);
        i++;
    }

    // Get the amount of wrapping paper
    int wrapping_paper_amount = 0;
    for (i = 0; i < number_of_line; i++){
        wrapping_paper_amount += get_wrapping_paper_amount(*(presents + i));
    }
    printf("\nWrapping paper amount: %d\n", wrapping_paper_amount);

    // Get the amount of ribbon
    int ribbon_amount = 0;
    for (i = 0; i < number_of_line; i++){
        ribbon_amount += get_ribbon_amount(*(presents + i));
    }
    printf("\nRibbon amount: %d\n", ribbon_amount);
    free(presents);
    return 0;
}

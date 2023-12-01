#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cookie_recipe.h"


void init(ingredient_t *ingredients, char *path){
    FILE *file;
    char *line=NULL, *token=NULL;
    size_t n;
    ssize_t n_read;
    int i=0;

    file = fopen(path, "r");
    while ((n_read = getline(&line, &n, file)) != -1){
        token = strtok(line, "\n");
        token = strtok(token, " ");
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        ingredients[i].capacity = atoi(token);
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        ingredients[i].durability = atoi(token);
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        ingredients[i].flavor = atoi(token);
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        ingredients[i].texture = atoi(token);
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        ingredients[i].calories = atoi(token);
        i++;
    }
}

int compute_best_cookie(ingredient_t *ingredients, int number_teaspoon, int calorie_rule){
    int total_score=-1, feature_score=0, score=1; 
    for (int i=0; i<number_teaspoon; i++){
        for (int j=0; j<number_teaspoon-i; j++){
            for (int k=0; k<number_teaspoon-j-i; k++){
                feature_score += i * ingredients[0].capacity;
                feature_score += j * ingredients[1].capacity;
                feature_score += k * ingredients[2].capacity;
                feature_score += (number_teaspoon - i - j - k)* ingredients[3].capacity;
                if (feature_score > 0){
                    score *= feature_score;
                } else {
                    score = 0;
                }
                feature_score = 0;

                feature_score += i * ingredients[0].durability;
                feature_score += j * ingredients[1].durability;
                feature_score += k * ingredients[2].durability;
                feature_score += (number_teaspoon - i - j - k)* ingredients[3].durability;
                if (feature_score > 0){
                    score *= feature_score;
                } else {
                    score = 0;
                }
                feature_score = 0;

                feature_score += i * ingredients[0].flavor;
                feature_score += j * ingredients[1].flavor;
                feature_score += k * ingredients[2].flavor;
                feature_score += (number_teaspoon - i - j - k)* ingredients[3].flavor;
                if (feature_score > 0){
                    score *= feature_score;
                } else {
                    score = 0;
                }
                feature_score = 0;

                feature_score += i * ingredients[0].texture;
                feature_score += j * ingredients[1].texture;
                feature_score += k * ingredients[2].texture;
                feature_score += (number_teaspoon - i - j - k)* ingredients[3].texture;
                if (feature_score > 0){
                    score *= feature_score;
                } else {
                    score = 0;
                }

                feature_score = 0;

                feature_score += i * ingredients[0].calories;
                feature_score += j * ingredients[1].calories;
                feature_score += k * ingredients[2].calories;
                feature_score += (number_teaspoon - i - j - k)* ingredients[3].calories;
                if (calorie_rule && feature_score != 500){
                    score = 0;
                }
                if (score > total_score){
                    total_score = score;
                }
                score = 1;
                feature_score = 0;
            }
        }
    }
    return total_score;
}

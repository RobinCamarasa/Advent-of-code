#include <stdio.h>


typedef struct Ingredient{
    int capacity;
    int durability;
    int flavor;
    int texture;
    int calories;
} ingredient_t;


void init(ingredient_t *ingredients, char *path);

int compute_best_cookie(ingredient_t *ingredients, int number_teaspoon, int calorie_rule);

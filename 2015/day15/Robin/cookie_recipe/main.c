#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "cookie_recipe.h"


int main(int argc, char *argv[]) {
    // Part one
    int score;
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day15/Robin/cookie_recipe/input.txt";
    ingredient_t *ingredients=NULL;

    ingredients = malloc(4 * sizeof(ingredient_t));
    init(ingredients, path);
    score = compute_best_cookie(ingredients, 100, 0);
    printf("The score is %d\n", score);

    // Part two
    score = compute_best_cookie(ingredients, 100, 1);
    printf("The score is %d\n", score);
    free(ingredients);
    return 0;
}

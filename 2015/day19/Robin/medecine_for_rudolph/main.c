#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "medecine_for_rudolph.h"


int main(int argc, char *argv[]) {
    char *path="/home/rcamarasa/documents/gitlab/robin-camarasa-personal/fun/advent-of-code/2015/day19/Robin/medecine_for_rudolph/input.txt";
    transformation_t *transformations;
    molecule_t *molecule;

    init(path, &transformations, &molecule);

    list_molecule_t *generation;
    generation = malloc(sizeof(list_molecule_t));
    generation->molecule = molecule;

    generation = update_generation(transformations, generation);
    return 0;
}

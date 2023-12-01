#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "medecine_for_rudolph.h"

int get_hash(char *atom_string){
    int hash=atom_string[0] - 'A' + 1;
    for (int i=1; i<strlen(atom_string); i++)
        hash = 26 * hash + (atom_string[i] - 'a' + 1);
    return hash;
}

void set_molecule(char *molecule_string, molecule_t **molecule){
    molecule_t *current_atom;
    *molecule = malloc(sizeof(molecule_t));
    current_atom = *molecule;
    for (int i=0; i<strlen(molecule_string); i++){
        if (molecule_string[i]- 'a' < 0){
            if (i>0){
                current_atom->next = malloc(sizeof(molecule_t));
                current_atom = current_atom->next;
            }
            current_atom->atom_hash = molecule_string[i] - 'A' + 1;
        } else if (molecule_string[i] - 'a' >= 0){
            current_atom->atom_hash = 26 * current_atom->atom_hash + (molecule_string[i] - 'a' + 1);
        }
    }
}

void print_molecule(molecule_t *molecule){
    molecule_t *current_atom;
    current_atom = molecule;
    while (current_atom != NULL){
        printf("%d ", current_atom->atom_hash);
        current_atom = current_atom->next;
    }
}

int init(char *path, transformation_t **transformations, molecule_t **initial_molecule){
    FILE *file;
    char *line, *token=NULL;
    size_t n;
    ssize_t n_read;
    int n_transformations=0, i=0;

    file = fopen(path, "r");
    while ((n_read = getline(&line, &n, file)) != -1){
        if (strlen(line) == 1)
            break;
        n_transformations++;
    }
    rewind(file);
    *transformations = malloc(n_transformations * sizeof(transformation_t));
    for (int i=0; i<n_transformations; i++){
        (*transformations)[i].out = NULL;
        (*transformations)[i].in_atom_hash = 0;
    }
    while ((n_read = getline(&line, &n, file)) != -1){
        if (strlen(line) == 1)
            break;
        token = strtok(line, "\n");
        token = strtok(token, " ");
        (*transformations)[i].in_atom_hash = get_hash(token);
        token = strtok(NULL, " ");
        token = strtok(NULL, " ");
        set_molecule(token, &((*transformations)[i].out));
        //printf("atom: %d", (*transformations)[i].in_atom_hash);
        //printf("\t\tmolecule:");
        //print_molecule((*transformations)[i].out);
        //printf("\n");
        i++;
    }

    n_read = getline(&line, &n, file);
    token = strtok(line, "\n");
    *initial_molecule = malloc(sizeof(molecule_t));
    set_molecule(token, initial_molecule);
    //printf("molecule:");
    //print_molecule(*initial_molecule);
    fclose(file);
    return n;
}


void copy_molecule(molecule_t *output_molecule, molecule_t *input_molecule){
    output_molecule->atom_hash = input_molecule->atom_hash;
    while (input_molecule->next != NULL){
        input_molecule = input_molecule->next;
        output_molecule->next = malloc(sizeof(molecule_t));
        output_molecule = output_molecule->next;
        output_molecule->atom_hash = input_molecule->atom_hash;
    }
}

int compare_molecule(molecule_t* molecule_1, molecule_t* molecule_2){
    while (molecule_1->next != NULL && molecule_2->next != NULL){
        printf("%d\t %d\n", molecule_1->atom_hash, molecule_2->atom_hash);
        if (molecule_1->atom_hash != molecule_2->atom_hash){
            return 1;
        }
        molecule_1 = molecule_1->next;
        molecule_2 = molecule_2->next;
    }
    return (molecule_1->next == NULL && molecule_2 == NULL);
}

list_molecule_t *update_generation(transformation_t *transformations, list_molecule_t *generation){
    list_molecule_t *new_generation;
    new_generation = malloc(sizeof(list_molecule_t));
    return new_generation;
}


#include <stdio.h>

typedef struct Molecule{
    int atom_hash;
    struct Molecule *next;
} molecule_t;

typedef struct Transformation{
    int in_atom_hash;
    struct Molecule *out;
} transformation_t;

typedef struct ListMolecule{
    struct Molecule *molecule;
    struct ListMolecule *next_molecule;
} list_molecule_t;


int init(char *path, transformation_t **transformations, molecule_t **initial_molecule);
void print_molecule(molecule_t *molecule);
void copy_molecule(molecule_t *output_molecule, molecule_t *input_molecule);
int compare_molecule(molecule_t* output_molecule, molecule_t* input_molecule);
list_molecule_t *update_generation(transformation_t *transformations, list_molecule_t *generation);

#include <stdio.h>

int total_surface(char *path);

struct Present *init_present(char *line, size_t len);
int get_wrapping_paper_amount(struct Present* present);
int get_ribbon_amount(struct Present* present);

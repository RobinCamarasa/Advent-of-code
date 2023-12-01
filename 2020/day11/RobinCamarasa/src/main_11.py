"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-11

**Project** : advent code

**Code corresponding to day 11**

"""
import numpy as np
from joblib import Parallel, delayed
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load():
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '11.txt').open('r') as handle:
        lines = handle.readlines()
        output = []
        for line in lines:
            tmp = []
            line = line[:-1]
            line = line.replace('.', '0')
            line = line.replace('L', '1')
            for c in line:
                tmp.append(int(float(c)))
            output.append(np.array(tmp))
    return np.array(output)


def get_adjacent(
        data: np.array, i: int, j:
        int, part: int
        ) -> np.array:
    """
    Get the adjacent seats

    :param data: Numpy array representing the boat seats
    (0: floor, 1: free, 2: occupied)
    :param i: Row index
    :param j: Column index
    :param part: Part of the advent of code problem
    :return: Numpy array containing the neighbors and the seats
    """
    if part == 1:
        i_min, i_max = max(i-1, 0), min(i+2, data.shape[0])
        j_min, j_max = max(j-1, 0), min(j+2, data.shape[1])
        return data[i_min:i_max, j_min:j_max]

    directions = [
            (1, 0), (0, 1), (-1, 0), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1),
            ]

    def get_neighbors(direction: tuple) -> int:
        """
        Get the neighbors in a given direction

        :param direction: Direction where to find the neighbor
        :return: The value of the neighbor (0:floor, 1: free, 2: occupied)
        """
        neighbors_i, neighbors_j = i+direction[0], j+direction[1]
        while neighbors_i in range(data.shape[0]) and\
            neighbors_j in range(data.shape[1]) and\
            data[neighbors_i, neighbors_j] == 0:
            if data[neighbors_i, neighbors_j] == 0:
                neighbors_i, neighbors_j = neighbors_i+direction[0], neighbors_j+direction[1]

        if (neighbors_i in range(data.shape[0])) and (neighbors_j in range(data.shape[1])):
            return data[neighbors_i, neighbors_j]
        else:
            return 0

    # Get the adjacent neighbors
    adjacent = Parallel(n_jobs=1)(
            delayed(get_neighbors)(direction)
            for direction in directions
            )
    return np.array(adjacent+[data[i, j]])


def apply_round(data, part=1):
    """
    Apply a round of social rules on the data

    :param data: Numpy array representing the boat seats
    (0: floor, 1: free, 2: occupied)
    :param part: Part of the advent of code problem
    :return: The updated data
    """
    output = np.copy(data)
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            if data[i, j] != 0:
                # Get the neighbors
                adjacent = get_adjacent(data, i, j, part)
                # Apply the rules
                if data[i, j] == 1 and (adjacent == 2).sum() == 0:
                    output[i, j]=2
                elif data[i, j] == 2 and (adjacent == 2).sum() >= 4 + part:
                    output[i, j]=1
    return output


def get_final_grid(data: np.array, part: int) -> np.array:
    """
    Get the final grid

    :param data: Numpy array representing the boat seats
    :param part: Part of the advent of code problem
    :return: The final data
    """
    round_i1 = data
    round_i2 = apply_round(round_i1, part)
    while (round_i1 - round_i2).sum()**2 > .0001:
        round_i1, round_i2 = round_i2, apply_round(round_i2, part)
    return round_i2


if __name__ == '__main__':
    # Part one
    number_of_free_seats = (get_final_grid(load(), 1) == 2).sum()
    print(
            'Number of occupied seats for part one: {}'.format(
                number_of_free_seats
                )
            )

    # Part two
    number_of_free_seats = (get_final_grid(load(), 2) == 2).sum()
    print(
            'Number of occupied seats for part one: {}'.format(
                number_of_free_seats
                )
            )


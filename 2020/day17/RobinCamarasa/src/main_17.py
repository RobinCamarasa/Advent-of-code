"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-17

**Project** : advent code

**Code corresponding to day 17**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load(padding: int) -> np.array:
    """
    Load data

    :param padding: Padding value around the initial grid
    :return: Loaded data
    """
    with (DATAPATH / '17.txt').open('r') as handle:
        subcube = []
        for line in handle.readlines():
            subcube.append(
                    np.array(
                        [
                            1 if item == '#' else 0
                            for item in line[:-1]]
                        )
                    )
        subcube = np.array(subcube)
    cube = np.zeros(
            (
                subcube.shape[0] + 2 * padding,
                subcube.shape[1] + 2 * padding,
                2 * padding)
            )
    cube[
            padding:padding+subcube.shape[0],
            padding:padding+subcube.shape[1],
            padding
            ] = subcube
    return cube


def load_4d(padding: int) -> np.array:
    """
    Load data in 4 dimension

    :param padding: Padding value around the initial grid
    :return: Loaded data
    """
    with (DATAPATH / '17.txt').open('r') as handle:
        subcube = []
        for line in handle.readlines():
            subcube.append(
                    np.array(
                        [
                            1 if item == '#' else 0
                            for item in line[:-1]]
                        )
                    )
        subcube = np.array(subcube)
    cube = np.zeros(
            (
                subcube.shape[0] + 2 * padding,
                subcube.shape[1] + 2 * padding,
                2 * padding, 2 * padding
                )
            )
    cube[
            padding:padding+subcube.shape[0],
            padding:padding+subcube.shape[1],
            padding, padding
            ] = subcube
    return cube


def get_nb_neighbors(cube: np.array, i: int, j: int, k: int) -> int:
    """
    Get the number of neighbors of a given subcube

    :param cube: Grid of active subcube
    :param i: Coordinate of the considered cube in the 1 dimension
    :param j: Coordinate of the considered cube in the 2 dimension
    :param k: Coordinate of the considered cube in the 3 dimension
    :return: The number of active neighbors of a given subcube
    """
    i_min, i_max = max(0, i-1), min(cube.shape[0], i+2)
    j_min, j_max = max(0, j-1), min(cube.shape[1], j+2)
    k_min, k_max = max(0, k-1), min(cube.shape[2], k+2)
    return np.sum(
            cube[i_min:i_max, j_min:j_max, k_min:k_max]
            ) - cube[i, j, k]


def get_nb_neighbors_4d(
        cube: np.array, i: int, j: int,
        k: int, l: int
        ) -> int:
    """
    Get the number of neighbors of a given subcube

    :param cube: Grid of active subcube
    :param i: Coordinate of the considered cube in the 1 dimension
    :param j: Coordinate of the considered cube in the 2 dimension
    :param k: Coordinate of the considered cube in the 3 dimension
    :param l: Coordinate of the considered cube in the 4 dimension
    :return: The number of active neighbors of a given subcube
    """
    i_min, i_max = max(0, i-1), min(cube.shape[0], i+2)
    j_min, j_max = max(0, j-1), min(cube.shape[1], j+2)
    k_min, k_max = max(0, k-1), min(cube.shape[2], k+2)
    l_min, l_max = max(0, l-1), min(cube.shape[2], l+2)
    return np.sum(
            cube[i_min:i_max, j_min:j_max, k_min:k_max, l_min:l_max]
            ) - cube[i, j, k, l]


def update_cube_4d(cube: np.array) -> np.array:
    """
    Update the 4D cube

    :param cube: Grid of active subcubes
    :return: Updated grid of active subcubes
    """
    output_cube = np.copy(cube)
    for i in range(cube.shape[0]):
        for j in range(cube.shape[1]):
            for k in range(cube.shape[2]):
                for l in range(cube.shape[3]):
                    nb_neighbors = get_nb_neighbors_4d(cube, i, j, k, l)
                    if cube[i, j, k, l] == 1 and \
                            not nb_neighbors in range(2, 4):
                        output_cube[i, j, k, l] = 0
                    elif cube[i, j, k, l] == 0 and \
                            nb_neighbors == 3:
                        output_cube[i, j, k, l] = 1
    return output_cube


def update_cube(cube):
    """
    Update the cube

    :param cube: Grid of active subcubes
    :return: Updated grid of active subcubes
    """
    output_cube = np.copy(cube)
    for i in range(cube.shape[0]):
        for j in range(cube.shape[1]):
            for k in range(cube.shape[2]):
                nb_neighbors = get_nb_neighbors(cube, i, j, k)
                if cube[i, j, k] == 1 and not nb_neighbors in range(2, 4):
                    output_cube[i, j, k] = 0
                elif cube[i, j, k] == 0 and nb_neighbors == 3:
                    output_cube[i, j, k] = 1
    return output_cube


if __name__ == '__main__':
    # Part one
    print("3D CASE:\n")
    cube = load(padding=10)
    for i in range(1, 7):
        cube = update_cube(cube)
        print("Number of cubes after {} iteration: {}".format(i, cube.sum()))

    # Part two
    print("\n4D CASE:\n")
    cube = load_4d(padding=10)
    for i in range(1, 7):
        cube = update_cube_4d(cube)
        print("Number of cubes after {} iteration: {}".format(i, cube.sum()))


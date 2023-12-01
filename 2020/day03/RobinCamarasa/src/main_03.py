"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-03

**Project** : advent code

**Code corresponding to day 3**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> np.array:
    """
    Load data and convert into numpy array (0 not tree, 1 tree)

    :return: Array that represent the forest
    """
    with (DATAPATH / '03.txt').open('r') as handle:
        lines = handle.readlines()
    return np.array(
            [np.array([0 if c == '.' else 1 for c in line[:-1]])
                for line in lines
                ]
            )


def tree_number(
        array: np.array, slope: tuple = (1, 3)
        ) -> int:
    """
    Get the number of tree

    :param array: Array that represents the forest
    :param slope: Tuple corresponding to the slope (row, column)
    :return: Number of tree crossed
    """
    nb_tree = 0
    for i in range(array.shape[0]):
        if i * slope[0] < array.shape[0]:
            nb_tree += array[
                    i * slope[0]][i * slope[1] % array.shape[1]]
        else:
            return nb_tree
    return nb_tree


def multiply_slopes(array: np.array, slopes: list):
    """
    Multiply the number of tree observed with different slopes

    :param array: Array that represents the forest
    :param slope: List of tuple corresponding to the slopes (row, column)
    :return: Product of the number of tree crossed for each slopes
    """
    product = 1
    for slope in slopes:
        product *= tree_number(array, slope)
    return product


if __name__ == '__main__':
    # Load data
    array = load()

    # First task
    print(
        'Slope (1, 3): {}'.format(tree_number(array))
            )

    # Second task
    slopes = [
            (1, 1), (1, 3), (1, 5),
            (1, 7), (2, 1)
            ]
    print(
            'Multiplication of slopes: {}'.format(
                multiply_slopes(array, slopes)
                )
            )


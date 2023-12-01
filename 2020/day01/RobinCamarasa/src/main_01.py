"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-03

**Project** : advent code

**Code corresponding to day 1**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> np.array:
    """
    Load data

    :return: Expenses
    """
    with (DATAPATH / '01.txt').open('r') as handle:
        lines = handle.readlines()
    return np.array([int(float(line)) for line in lines])


def compute_case_two_expenses(
        array: np.array, value: int = 2020
        ) -> tuple:
    """
    Compute the case to find two expenses that sums up to value

    :param array: Sorted array
    :param value: Value to reach
    :return: The first year expenses, The second year expenses, The product of the expenses
    """
    i_min, i_max = 0, array.shape[0] - 1
    while i_max > i_min and (array[i_min] + array[i_max] != value):
        if array[i_min] + array[i_max] < value:
            i_min += 1
        elif array[i_min] + array[i_max] > value:
            i_max -= 1
    if array[i_min] + array[i_max] == value:
        return array[i_min], array[i_max], array[i_min] * array[i_max]
    return (None, None, None)


def compute_case_three_expenses(array: np.array, value: int = 2020) -> tuple:
    """
    Compute the case to find three expenses that sums up to value

    :param array: Sorted array
    :param value: Value to reach
    :return: The first year expenses, The second year expenses,
    The third year expanses, The product of the expenses
    """
    for i in range(array.shape[0]):
        year_1 = array[0]
        year_2, year_3, product = compute_case_two_expenses(
                array[1:], value - year_1
                )
        array = array[1:]
        if not product is None:
            return year_1, year_2, year_3, year_1 * product
    return (None, None, None, None)


if __name__ == '__main__':
    # Load value
    array = load()

    # Sort array
    array.sort()

    # Test first problem
    print('Case two expenses :')
    print(compute_case_two_expenses(array))

    # Test second problem
    print('Case three expenses :')
    print(compute_case_three_expenses(array))

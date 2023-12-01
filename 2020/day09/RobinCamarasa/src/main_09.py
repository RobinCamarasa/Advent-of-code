"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-09

**Project** : advent code

**Code corresponding to day 09**

"""
import numpy as np
import itertools
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> np.array:
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '09.txt').open('r') as handle:
        lines = handle.readlines()
    return np.array([int(float(line)) for line in lines])


def get_sum(
        array: np.array, value: int = 2020
        ) -> tuple:
    """
    Get the two values in the array that sums up to value

    :param array: Sorted array
    :param value: Value to reach
    :return: The first year value in the array, The second value in the array,
    The product of the two values
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


def get_first_index_not_sum(array: np.array, rule: int = 25) -> tuple:
    """
    Get the first index that does not have two values that sums up in
    the last rule elements (rule-XMAS encryption)

    :param array: Input array
    :param rule: Number of previous elements considered
    :return: The index of the array that doesn't follow rule-XMAS encryption
    """
    for i in range(0, array.shape[0] - rule - 2):
        tmp = np.array(array, copy=True)[i:i+rule]
        tmp.sort()
        min_, max_, _ = get_sum(tmp, array[i+rule])
        if min_ is None:
            return i+rule, array[i+rule]


def get_encryption_weakness_sequence(array, value):
    """
    Get encryption weakness sequence

    :param array: Input array
    :param value: Value to reach
    :return: The sequence that sums up to the value to reach
    """
    for i in range(array.shape[0]):
        for j in range(i+1, array.shape[0]):
            if array[i:j].sum() == value:
                return array[i:j]


if __name__ == '__main__':
    data = load()

    # Part one
    index, value = get_first_index_not_sum(data, 25)
    print('i: {}, value: {}'.format(index, value))

    # Part two
    contiguous_array = get_encryption_weakness_sequence(data[:index], value)
    print('Encryption weakness'.format(contiguous_array.min() + contiguous_array.max()))


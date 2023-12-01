"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-10

**Project** : advent code

**Code corresponding to day 10**

"""
import numpy as np
from pathlib import Path
import itertools


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load():
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '10.txt').open('r') as handle:
        lines = handle.readlines()
    return [int(float(line[:-1])) for line in lines]


def to_nb_combination(one_seq: str) -> int:
    """
    Get the number of combinations out of a sub-sequences of
    adapters possibly out.

    """
    # A data exploration revealed that this sequence can't be
    # bigger than one in both example and full input data
    # the returned values were obtained by hand
    if one_seq == 0:
        return 1
    elif one_seq == 1:
        return 2
    elif one_seq == 2:
        return 4
    elif one_seq == 3:
        return 7


def get_number_of_combinations(
        delta: np.array
        ) -> int:
    """
    Get the number of combinations possible

    :param delta: Sequence of joltage deltas
    :return: Number of combinations of adapters
    """
    # Array of boolean 1 if you can get the adapter out
    # 0 otherwise
    possibly_out = np.ones(delta.shape)

    # An adapter with a delta of 3 cannot get out
    possibly_out[delta == 3] = 0

    # An adapter in position before an adapter with a delta 
    # of 3 cannot get out
    for i in range(1, delta.shape[-1]):
        if possibly_out[i] == 0:
            possibly_out[i - 1] = 0

    # Get the number of combinations
    # of consecutive subsequences of adapters that can get out
    possibly_out_str = ''
    for c in possibly_out.tolist():
        possibly_out_str += str(int(c))
    number_of_combinations_per_subsequence = [
            to_nb_combination(len(item))
            for item in possibly_out_str.split('0')
            ]

    # Multiply those number of subsequences
    number_of_combinations = 1
    for item in number_of_combinations_per_subsequence:
        number_of_combinations *= item
    return number_of_combinations


def get_delta(data: list) -> np.array:
    """
    Get the delta joltage of input data

    :param data: Input data
    :return: The array of delta joltages
    """
    # Add input value
    input_ = np.array([0] + data)

    # Add input value
    output_ = np.array(data + [np.max(np.array(data)) + 3])

    # Sort arrays
    input_.sort()
    output_.sort()
    return output_ - input_


if __name__ == '__main__':
    data = load()

    # Part one
    delta = get_delta(data)
    print(
            'Answer: 1: {}, 3: {}'.format(
                (delta == 1).sum(),
                (delta == 3).sum()
                )
        )

    # Part two
    print(
            'Number of combinations: {}'.format(
                get_number_of_combinations(delta)
                )
            )

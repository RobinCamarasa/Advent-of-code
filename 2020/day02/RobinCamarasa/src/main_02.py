"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-03

**Project** : advent code

**Code corresponding to day 2**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def parse_line(line: str, newrule: bool = False) -> bool:
    """
    Parse a line

    :param line: Line to parse
    :param newrule: Boolean true if it is the newrule
    :return: Boolean true password respect the rule
    """
    numbers, letter, password = tuple(line.split(' '))
    number_min, number_max = tuple([float(number) for number in numbers.split('-')])
    letter = letter[0]
    if newrule:
        return (password[int(number_min) - 1] == letter) +\
                (password[int(number_max) - 1] == letter) == 1
    return number_min <= password.count(letter) <= number_max


def load(newrule: bool = False) -> np.array:
    """
    Load data and check password

    :param newrule: Boolean true if it is the newrule
    :return: Array of boolean (True if password valid False otherwise)
    """
    with (DATAPATH / '02.txt').open('r') as handle:
        lines = handle.readlines()
    return np.array([parse_line(line, newrule) for line in lines])


if __name__ == '__main__':
    print('Rule 1: {}'.format(load().sum()))
    print('Rule 2: {}'.format(load(True).sum()))


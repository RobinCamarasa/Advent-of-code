"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-25

**Project** : advent code

**Code corresponding to day 25**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load():
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '25.txt').open('r') as handle:
        lines = handle.readlines()
    return int(lines[0][:-1]), int(lines[1][:-1])


def get_loop_size(
        public_key: int, subject_number: int = 7,
        big_prime: int = 20201227
        ) -> int:
    """
    Get the loop size

    :param public_key: Public key to retro-engineer
    :param subject_number: Initial subject number
    :param big_prime: Big prime used in the loop
    :return: The loop size
    """
    # Initial loop size
    loop_size = 0
    result = 1

    # Loop until the result 
    while result != public_key:
        result = (result * subject_number) % big_prime
        loop_size += 1
    return loop_size


def apply_loop(
        subject_number: int, loop_size: int,
        big_prime: int = 20201227,
        ) -> int:
    """
    Apply the loop to a subject_number

    :param subject_number: Subject number considered
    :param loop_size: The number of iteration of the loop
    :param big_prime: Big prime used in the loop
    """
    result = 1
    for _ in range(loop_size):
        result = (result * subject_number) % big_prime
    return result


if __name__ == '__main__':
    # Part one
    card_public_key, door_public_key = load()
    loop_size = get_loop_size(card_public_key)
    encryption = apply_loop(door_public_key, loop_size)
    print('The encryption is {}.'.format(encryption))


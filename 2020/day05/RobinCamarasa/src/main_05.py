"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-05

**Project** : advent code

**Code corresponding to day 5**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> list:
    """
    Load data

    :return: List of lines seat description
    """
    with (DATAPATH / '05.txt').open('r') as handle:
        lines = handle.readlines()
    return [line[:-1] for line in lines]


def get_seat_id(line: str) -> int:
    """
    Get the seat id from binary entry

    :param line: Line following the format of 'FFBBFBFRLR'
    :return: The seat id
    """
    row, column = 0, 0
    for i, c in enumerate(line[:7]):
        row = 2 * row + (c=='B')

    for i, c in enumerate(line[7:]):
        column = 2 * column + (c=='R')
    return row * 8 + column


def get_missing_seat_number(
        seat_ids: np.array
        ) -> int:
    """
    Get the missing seat number

    :param seat_ids: Sorted array with the seat ids
    :return: The missing seat number
    """
    seat_ids.sort()
    seat_diff = (seat_ids[:-1] + 1) - seat_ids[1:]
    missing_seat = seat_ids.min() + np.where(seat_diff == -1)[0][0] + 1
    return missing_seat


if __name__ == '__main__':
    seat_ids = np.array(
            [get_seat_id(line) for line in load()]
            )
    print(
            'Max seat id: {}'.format(
                np.max(seat_ids)
                )
            )
    print(
            'My seat: {}'.format(
                get_missing_seat_number(seat_ids)
                )
            )


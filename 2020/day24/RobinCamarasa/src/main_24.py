"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-24

**Project** : advent code

**Code corresponding to day 24**

"""
import numpy as np
from pathlib import Path
from itertools import product


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> list:
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '24.txt').open('r') as handle:
        output = []
        # Parse line
        for line in handle.readlines():
            tmp = []
            direction = ''
            for c in line[:-1]:
                direction += c
                if c in ['e', 'w']:
                    tmp.append(direction)
                    direction = ''
            output.append(tmp)
    return output


def path_to_coordinate(path: list) -> tuple:
    """
    Convert a path to a coordinate

    :param path: List of directions
    :return: Coordinate in the 2D plan
    """
    x, y = 0, 0
    for direction in path:
        dx = ('e' in direction) - ('w' in direction)
        dy = ('n' in direction) - ('s' in direction)
        dx, dy = dx/(np.abs(dx) + np.abs(dy)), dy/(np.abs(dx) + np.abs(dy))
        x += dx
        y += dy
    return x, y


def get_black_tiles(coordinates: list) -> set:
    """
    Get the black tiles from a list of coordinates

    :param coordinates: List of coordinates of tiles to flip
    :return: Set of black tiles
    """
    # Compute histogram of appearance
    hist = {coordinate:0 for coordinate in list(set(coordinates))}
    for coordinate in coordinates:
        hist[coordinate] += 1

    # Get the black tiles
    black_tiles = set()
    for key, value in hist.items():
        if (value % 2) == 1:
            black_tiles.add(key)
    return black_tiles


def get_white_tiles(black_tiles: set) -> set:
    """
    Get the white adjacent tiles

    :param black_tiles: Set of black tiles
    :return: The set of white tiles adjacent to the set of black tiles
    """
    white_tiles = set()
    for coordinate in list(black_tiles):
        for neighbor in list(get_neighbors(coordinate)):
            if not neighbor in black_tiles:
                white_tiles.add(neighbor)
    return white_tiles


def get_neighbors(coordinate: tuple) -> set:
    """
    Get the neighbors of a given tile

    :param coordinate: Coordinate of the tile
    :return: The set of neighbors of the tile
    """
    return {
            (
                coordinate[0] + dx / (np.abs(dx) + np.abs(dy)),
                coordinate[1] + dy / (np.abs(dx) + np.abs(dy))
                )
            for dx, dy in product([-1, 1], [-1, 0, 1])
            }


def update(black_tiles: set) -> set:
    """
    Update the black tiles after a day of exposition

    :param black_tiles: Set of black tiles
    :return: The updated set of black tiles
    """
    # The white tiles are the tiles adjacent to the set of black tiles
    # Those tiles are the only one that might become black
    white_tiles = get_white_tiles(black_tiles)
    new_black_tiles = set()
    for tile in list(white_tiles):
        if len(get_neighbors(tile).intersection(black_tiles)) == 2:
            new_black_tiles.add(tile)
    for tile in list(black_tiles):
        if len(get_neighbors(tile).intersection(black_tiles)) in range(1, 3):
            new_black_tiles.add(tile)
    return new_black_tiles


def update_multiple_days(black_tiles: set, number_of_days: int = 100) -> set:
    """
    Update for multiple days of exposition

    :param black_tiles: Set of black tiles
    :param number_of_days: Number of days of exposition to consider
    :return: The updated set of black tiles
    """
    for i in range(number_of_days):
        black_tiles = update(black_tiles)
    return black_tiles


if __name__ == '__main__':
    # Part one
    paths = load()
    coordinates = [path_to_coordinate(path) for path in paths]
    black_tiles = get_black_tiles(coordinates)
    print('The number of black tiles is {}.'.format(len(black_tiles)))

    # Part two
    black_tiles = update_multiple_days(black_tiles)
    print(
            'The number of black tiles after 100 days'+\
            ' of exhibits is {}.'.format(len(black_tiles))
            )


"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-12

**Project** : advent code

**Code corresponding to day 12**

"""
import numpy as np
from pathlib import Path
import matplotlib
import matplotlib.pyplot as plt


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'
RESULTPATH = ROOTPATH / 'result'

ORIENTATION = ['E', 'S', 'W', 'N']


def load() -> list:
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '12.txt').open('r') as handle:
        lines = handle.readlines()
        output = []
        for line in lines:
            action, amplitude = line[0], int(float(line[1:-1]))
            output.append((action, amplitude))
    return output


def get_path(data: list, initial_orientation: int) -> list:
    """
    Get the path of the boat from the coordinates

    :param data: List of instructions (ex: 'F', 10)
    :param initial_orientation: Index of the initial orientation
    (ex: 0 -> 'E')
    :return: List of coordinates
    """
    path = [{'E':0, 'S':0, 'W':0, 'N':0}]
    orientation = initial_orientation
    for action, amplitude in data:
        new_coordinate = path[-1].copy()
        if action == 'L':
            orientation -= int(amplitude/90)
            reduce_coordinate(new_coordinate)
        elif action == 'R':
            orientation += int(amplitude/90)
            reduce_coordinate(new_coordinate)
        elif action in ['E', 'S', 'W', 'N']:
            new_coordinate[action] += amplitude
            reduce_coordinate(new_coordinate)
            new_coordinate = reduce_coordinate(new_coordinate)
            path.append(new_coordinate)
        else:
            new_coordinate[ORIENTATION[orientation%4]] += amplitude
            new_coordinate = reduce_coordinate(new_coordinate)
            path.append(new_coordinate)
    return path


def reduce_coordinate(coordinate: dict) -> dict:
    """
    Reduce the coordinate to a equivalent representation
    where 'E' and 'W' cannot not be both non null and where
    where 'S' and 'N' cannot not be both non null


    :param coordinate: Coordinate of the boat
    (ex  {'E':7, 'S':0, 'W':5, 'N':0})
    :return: Reduced coordinates of the boat
    (ex  {'E':2, 'S':0, 'W':0, 'N':0})
    """
    output = {'E':0, 'S':0, 'W':0, 'N':0}
    if coordinate['E'] - coordinate['W'] > 0:
        output['E'] = coordinate['E'] - coordinate['W']
    else:
        output['W'] = coordinate['W'] - coordinate['E']
    if coordinate['N'] - coordinate['S'] > 0:
        output['N'] = coordinate['N'] - coordinate['S']
    else:
        output['S'] = coordinate['S'] - coordinate['N']
    return output


def get_path_with_waypoint(
        data, way_point_position={'E':10, 'S':0, 'W':0, 'N':1}
        ) -> list:
    """
    Get path with the way point instructions

    :param data: List of instructions (ex: 'F', 10)
    :param way_point_position: Position of the way point relatively
    to the boat
    :return: List of coordinates
    """
    path = [{'E':0, 'S':0, 'W':0, 'N':0}]
    for action, amplitude in data:
        new_coordinate = path[-1].copy()
        if action == 'L':
            way_point_position={
                    ORIENTATION[(i - int(amplitude/90)) % 4]: way_point_position[
                        orientation
                        ]
                    for i, orientation  in enumerate(ORIENTATION)
                    }
            reduce_coordinate(way_point_position)
        elif action == 'R':
            way_point_position={
                    ORIENTATION[(i + int(amplitude/90)) % 4]: way_point_position[
                        orientation
                        ]
                    for i, orientation  in enumerate(ORIENTATION)
                    }
            way_point_position = reduce_coordinate(way_point_position)
        elif action in ['E', 'S', 'W', 'N']:
            way_point_position[action] += amplitude
            way_point_position = reduce_coordinate(way_point_position)
        else:
            for orientation in ORIENTATION:
                new_coordinate[orientation] += amplitude *\
                        way_point_position[orientation]
            new_coordinate = reduce_coordinate(new_coordinate)
            path.append(new_coordinate)
    return path


def get_diff(coordinate_1: dict, coordinate_2: dict) -> int:
    """
    Get the Manhattan distance between two coordinates

    :param coordinate_1: First coordinate considered
    :param coordinate_2: Last coordinate considered
    :return: Manhattan distance between the two coordinates
    """
    return np.abs(
            (coordinate_1['E'] - coordinate_1['W']) -\
            (coordinate_2['E'] - coordinate_2['W'])
            ) +\
            np.abs(
            (coordinate_1['S'] - coordinate_1['N']) -\
            (coordinate_2['S'] - coordinate_2['N'])
            )


def plot(list_of_coordinate: list, save_path: Path) -> None:
    """
    Plot the list of coordinates of the boat

    :param list_of_coordinate: List of coordinate of the boat
    :param path: Path to save the plot
    """
    x=[]
    y=[]
    plt.clf()
    for coordinate in list_of_coordinate:
        x.append(coordinate['E'] - coordinate['W'])
        y.append(coordinate['N'] - coordinate['S'])
    plt.plot(x, y)
    plt.savefig(save_path)


if __name__ == '__main__':
    # Part one
    data = load()
    initial_orientation = 0
    path = get_path(data, initial_orientation)
    manhattan_dist = get_diff(path[-1], path[0])
    print("With the first set of rules the manhattan distance is: {}".format(
        manhattan_dist
        )
        )
    plot(path, (RESULTPATH / 'first_rule.png'))

    # Part two
    data = load()
    initial_orientation = 0
    path = get_path_with_waypoint(data)
    manhattan_dist = get_diff(path[-1], path[0])
    print("With the second set of rules the manhattan distance is: {}".format(
        manhattan_dist
        )
        )
    plot(path, (RESULTPATH / 'second_rule.png'))


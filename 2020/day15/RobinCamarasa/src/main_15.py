"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-15

**Project** : advent code

**Code corresponding to day 15**

"""
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path


def get_turns_efficiently(input_data, last_round):
    """
    Get the value of the last round

    :param input_data: List of first rounds value
    :param last_round: Last round value
    :return: Return the value in the last round
    """
    last_visited = {value: i + 1 for i, value in enumerate(input_data[:-1])}
    last_value = input_data[-1]
    for i in range(len(input_data) + 1, last_round + 1):
        tmp = last_value
        if last_value in last_visited.keys():
            last_value = i - 1 - last_visited[last_value]
        else:
            last_value = 0
        last_visited[tmp] = i - 1
    return last_value


if __name__ == '__main__':
    data = [0,13,1,8,6,15]

    # Part one
    value = get_turns_efficiently(data, 2020)
    print('2020th value: {}'.format(value))

    # Part two
    value = get_turns_efficiently(data, 30000000)
    print('30000000 value: {}'.format(value))


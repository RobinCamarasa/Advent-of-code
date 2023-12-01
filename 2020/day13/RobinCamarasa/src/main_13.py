"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-13

**Project** : advent code

**Code corresponding to day 13**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> tuple:
    """
    Load data

    :return: Timestamp of your arrival and a list of buses
    (ex: (9689, [8, -1, -1, 46]))
    """
    with (DATAPATH / '13.txt').open('r') as handle:
        timestamp = int(float(handle.readline()))
        buses = handle.readline().split(',')
        buses = [-1 if bus == 'x' else int(float(bus)) for bus in buses]
    return timestamp, buses


def get_bus_and_delta_time(timestamp: int, buses: list) -> tuple:
    """
    Get the bus number and the time to wait before the bus goes

    :param timestamp: Timestamp of your arrival
    :param buses: List of the available buses
    (ex: [8, -1, -1, 46])
    :return: The bus you take and the time you wait
    """
    bus, delta_time = -1, np.inf
    for bus_ in buses:
        if bus_ != -1 and bus_ - (timestamp % bus_) < delta_time:
            bus, delta_time = bus_, bus_ - (timestamp % bus_)
    return bus, delta_time


def get_constraints(buses: list) -> list:
    """
    Get the constraints to solve the company challenge

    :param buses: List of the available buses
    (ex: [8, -1, -1, 46])
    :return: The list of constraints each constraint being a
    tuple with the following format (line, delay)
    """
    output = []
    for i, bus in enumerate(buses):
        if bus != -1:
            output.append((bus, i))
    return output


if __name__ == '__main__':
    # Part one
    timestamp, buses = load()
    bus, delta_time = get_bus_and_delta_time(timestamp, buses)
    print(
            "Multiplication of the bus number and the wait time is {}".format(
                bus * delta_time
                )
            )

    # Part two
    # Note that this is not in a function as the case really
    # Specific to the example :)
    constraints = get_constraints(buses)
    finished = False
    q = 1
    while not finished:
        number = 13 * 17 * 37 * 29 * 641 * q - 13
        finished = True
        for bus, i in constraints:
            finished = finished and ((number + i) % bus == 0)
        q += 1
    print(
        "The first timestamp satisfying the constraints is {}.".format(
            number
            )
            )



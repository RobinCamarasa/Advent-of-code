"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-23

**Project** : advent code

**Code corresponding to day 23**

"""
import numpy as np
from pathlib import Path
import time


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load():
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '23.txt').open('r') as handle:
        return list([int(i) for i in handle.read()[:-1]])


def do_move(cups, position):
    # Get the number of cups and the current position of the cups
    number_of_cups = len(cups)
    position = position % number_of_cups
    cups_label = cups[position]

    # Get picked up 
    picked_up = (2 * cups)[position + 1:position + 4]
    for cup in picked_up:
        cups.remove(cup)

    # Get the destination
    destination = cups_label - 1 if cups_label != 1 else max(cups)
    while destination in picked_up:
        destination = destination - 1 if destination != 1 else max(cups)
    destination_id = cups.index(destination)

    # Move the picked up cups
    cups = cups[:destination_id + 1] + picked_up + cups[destination_id + 1:]
    while cups.index(cups_label) != position:
        cups = [cups[-1]] + cups[:-1]
    return cups


def do_multiple_moves(cups, number_moves):
    # Loop over the moves
    for position in range(number_moves):
        cups = do_move(cups, position)

    # Format to the challenge
    before_1, after_1 = ''.join([str(i) for i in cups]).split('1')
    return after_1 + before_1


class CrabGame:
    def __init__(
            self, cups, initial_position = 0,
            number_of_elements = 9
            ):
        self.number_of_elements = number_of_elements
        self.position = initial_position

        # Initialize array of positions
        self.arr = np.arange(number_of_elements)
        for i, value in enumerate(cups):
            self.arr[value - 1] = i

    def do_move(self):
        # Get cup label
        cup_label = np.where(self.arr == self.position)[0][0]

        # Pick up cups
        picked_up_values = [
                np.where(
                    self.arr == (self.position + i) % self.number_of_elements
                    )[0][0]
                for i in range(1, 4)
                ]
        self.arr[self.arr > self.position] -= 3

        # Get the new position
        predecessor = (cup_label - 1) % self.number_of_elements
        while predecessor in picked_up_values:
            predecessor = (predecessor - 1) % self.number_of_elements
        new_position = self.arr[predecessor]

        # Update positions
        self.arr[self.arr > new_position] += 3
        for i, position in enumerate(picked_up_values):
            self.arr[position] = (new_position + i + 1) % self.number_of_elements
        self.position = (self.arr[cup_label] + 1) % self.number_of_elements
        self.arr = (self.arr % self.number_of_elements)

    def __str__(self):
        message = ''
        for position in range(self.number_of_elements):
            message += str(np.where(self.arr == position)[0][0] + 1)
        return message

    def do_multiple_moves(self, number_of_moves):
        start_time = time.time()
        for i in range(number_of_moves):
            self.do_move()
            if i % 1000 == 0:
                end_time = time.time()
                print(
                        'Delta time: {}'.format(end_time - start_time)
                        )
                start_time = end_time


if __name__ == '__main__':
    # Part one
    cups = load()
    final_cups = do_multiple_moves(cups, 100)
    print('The cups labels are {}.'.format(final_cups))

    # Part two: Take 23 days to run
    # cups = load()
    # crab_game = CrabGame(cups, number_of_elements=1000000)
    # crab_game.do_multiple_moves(10000000)

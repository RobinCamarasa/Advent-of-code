"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-08

**Project** : advent code

**Code corresponding to day 08**

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
    with (DATAPATH / '08.txt').open('r') as handle:
        lines = handle.readlines()
    return [line[:-1] for line in lines]


def parse_line(line: str) -> tuple:
    """
    Parse line

    :param line: input line (ex: 'nop -1')
    :return: Parsed input line (ex: 'nop', -1)
    """
    action, value = line.split(' ')
    value = int(float(value))
    return action, value


def execute_sequence(actions: list) -> tuple:
    """
    Execute a given sequence of actions

    :param actions: List of the actions of the program
    :return: A tuple that contains a boolean True if the sequence finishes
    False otherwise a list of the accumulator values  and a list of indexes
    of the action executed
    """
    index, acc, acc_sequence, index_sequence = 0, 0, [], []
    finished = False
    while index != len(actions)-1 and not index in index_sequence[:-1]:
        action, value = actions[index]
        if action == 'nop':
            index += 1
        elif action == 'jmp':
            index += value
        elif action == 'acc':
            acc += value
            index += 1
        index_sequence.append(index)
        acc_sequence.append(acc)
    if index == len(actions) - 1:
        finished = True
    if index == len(actions) - 1 and actions[-1][0] == 'acc':
        acc += actions[-1][1]
        acc_sequence.append(acc)
    return finished, acc_sequence, index_sequence


def modify_action(actions: list, index: int) -> list:
    """
    Modify action of index i to 'jmp' if 'nop' and to 'nop' if 'jmp'

    :param actions: List of the actions of the program
    :param index: Index of the action to to modify
    :return: The modified list of actions
    """
    action, value = actions[index]
    action_ = 'acc'
    if action == 'jmp':
        action_ = 'nop'
    elif action == 'nop':
        action_ = 'jmp'
    actions_ = actions[:]
    actions_[index] = (action_, value)
    return actions_


def get_corrupted_line(actions: list) -> tuple:
    """
    Get the corrupted line

    :param actions: List of the actions of the program
    :return: A tuple that contain the index of the corrupted line,
    a boolean True if the sequence finishes False otherwise, and the
    final value of the accumulator
    """
    for i in range(len(actions)):
        actions_ = modify_action(actions, i)
        finished, acc_sequence, index_sequence = execute_sequence(
                actions_
                )
        if finished:
            return i, finished, acc_sequence[-1]


if __name__ == '__main__':
    data = load()

    # Part one
    actions = [parse_line(line) for line in data]
    finished, acc_sequence, index_sequence = execute_sequence(actions)
    print('Finished: {}, Accumulator: {}'.format(finished, acc_sequence[-1]))

    # Part two
    print('Index: {}, Finished: {}, Accumulator: {}'.format(
            *get_corrupted_line(actions)
            )
        )

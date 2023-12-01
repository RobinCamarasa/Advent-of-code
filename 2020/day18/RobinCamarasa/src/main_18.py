"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-18

**Project** : advent code

**Code corresponding to day 18**

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
    with (DATAPATH / '18.txt').open('r') as handle:
        lines = handle.readlines()
    return [line[:-1] for line in lines]


def evaluate_line(line):
    """
    Evaluate a line using the first set of rule

    :param line: Line that contains operations
    :return: The value of the operation with a the first set of rules
    """
    if '(' in line:
        # Parse the first expression with parenthesis that does not
        # contain parenthesis
        parenthesis_count = 0
        opening_parenthesis_position = -1
        closing_parenthesis_position = -1
        for i, c in enumerate(line):
            if c == '(':
                parenthesis_count += 1
                if opening_parenthesis_position == -1:
                    opening_parenthesis_position = i
            elif c == ')':
                parenthesis_count -= 1
                if closing_parenthesis_position == -1 and\
                        parenthesis_count == 0:
                    closing_parenthesis_position = i
        inside_parenthesis = line[
                opening_parenthesis_position:closing_parenthesis_position + 1
                ]
        next_line = line.replace(inside_parenthesis, '{}').format(
                evaluate_line(inside_parenthesis[1:-1])
                )
        return evaluate_line(next_line)
    else:
        # Evaluate expression from left to right without parenthesis
        splitted_line = line.split(' ')
        acc = int(splitted_line[0])
        sign = None
        for item in splitted_line[1:]:
            if item in ['*', '+']:
                sign = item
            else:
                value = int(item)
                acc = acc * value if sign == '*' else acc + value
        return acc


def evaluate_line_advanced(line):
    """
    Evaluate a line using the second set of rule

    :param line: Line that contains operations
    :return: The value of the operation with a the second set of rules
    """
    if '(' in line:
        # Parse the first expression with parenthesis that does not 
        # contain parenthesis
        parenthesis_count = 0
        opening_parenthesis_position = -1
        closing_parenthesis_position = -1
        for i, c in enumerate(line):
            if c == '(':
                parenthesis_count += 1
                if opening_parenthesis_position == -1:
                    opening_parenthesis_position = i
            elif c == ')':
                parenthesis_count -= 1
                if closing_parenthesis_position == -1 and\
                        parenthesis_count == 0:
                    closing_parenthesis_position = i
        inside_parenthesis = line[
                opening_parenthesis_position:closing_parenthesis_position + 1
                ]
        next_line = line.replace(inside_parenthesis, '{}').format(
                evaluate_line_advanced(inside_parenthesis[1:-1])
                )
        return evaluate_line_advanced(next_line)
    elif '+' in line:
        # Treat the case of the expressions that contains a plus sign but
        # no parenthesis
        plus_index = line.index('+')
        before_plus_splitted_line = line[:plus_index - 1].split(' ')
        after_plus_splitted_line = line[plus_index + 2:].split(' ')
        operation_result = int(before_plus_splitted_line[-1]) +\
                int(after_plus_splitted_line[0])
        next_line = ' '.join(
                before_plus_splitted_line[:-1] +\
                        [str(operation_result)] +\
                        after_plus_splitted_line[1:]
                )
        return evaluate_line_advanced(next_line)
    else:
        # Treat the case of the expressions that contains only multiplication
        # signs
        acc = 1
        splitted_line = line.split(' * ')
        for item in splitted_line:
            acc *= int(item)
        return acc


if __name__ == '__main__':
    # Part one
    data = load()
    sums = [evaluate_line(line) for line in data]
    result = np.sum(np.array(sums))
    print(
            'The sum of the lines with the first set of rules is: {}'.format(
                result
                )
            )

    # Part two
    sums = [evaluate_line_advanced(line) for line in data]
    result = np.sum(np.array(sums))
    print(
            'The sum of the lines with the second set of rules is: {}'.format(
                result
                )
            )


"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-16

**Project** : advent code

**Code corresponding to day 16**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> tuple:
    """
    Load data

    :return: Tuple of the rules and the tickets
    (ex: {'name': (range(1, 7), range(8, 20))}, [1], [[5], [4], [31]])
    """
    with (DATAPATH / '16.txt').open('r') as handle:
        # Get the rules
        rules = {}
        line = handle.readline()
        while line != '\n':
            name, range_1, range_2 = parse_rule(line)
            rules[name] = (range_1, range_2)
            line = handle.readline()

        # Get your ticket
        line = handle.readline()
        line = handle.readline()
        your_ticket = [
                int(field) for field in line.split(',')
                ]

        # Get the other tickets
        line = handle.readline()
        line = handle.readline()
        other_tickets = []
        for line in handle.readlines():
            other_tickets.append(
                    [
                    int(field) for field in line.split(',')
                    ])
    return rules, your_ticket, other_tickets


def parse_rule(line: str) -> tuple:
    """
    Parse line into a rule

    :param line: Line having a rule format
    (ex: 'name: 1-6 or 8-19')
    :return: The name of the rules and the range of values
    (ex: 'name', range(1, 7), range(8, 20)')
    """
    # Get the name of the rule
    name = line.split(':')[0]

    # Get the range of values
    splitted_line = line.split(':')[-1].split(' ')
    range_1_min, range_1_max = splitted_line[1].split('-')
    range_1 = range(int(range_1_min), int(range_1_max) + 1)

    range_2_min, range_2_max = splitted_line[-1].split('-')
    range_2 = range(int(range_2_min), int(range_2_max) + 1)
    return name, range_1, range_2


def filter_error(rules: dict, other_tickets: list) -> tuple:
    """
    Filter tickets having an error

    :param rules: Rules that ticket fields must follow
    (ex: {'name': (range(1, 7), range(8, 20))})
    :param other_tickets: List the noted tickets
    (ex: [[5], [4], [31]])
    :return: Integer containing the error rate and the list of tickets that follows the rules
    (ex: 31, [[5], [4]])
    """
    error_rate = 0
    filtered_tickets = []
    # Loop over the other tickets
    for other_ticket in other_tickets:
        ticket_error = False

        # Loop over the fields of the considered other tickets
        for field in other_ticket:
            error = True

            # Loop over the rules to find if the field fit one rule
            for range_1, range_2 in rules.values():
                error = error and (not field in range_1)\
                        and (not field in range_2)
            # Add the field to the scanning error rate
            error_rate += field * error
            ticket_error = ticket_error or error

        # Add tickets without errors
        if not ticket_error:
            filtered_tickets.append(other_ticket)
    return error_rate, filtered_tickets


def attribute_fields(rules: dict, filtered_tickets: list) -> list:
    """
    Attribute fields to columns

    :param rules: Rules that ticket fields must follow
    (ex: {'name': (range(1, 7), range(8, 20))})
    :param filtered_tickets: List the noted tickets
    (ex: [[31]])
    :return: The list of attributed fields
    (ex: ['name'])
    """
    # Initialise possible fields
    possible_fields = [[] for _ in range(len(filtered_tickets[0]))]
    for j in range(len(filtered_tickets[0])):
        for name, (range_1, range_2) in rules.items():
            possible = True
            for i in range(len(filtered_tickets)):
                possible = possible and (
                        filtered_tickets[i][j] in range_1 or\
                        filtered_tickets[i][j] in range_2
                        )
            if possible:
                possible_fields[j].append(name)

    # Initialise attributed fields
    attributed_fields = [None for _ in range(len(filtered_tickets[0]))]

    # Initialise the list containing the number of possible fields per field
    to_len = lambda list_: [len(el) for el in list_]
    len_possible_fields = to_len(possible_fields)

    # Update the possible fields attributing the field that can only 
    # have one value
    while np.sum(np.array(len_possible_fields)) != 0:
        attributed_field = possible_fields[
                len_possible_fields.index(1)
                ][0]

        attributed_fields[len_possible_fields.index(1)] = attributed_field
        for possible_field_ in possible_fields:
            if attributed_field in possible_field_:
                possible_field_.pop(possible_field_.index(attributed_field))
        len_possible_fields = to_len(possible_fields)
    return attributed_fields


if __name__ == '__main__':
    # Part one
    rules, your_ticket, other_tickets = load()
    error_rate, _ = filter_error(rules, other_tickets)
    print('The error rate is: {}'.format(error_rate))

    # Part two
    rules, your_ticket, other_tickets = load()
    _, filtered_tickets = filter_error(rules, other_tickets)
    attributed_fields = attribute_fields(rules, filtered_tickets)
    product = 1
    for attributed_field, your_ticket in zip(attributed_fields, your_ticket):
        if 'departure' in attributed_field:
            product *= your_ticket
    print(
            'The product of the fields starting with "departure" is: {}'.format(
                product
                )
            )


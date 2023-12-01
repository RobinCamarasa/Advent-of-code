"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-19

**Project** : advent code

**Code corresponding to day 19 part two**

"""
import numpy as np
import pickle
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


# Load variables from part one
with (DATAPATH / 'expanded_rules.pkl').open('rb') as handle:
    EXPANDED_RULES = pickle.load(handle)
with (DATAPATH / 'remaining_messages.pkl').open('rb') as handle:
    REMAINING_MESSAGES = pickle.load(handle)


def is_rule(message: str) -> bool:
    """
    Test if message could follow the looping of rules

    :param message: Message to analyse
    :return: True if the message follow a looping rule False
    otherwise
    """
    possibilities = []
    for i in range(0, len(message), 8):
        # This division in block of 8 comes from the observation
        # that rule 8, 42 and 31 can only produce messages of size 8
        possibilities.append(
                (
                    (message[i:i+8] in EXPANDED_RULES[8]),
                    (message[i:i+8] in EXPANDED_RULES[42]),
                    (message[i:i+8] in EXPANDED_RULES[31]),
                ))
    output = False
    for i in range(1, int((len(possibilities) - 1) / 2) + 1):
        # For a given number i of block that follows rule 8
        # There is only a single possibility that follow this pattern
        # [rule_8]+[rule_42]{N}[rule_31]{N}
        output = output or assess_possibility(i, possibilities)
    return output


def assess_possibility(i, possibilities):
    """
    Test if a start with i blocks following rule 8 could fit the
    requirements of the possibilities

    :param possibilities: List of tuples (tuple containing 3 booleans
    that respectively assess if block i can follow rule 8, 42 or 31)
    """
    output = not False in [
                possibility[2]
                for possibility in possibilities[-i:]
                ]
    possibilities = possibilities[:-i]
    output = output and not False in [
                possibility[1]
                for possibility in possibilities[-i:]
                ]
    possibilities = possibilities[:-i]
    output = output and not False in [
                possibility[0]
                for possibility in possibilities
                ]
    output = output and len(possibilities) != 0
    return output


if __name__ == '__main__':
    # The initialisation value is the number of already valid messages
    nb_messages = 136
    for i, message in enumerate(REMAINING_MESSAGES):
        nb_messages += is_rule(message)
    print("The number of valid messages is {}".format(nb_messages))


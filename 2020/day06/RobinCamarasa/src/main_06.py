"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-06

**Project** : advent code

**Code corresponding to day 06**

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
    with (DATAPATH / '06.txt').open('r') as handle:
        lines = handle.read().split('\n\n')
    return lines

def get_number_of_single_yes(line: str) -> int:
    """
    Get the number of answer where at least on member of the group answered yes

    :param line: Answers of a given group. Individual answers are
    separated via a \n
    :return: The number where at least one member of the group answered yes
    """
    line = line.replace('\n', '')
    return len(set(list(line)))


def get_number_of_commom_yes(line: str) -> int:
    """
    Get the number of answer where all the group answered yes

    :param line: Answers of a given group. Individual answers are
    separated via a \n
    :return: The number where at all the group answered yes
    """
    answers = line.split('\n')
    common_answer = set(list(answers[0]))
    for answer in answers[1:]:
        common_answer = common_answer.intersection(answer)
    return len(common_answer)


if __name__ == '__main__':
    data = load()

    # Part one
    answers = np.array([get_number_of_single_yes(line)for line in data])
    print('Sum of the number of single yes per group: {}'.format(answers.sum()))

    # Part two
    answers = np.array([get_number_of_commom_yes(line)for line in data])
    print('Sum of the number of all yes per group: {}'.format(answers.sum()))


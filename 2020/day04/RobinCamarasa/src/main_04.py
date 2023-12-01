"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-04

**Project** : advent code

**Code corresponding to day 4**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> list:
    """
    Load data

    :return: List of lines
    """
    with (DATAPATH / '04.txt').open('r') as handle:
        lines = handle.read().split('\n\n')

    lines[-1] = lines[-1][:-1]
    return [line.replace('\n', ' ') for line in lines]

def parse_passeport(line: str) -> dict:
    """
    Parse line into a passeport
    """
    keys_values = line.split(' ')
    output = {}
    for key_value in keys_values:
        key, value = key_value.split(':')
        output[key]=value
    return output

def check_presence(passport: dict) -> bool:
    """
    Check that the input is a passport

    :param passport: Passport candidate
    :return: Boolean 'True' if the passport candidate is a passport
    """
    required_keys = {'ecl', 'pid', 'eyr', 'hcl', 'byr', 'iyr', 'hgt'}
    keys = set(list(passport.keys()))
    return len(list(keys.intersection(required_keys))) == 7


def check_validity(passport: dict) -> bool:
    """
    Check the validity of the fields of a passport

    :param passport: Passport candidate
    :return: Boolean 'True' if the passport candidate is valid
    """
    if not check_presence(passport):
        return False
    valid = True
    try:
        # Check years
        valid = valid and int(float(passport['byr'])) in range(1920, 2003)
        valid = valid and int(float(passport['iyr'])) in range(2010, 2021)
        valid = valid and int(float(passport['eyr'])) in range(2020, 2031)

        # Check eye color
        valid = valid and passport['ecl'] in [
                'amb', 'blu', 'brn', 'gry',
                'grn', 'hzl', 'oth'
                ]

        # Check eye color
        valid = valid and len(passport['pid']) == 9 and \
            int(float(passport['pid'])) > 0

        # Check hair color
        valid = valid and passport['hcl'][0] == '#' and \
                len(passport['hcl']) == 7
        for c in passport['hcl'][1:]:
            valid = valid and c in [str(i) for i in range(10)] +\
                    list('abcdef')

        # Check height
        if 'cm' in passport['hgt']:
            valid = valid and int(float(passport['hgt'][:3])) in\
                    range(150, 194)
        elif 'in' in passport['hgt']:
            valid = valid and int(float(passport['hgt'][:2])) in\
                    range(59, 77)
        else:
            valid = False
    except Exception as e:
        valid = False

    return valid


if __name__ == '__main__':
    passports = load()
    passports = [parse_passeport(line) for line in passports]
    presence = np.array([check_presence(line) for line in passports])
    print(
            'Number of present passports: {}'.format(
                np.sum(presence)
                )
            )

    validity = np.array([check_validity(line) for line in passports])
    print(
            'Number of valid passports: {}'.format(
                np.sum(validity)
                )
            )

"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-19

**Project** : advent code

**Code corresponding to day 19**

"""
import numpy as np
import pickle
from pathlib import Path
import tqdm


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> tuple:
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '19.txt').open('r') as handle:
        lines = handle.read()
        rules_list, messages = lines.split('\n\n')
    # Get messages
    messages = messages[:-1].split('\n')

    # Get rules
    rules_list = rules_list.split('\n')
    rules = {}
    for rule in rules_list:
        key, value = rule.split(': ')
        if "\"" in value:
            rules[int(key)] = value[1]
        elif "|" in value:
            first_part, second_part = value.split(' | ')
            rules[int(key)] = (
                    [int(item) for item in first_part.split(' ')],
                    [int(item) for item in second_part.split(' ')],
                    )
        else:
            rules[int(key)] = [
                    int(item)
                    for item in value.split(' ')
                    ]
        value = int(key)
    return rules, messages


def get_rules_order(key: int, rules: dict, acc: list) -> list:
    """
    Get the order in which the expansion of the rules must be done
    to avoid conflict to obtain all the options of the rule key.

    :param key: Rule that we need all the options
    :param rules: Dictionnary containing the rules
    :param acc: Accumulator of this recursive function
    :return: List that represents the order
    """
    # If we know the option of the rule return the accumulator
    if key in acc:
        return acc

    # If the rule have only one option return the accumulator
    elif type(rules[key]) == str:
        acc.append(key)
        return acc

    # Else apply recurrence
    else:
        if type(rules[key]) == tuple:
            new_rules = list(set(rules[key][0] + rules[key][1]))
        else:
            new_rules = list(set(rules[key]))
        for key_ in new_rules:
            acc = get_rules_order(key_, rules, acc)
        acc.append(key)
        return acc


def expand(rule: list, expanded_rules: dict, acc: list = []) -> list:
    """
    Expand the rules to all possible options for the message

    :param rule: Rule that need to be expanded (ex: [43, 63, 2])
    :param expanded_rules: Rules already expanded
    :param acc: Accumulator of this recursive function
    :return: All the options of this rule (ex: ['abaa', 'a', 'b'])
    """
    # If the rule have only one option return the accumulator
    if len(rule) == 0:
        return acc

    # Else apply recurrence
    else:
        top_element = expanded_rules[rule[0]]
        possible_followers = expand(rule[1:], expanded_rules, acc)
        possible_followers = possible_followers if len(possible_followers) != 0 else ['']
        acc = []
        for element in top_element:
            for possible_follower in possible_followers:
                acc.append(element + possible_follower)
        acc = list(set(acc))
        return acc


def apply_rules(rules: dict, order: list) -> dict:
    """
    Apply the rules in order to get all the options of the rule

    :param rules: Dictionnary that contains the rules
    :param order: Order in which the rules have to be applied to get
    the final element of the order list
    :return: Dictionnary of all the expanded version of the rules contained
    in order
    """
    # Initialise expanded rules
    expanded_rules = {
            key: [value] if type(value) == str else None
            for key, value in rules.items()
            }

    # Expand rules in order
    for item in order:
        if type(rules[item]) == tuple:
            expanded_rules[item] = list(set(expand(
                    rules[item][0], expanded_rules
                    ) +\
                expand(
                    rules[item][1], expanded_rules
                    )))
        elif type(rules[item]) == list:
            expanded_rules[item] = list(set(expand(
                    rules[item], expanded_rules
                    )))
    return expanded_rules


if __name__ == '__main__':
    # Part one
    rules, messages = load()
    order = get_rules_order(0, rules, [])
    expanded_rules = apply_rules(rules, order)
    remaining_messages = []
    nb_message = 0
    print("Analyse messages")
    for i, message in tqdm.tqdm(enumerate(messages)):
        if message in expanded_rules[0]:
            nb_message += 1
        else:
            remaining_messages.append(message)
    print("Number of valid message: {}".format(nb_message))

    # Save variables for part two
    with (DATAPATH / 'rules.pkl').open('wb') as handle:
        pickle.dump(rules, handle)
    with (DATAPATH / 'messages.pkl').open('wb') as handle:
        pickle.dump(messages, handle)
    with (DATAPATH / 'expanded_rules.pkl').open('wb') as handle:
        pickle.dump(expanded_rules, handle)
    with (DATAPATH / 'order.pkl').open('wb') as handle:
        pickle.dump(order, handle)
    with (DATAPATH / 'remaining_messages.pkl').open('wb') as handle:
        pickle.dump(remaining_messages, handle)


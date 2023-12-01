"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-22

**Project** : advent code

**Code corresponding to day 22**

"""
import numpy as np
import sys
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> tuple:
    """
    Load data

    :return: Deck of cards of player 1 and deck of card of player 2
    """
    with (DATAPATH / '22.txt').open('r') as handle:
        deck_1, deck_2 = [], []
        player = None
        for line in handle.readlines():
            if 'Player' in line:
                player = int(line[:-2].split(' ')[1])
            elif len(line) != 1 and player == 1:
                deck_1.append(int(line))
            elif len(line) != 1 and player == 2:
                deck_2.append(int(line))
    return deck_1, deck_2


def play_round(deck_1: list, deck_2: list) -> tuple:
    """
    Play a round in non recursive setup

    :param deck_1: Deck of cards of player 1
    :param deck_2: Deck of cards of player 2
    :return: The updated decks
    """
    card_1 = deck_1[0]
    card_2 = deck_2[0]
    if card_1 > card_2:
        return deck_1[1:] + [card_1, card_2], deck_2[1:]
    else:
        return deck_1[1:], deck_2[1:] + [card_2, card_1]


def play(deck_1: list, deck_2: list) -> list:
    """
    Play combat

    :param deck_1: Deck of cards of player 1
    :param deck_2: Deck of cards of player 2
    :return: The winners deck
    """
    while len(deck_1) != 0 and len(deck_2) != 0:
        deck_1, deck_2 = play_round(deck_1, deck_2)
    return deck_1 + deck_2


def play_recursive(deck_1: list, deck_2: list) -> tuple:
    """
    Play recursive combat

    :param deck_1: Deck of cards of player 1
    :param deck_2: Deck of cards of player 2
    :return: A boolean True if player 1 won and the winning deck
    """
    # Initialize the seen configurations
    seen_1 = set()
    seen_2 = set()

    while len(deck_1) and len(deck_2):
        if tuple(deck_1) in seen_1 and tuple(deck_2) in seen_2:
            return True, deck_1

        # Draw cards
        seen_1.add(tuple(deck_1))
        seen_2.add(tuple(deck_2))
        card_1, card_2 = deck_1.pop(0), deck_2.pop(0)

        if card_1 <= len(deck_1)  and card_2 <= len(deck_2) :
            is_player_1, _ = play_recursive(deck_1[:card_1], deck_2[:card_2])
        else:
            is_player_1 = (card_1 > card_2)

        if is_player_1:
            deck_1.append(card_1)
            deck_1.append(card_2)
        else:
            deck_2.append(card_2)
            deck_2.append(card_1)

    # Return the winner
    return len(deck_1) > len(deck_2), deck_1 + deck_2


def get_score(deck: list) -> int:
    """
    Evaluate the score of a deck

    :param deck: Deck to evaluate
    :return: The score of the given deck
    """
    return (np.array(deck) * (len(deck) - np.arange(len(deck)))).sum()


if __name__ == '__main__':
    # Part one
    deck_1, deck_2 = load()
    deck = play(deck_1, deck_2)
    score = get_score(deck)
    print("The score is {}".format(score))

    # Part two
    deck_1, deck_2 = load()
    _, deck = play_recursive(deck_1, deck_2)
    score = get_score(deck)
    print("The score is {}".format(score))


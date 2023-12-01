"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-21

**Project** : advent code

**Code corresponding to day 21**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load() -> tuple:
    """
    Load data

    :return: Data formatted as dictionnary (keys allergens,
    values list of sets of ingredients), List of list of ingredients,
    List of list of allergens
    """
    with (DATAPATH / '21.txt').open('r') as handle:
        data = {}
        ingredient_list = []
        allergen_list = []
        for line in handle.readlines():
            ingredients, allergens = line[:-2].split(' (contains ')
            ingredients = ingredients.split(' ')
            allergens = allergens.split(', ')
            for key in allergens:
                if not key in data.keys():
                    data[key] = []
                data[key].append(set(ingredients))
            ingredient_list.append(ingredients)
            allergen_list.append(allergens)
    return data, ingredient_list, allergen_list


def get_all_ingredients(data: dict) -> set:
    """
    Get all the ingredients

    :param data: Data formatted as dictionnary (keys allergens, values
    list of sets of ingredients)
    :return: Set containing all the possible ingredients
    """
    output = set()
    for key, value in data.items():
        for item in value:
            output = output.union(item)
    return output


def get_possible_ingredients_per_allergen(data: dict) -> dict:
    """
    Get all the ingredients that can contain an allergen

    :param data: Data formatted as dictionnary (keys allergens, values
    list of sets of ingredients)
    :return: Dictionnary of the allergens and their possible associated
    allergens
    """
    output = {}
    for key, value in data.items():
        output[key] = value[0]
        for item in value[1:]:
            output[key] = output[key].intersection(item)
    return output


def get_possible_ingredients(data: dict) -> set:
    """
    Get the possible ingredients from a dictionnary of possible
    ingredients per allergens

    :param data: Data formatted as dictionnary (keys allergens, values
    sets of possible ingredients)
    :return: The set of possible ingredients
    """
    output = set()
    for key, value in data.items():
        output = output.union(value)
    return output


def get_number_apparitions(ingredient_list: list, ingredients: set) -> int:
    """
    Get the number of apparitions of a given set of ingredients in
    a list of list of ingredients

    :param ingredient_list: List of list of ingredients
    :param ingredients: Set of ingredients
    :return: Number of apparitions
    """
    number = 0
    for article_ingredients in ingredient_list:
        for ingredient in article_ingredients:
            if ingredient in ingredients:
                number += 1
    return number


def get_pairing(reduced_data: dict) -> list:
    """
    Get the pairing of allergens ingredients in alphabetical
    order of allergens

    :param reduced_data: Data formatted as dictionnary (keys allergens, values
    sets of possible ingredients)
    :return: List of tuple of allergens and ingredients
    """
    pairing = []
    # Loop while all the allergens and ingredients are paired
    while len(reduced_data.keys()) != 0:

        # Find pairing
        for key, value in reduced_data.items():
            if len(value) == 1:
                key_, value_ = key, value

        # Update remaining ingredients and allergens
        pairing.append((key_, list(value_)[0]))
        reduced_data.pop(key_)
        for key_ in reduced_data.keys():
            reduced_data[key_] = reduced_data[key_].difference(value_)
    pairing.sort()
    return pairing


if __name__ == '__main__':
    # Part one
    data, ingredient_list, allergen_list = load()
    all_ingredients = get_all_ingredients(data)
    all_possible_ingredients = get_possible_ingredients(
            get_possible_ingredients_per_allergen(data)
            )
    all_impossible_ingredients = all_ingredients.difference(
            all_possible_ingredients
            )
    number = get_number_apparitions(ingredient_list, all_impossible_ingredients)
    print(
            "The number of apparition of impossible ingredients is {}".format(
                number
                )
            )

    # Part two
    data, ingredient_list, allergen_list = load()
    reduced_data = get_possible_ingredients_per_allergen(data)
    pairing = get_pairing(reduced_data)
    dangerous_list = ','.join([item for _, item in pairing])
    print("The dangerous list is {}".format(dangerous_list))


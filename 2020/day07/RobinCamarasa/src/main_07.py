"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-07

**Project** : advent code

**Code corresponding to day 07**

"""
import numpy as np
from pathlib import Path
import networkx as nx
import matplotlib.pyplot as plt
from networkx.drawing.nx_pydot import graphviz_layout


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'
RESULTPATH = ROOTPATH / 'results'


def load():
    """
    Load data

    :return: Loaded data
    """
    with (DATAPATH / '07.txt').open('r') as handle:
        lines = handle.readlines()
    return [line[:-1] for line in lines]


def parse_input(data: list) -> dict:
    """
    Parse input data

    :param data: input data
    (ex: ['shiny gold bags contain no other bag', 'dark red bags contain 1 shiny gold bag'])
    :return: The rules structured in a dictionnary
    (ex: {'shiny gold': None, 'dark red': {'shiny gold': 1}})
    """
    rules = {}
    for line in data:
        container_bag, contained_bags = line.split(' contain ')
        container_bag = container_bag.split(' bags')[0]
        contained = {}
        if not 'no other bag' in contained_bags:
            for item in contained_bags[:-1].split(', '):
                key = ' '.join(item.split(' ')[1:]).split('bag')[0][:-1]
                value = int(item.split(' ')[0])
                contained[key] = value
        rules[container_bag] = contained
    return rules

def to_graph(rules: dict) -> nx.DiGraph:
    """
    Transform the dictionnay into a graph

    :param rules: Dictionnary of the airport's bags requirement
    (ex: {'shiny gold': {'shiny bronze': 4, 'dark red': 3}})
    :return: A directed graph where the nodes are the bags, the edges
    the number of bags that can be contained
    (ex: A -4-> B means that 4 bags of color A are contained in B)
    """
    G = nx.DiGraph()
    edges = []
    weights = []
    for key_child, value in rules.items():
        for key_parent, weight in value.items():
            edges.append((key_parent, key_child))
            weights.append(weight)
    for edge, weight in zip(edges, weights):
        G.add_edge(*edge, weight=weight)
    return G


def plot_graph(G: nx.DiGraph) -> None:
    """
    Plot the graph with labels
    """
    plt.figure(figsize=(100, 100))
    pos = nx.spring_layout(G)
    nx.draw(G, pos, with_labels=True)
    plt.savefig(RESULTPATH / 'bag_relationship.png')


def get_number_bags(rules: dict, node: str) -> int:
    """
    Get the number of bags contained in a bag of color node

    :param rules: Dictionnary of the airport's bags requirement
    :param node: Node that contains the color of the bag under study
    :return: Number of bag contained in a bag of color Node
    """
    if len(rules[node].keys()) == 0:
        return 0
    result = 0
    for key, weight in rules[node].items():
        result += weight * (get_number_bags(rules, key) + 1)
    return result


if __name__ == '__main__':
    data = load()
    rules = parse_input(data)

    # Part one
    G = to_graph(rules)
    print(
            'Number of bags that can contain a shiny gold bag: {}'.format(
                len({n for n in nx.dfs_preorder_nodes(G, 'shiny gold')}) - 1
                )
            )
    print('Plot graph')
    plot_graph(G)

    # Part two
    print(
            'Number of bags contained in a shiny gold bag: {}'.format(
                get_number_bags(rules, 'shiny gold')
                )
            )

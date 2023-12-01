"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-20

**Project** : advent code

**Code corresponding to day 20**

"""
import numpy as np
from pathlib import Path
from itertools import product
import matplotlib.pyplot as plt
from scipy import ndimage


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load_monster() -> np.array:
    """
    Load monster

    :return: Mask representing a sea monster
    """
    with (DATAPATH / 'monster.txt').open('r') as handle:
        data = handle.read()[:-1]
        data = data.replace(' ', '0').replace('#', '1')
    return np.array([[int(c) for c in item]for item in data.split('\n')])


def load() -> tuple:
    """
    Load data

    :return: Tile numbers and images
    """
    with (DATAPATH / '20.txt').open('r') as handle:
        raw_data = handle.read()
        raw_data = raw_data.replace('.', '0').replace('#', '1')
    raw_data = raw_data[:-1].split('\n\n')
    tile_numbers, images = [], []
    for raw_data_ in raw_data:
        raw_data_
        splitted_raw_data_ = raw_data_.split('\n')
        tile_numbers.append(
                int(splitted_raw_data_[0].split(' ')[-1].split(':')[0])
                )
        image = np.array(
                [
                    np.array([
                        int(item_)
                        for item_ in item
                        ])
                    for item in splitted_raw_data_[1:]
                    ]
                )
        images.append(image)
    return tile_numbers, images


def flip_x_image(image: np.array) -> np.array:
    """
    Flip image along x axis

    :param image: 2D image
    :return: Flipped image
    """
    return image[:, ::-1]

def flip_y_image(image: np.array) -> np.array:
    """
    Flip image along y axis

    :param image: 2D image
    :return: Flipped image
    """
    return image[::-1, :]


def rotate_clockwise_image(image):
    """
    Rotate clockwise the image

    :param image: 2D image
    :return: Rotated image
    """
    return np.rot90(image, k=3)


def get_all_possible_images(image: np.array) -> tuple:
    """
    Get all possible images and borders from the image

    :param image: 2D image
    :return: All the possible images and their associated borders
    """
    # Initialize output
    possibilities = []
    borders = []
    to_bin = lambda x:int(
            ''.join([str(i) for i in x.tolist()]), 2
            )

    # Loop over the possibilities
    for x, y, clock in product(
            [True, False],
            [True, False],
            range(4)
            ):
        image_ = np.copy(image)
        if x:
            image_ = flip_x_image(image_)
        if y:
            image_ = flip_y_image(image_)
        for i in range(clock):
            image_ = rotate_clockwise_image(image_)
        possibilities.append(
                image_[1:-1, 1:-1]
                )
        borders.append(
                [
                    to_bin(image_[0, :]),
                    to_bin(image_[-1, :]),
                    to_bin(image_[:, 0]),
                    to_bin(image_[:, -1]),
                    ]
                )
    return possibilities, np.array(borders)


def get_possible_adjacencies(possible_borders: list) -> np.array:
    """
    Get the matrix of adjacencies

    :param possible_borders: List of the possible borders
    :return: The adjacency matrix
    """
    # Initialise the adjacency matrix
    adjacency_matrix = -np.eye(len(possible_borders), len(possible_borders))
    for i, possible_border_1 in enumerate(possible_borders):
        for j, possible_border_2 in enumerate(possible_borders):
            possible_values_1 = set(possible_border_1[:, 0].tolist())
            possible_values_2 = set(
                    possible_border_2[:, 0].tolist()
                    )
            # Create a link if two images can share a border
            if len(possible_values_2.intersection(possible_values_1)) != 0:
                adjacency_matrix[i, j] += 1
    return adjacency_matrix


def get_neighbors(
        index: int, adjacency_matrix: np.array
        ) -> list:
    """
    Get the neighbors of a given index

    :param index: Index of the matrix
    :param adjacency_matrix: Matrix of adjacency
    :return: The list of the neighbors of a given index
    """
    return np.where(
            adjacency_matrix[index, :] == 1
            )[0].tolist()


def get_tiles_possitions(adjacency_matrix: np.array) -> np.array:
    """
    Get tiles positions

    :param adjacency_matrix: Matrix of adjacency of the images
    """
    # Else apply recurrency
    n = int(np.sqrt(adjacency_matrix.shape[0]))
    grid = np.zeros((n, n), dtype=int)
    corners = np.where(np.sum(adjacency_matrix, axis=0) == 2)[0].tolist()
    edges = np.where(np.sum(adjacency_matrix, axis=0) == 3)[0].tolist()

    # Place top left corner
    placed = [corners[0]]
    grid[0, 0] = corners[0]

    # Place first row and first colum edges
    for i in range(1, n-1):
        neighbors = get_neighbors(grid[0, i - 1], adjacency_matrix)
        possibilities = list(
                set(neighbors).intersection(set(edges))
                )
        for possibility in possibilities:
            if not possibility in placed:
                grid[0, i] = possibility
                placed.append(possibility)
                break
        neighbors = get_neighbors(grid[i - 1, 0], adjacency_matrix)
        possibilities = list(
                set(neighbors).intersection(set(edges))
                )
        for possibility in possibilities:
            if not possibility in placed:
                grid[i, 0] = possibility
                placed.append(possibility)
                break

    # Place corners except right bottom corner
    neighbors = get_neighbors(
            grid[0, -2], adjacency_matrix
            )
    grid[0, -1] = list(set(neighbors).intersection(set(corners)))[0]
    placed.append(grid[0, -1])
    neighbors = get_neighbors(
            grid[-2, 0], adjacency_matrix
            )
    grid[-1, 0] = list(set(neighbors).intersection(set(corners)))[0]
    placed.append(grid[-1, 0])

    # Place the other tiles
    for i in range(1, n):
        for j in range(1, n):
            up_neighbors = get_neighbors(grid[i - 1, j], adjacency_matrix)
            left_neigbors = get_neighbors(grid[i, j - 1], adjacency_matrix)
            possibilities = list(set(up_neighbors).intersection(set(left_neigbors)))
            for possibility in possibilities:
                if not possibility in placed:
                    grid[i, j] = possibility
                    placed.append(possibility)
    return grid


def get_image_match(
        index, possible_images, possible_borders,
        up_=None, down_=None, left_=None, right_=None
        ):
    """
    Get the image that match the constraints

    :param index: Index of the image
    :param possible_images: List of list of the possible images
    :param up_: Constraint on the up size (None mean no constraint)
    :param down_: Constraint on the down size (None mean no constraint)
    :param left_: Constraint on the left size (None mean no constraint)
    :param right_: Constraint on the right size (None mean no constraint)
    """
    for i, border in enumerate(possible_borders[index]):
        is_border = True
        if up_ != None:
            is_border = is_border and\
                    border[0] in set(possible_borders[up_][:, 0].tolist())
        if down_ != None:
            is_border = is_border and\
                    border[1] in set(possible_borders[down_][:, 0].tolist())
        if left_ != None:
            is_border = is_border and\
                    border[2] in set(possible_borders[left_][:, 0].tolist())
        if right_ != None:
            is_border = is_border and\
                    border[3] in set(possible_borders[right_][:, 0].tolist())
        if is_border:
            return possible_images[index][i]


def get_full_image(
        possible_borders: list, possible_images: list,
        tile_position: list
        ) -> np.array:
    """
    Get the full image

    :param possible_borders: List of list of the possible border for each image
    :param possible_images: List of list of the possible images
    :param tile_position: Position of the tiles in the image
    :return: Full image
    """
    # Initialize the output
    full_image = np.zeros((12 * 8, 12 * 8))

    # Place first corner
    full_image[:8, :8] = get_image_match(
            tile_position[0, 0], possible_images, possible_borders,
            right_=tile_position[0, 1],
            down_=tile_position[1, 0],
            )

    # Place first rows and columns
    for i in range(1, 12):
        full_image[:8, i * 8:(i + 1) * 8] = get_image_match(
                tile_position[0, i], possible_images, possible_borders,
                left_=tile_position[0, i-1],
                down_=tile_position[1, i],
                )
        full_image[i * 8:(i + 1) * 8, :8] = get_image_match(
                tile_position[i, 0], possible_images, possible_borders,
                up_=tile_position[i-1, 0],
                right_=tile_position[i, 1],
                )

    # Fill the whole image
    for i in range(1, 12):
        for j in range(1, 12):
            full_image[i * 8:(i + 1) * 8, j * 8:(j+1) * 8] = get_image_match(
                    tile_position[i, j], possible_images, possible_borders,
                    up_=tile_position[i-1, j],
                    left_=tile_position[i, j-1],
                    )
    return full_image


def get_water_roughness(full_image: np.array, monster: np.array) -> int:
    """
    Get the water roughness

    :param full_image: Full image
    :param monster: Convolutional mask representing a sea monster
    :return: Number of monsters present in the image
    """
    k = np.sum(monster)
    for x, y, clock in product(
            [True, False],
            [True, False],
            range(4)
            ):
        full_image_ = np.copy(full_image)
        if x:
            full_image_ = flip_x_image(full_image_)
        if y:
            full_image_ = flip_y_image(full_image_)
        for i in range(clock):
            full_image_ = np.rot90(full_image_)

        # Applying the convolutional monster mask the voxel having the
        # exact amount of non null voxels in the monster mask are monsters
        nb_monster = (ndimage.convolve(
                full_image_, monster, mode='constant', cval=0.0
                ) == k).sum()
        if nb_monster != 0:
            return int(np.sum(full_image) - k * nb_monster)


if __name__ == '__main__':
    # Part one
    tile_numbers, images = load()
    possible_borders = [
            get_all_possible_images(image)[1]
            for image in images
            ]
    adjacency_matrix = get_possible_adjacencies(possible_borders)
    product_ = 1
    for i, tile_number in enumerate(tile_numbers):
        if np.sum(adjacency_matrix[:, i]) == 2:
            product_ *= tile_number
    print('Product of the angles is {}'.format(product_))

    # Part two

    # Get full image
    tile_position = get_tiles_possitions(adjacency_matrix)
    possible_images = [
            get_all_possible_images(image)[0]
            for image in images
            ]
    full_image = get_full_image(possible_borders, possible_images, tile_position)

    # Load monster
    monster = load_monster()
    water_roughness = get_water_roughness(full_image, monster)
    print("The water roughness is {}".format(water_roughness))


"""
**Author** : Robin Camarasa

**Institution** : Erasmus Medical Center

**Position** : PhD student

**Contact** : r.camarasa@erasmusmc.nl

**Date** : 2020-12-14

**Project** : advent code

**Code corresponding to day 14**

"""
import numpy as np
from pathlib import Path


ROOTPATH = Path(__file__).parents[1]
DATAPATH = ROOTPATH / 'data'


def load(part:int = 1) -> object:
    """
    Load data. Data loading is different for efficiency
    reasons the return type is different for part one (dict)
    and part two (list). Sorry for the ugly solution

    :param part: Part of the problem you want to solve
    :return: Loaded data
    (ex part one: {5: ('10001X100011100', '0b1010')})
    (ex part two: [('10001X100011100', 18, '0b101')])
    """
    with (DATAPATH / '14.txt').open('r') as handle:
        output = {} if part == 1 else []
        mask = None
        for line in handle.readlines():
            if 'mask' in line:
                mask = line[:-1].split(' = ')[-1]
            elif 'mem' in line:
                if part == 1:
                    number = int(float(line.split('[')[1].split(']')[0]))
                    value = bin(int(line[:-1].split(' = ')[-1]))
                    output[number] = (mask, value)
                else:
                    address = bin(int(float(line.split('[')[1].split(']')[0])))
                    value = int(line[:-1].split(' = ')[-1])
                    output.append((mask, value, address))
    return output


def apply_mask(mask: str, value: int) -> str:
    """
    Apply mask as described in the first part

    :param mask: Mask to apply to the value
    :param value: Value on which mask is applied
    :return: String of '1' and '0' corresponding to the masked value
    """
    bin_value = (len(mask) * '0')[:-len(str(value[2:]))]
    bin_value += str(value[2:])
    result = ''
    for i, (mask_, bin_value_) in enumerate(zip(mask, bin_value)):
        if mask_ == 'X':
            result += bin_value_
        else:
            result += mask_
    return result


def update_memory(current_memory, mask: str, value: int, address: int) -> dict:
    """
    Update the current memory with the given instruction in a memory decoder
    setting

    :param mask: Mask to apply to the value
    :param value: Value that will be copied in the required addresses
    :param address: Binary address to apply the mask to
    :return: The updated memory
    """
    bin_address = (len(mask) * '0')[:-len(str(address[2:]))]
    bin_address += str(address[2:])
    result = ''
    for i, (mask_, bin_address_) in enumerate(zip(mask, bin_address)):
        if mask_ == 'X':
            result += 'X'
        elif mask_ == '0':
            result += bin_address_
        else:
            result += '1'
    for address in get_addresses(result):
        current_memory[address] = value
    return current_memory


def get_addresses(address: str) -> list:
    """
    Generate all the possible addresses from an address with 'X'

    :return: The list of possible addresses
    """
    if 'X' in address:
        return get_addresses(
                address.replace('X', '1', 1)
                ) + get_addresses(
                address.replace('X', '0', 1)
                )
    return [int(address, 2)]


if __name__ == '__main__':
    # Part one
    data = load()
    masked_applied_values = {
            key: int(apply_mask(*value), 2)
            for key, value in data.items()
            }
    result = np.array([value for value in masked_applied_values.values()]).sum()
    print(
            'The sum of the values in memory for the part one is : {}'.format(
                result
                )
            )

    # Part two
    data = load(part=2)

    # Update memory after each instruction
    current_memory = {}
    for instruction in data:
        current_memory = update_memory(current_memory, *instruction)
    result = np.array([value for value in current_memory.values()]).sum()
    print(
            'The sum of the values in memory for the part two is : {}'.format(
                result
                )
            )


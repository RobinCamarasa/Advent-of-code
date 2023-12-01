use std::fs;

use std::collections::HashSet;
use std::collections::HashMap;


fn main() {
    let contents = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day03/input.txt")
        .expect("Should have been written");
    let total: i32 = rucksack_part_1(contents);
    println!("total: {total}");

    let contents = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day03/input.txt")
        .expect("Should have been written");
    let total: i32 = rucksack_part_2(contents);
    println!("total: {total}");
}


fn get_mapping() -> HashMap::<char, i32> {
    let mut mapping: HashMap::<char, i32> = Default::default(); 

    for (i, letter) in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().enumerate(){
        let value: i32 = i.try_into().unwrap();
        mapping.insert(letter, value + 1);
    }

    return mapping
} 


fn rucksack_part_1(contents: String) -> i32{
    let mapping: HashMap::<char, i32> = get_mapping();
    let mut total: i32 = 0;

    for element in contents.split('\n'){
        if element.len() > 0{
            let first_half: HashSet<char> = HashSet::from_iter((&element[..(element.len() / 2)]).chars());
            let second_half: HashSet<char> = HashSet::from_iter((&element[(element.len() / 2)..]).chars());

            let intersection = first_half.intersection(&second_half).last().expect("Should not be empty");
            total += mapping[intersection];
        }
    }
    return total
}


fn rucksack_part_2(contents: String) -> i32{
    let mapping: HashMap::<char, i32> = get_mapping();

    let mut total: i32 = 0;
    let mut acc_hash_set: Vec<HashSet<char>> = Vec::new();

    for (i, element) in contents.split('\n').enumerate(){
        if i % 3 == 0 {
            acc_hash_set = Vec::new();
        } 

        acc_hash_set.push(HashSet::from_iter(element.chars()));

        if i % 3 == 2 {
            let intersection: char = acc_hash_set.iter()
                .skip(1)
                .fold(acc_hash_set[0].clone(), |acc, hs| {
                    acc.intersection(hs).cloned().collect()
                }).iter().next().unwrap().clone();
            total += mapping[&intersection];
        }
    }
    return total
}

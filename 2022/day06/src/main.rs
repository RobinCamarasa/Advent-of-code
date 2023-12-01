use std::fs;
use std::collections::HashSet;
use std::iter::FromIterator;


fn main() {
    let content: String = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day06/input.txt").expect("Should exist");
    println!("Solution 1: {}", get_start(content.clone().chars().collect(), 4));
    println!("Solution 2: {}", get_start(content.clone().chars().collect(), 14));
}

fn get_start(content: Vec<char>, nb_identical: usize) -> usize{
    for i in nb_identical .. (content.len()) {
        let set: HashSet<char> = HashSet::from_iter(content[(i - nb_identical)..i]
                .iter()
                .cloned());
        if set.len() == nb_identical{
            return i;
        }
    }
    return 0;
}

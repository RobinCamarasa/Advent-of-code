use std::fs;


fn main() {
    let contents: String = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day01/input.txt")
        .expect("Should have been able to read the file");
    let maximum: i32 = max_elves(contents);
    println!("Max elves: {maximum}");

    let contents: String = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day01/input.txt")
        .expect("Should have been able to read the file");
    let maximum_3_elves: i32 = max_3_elves(contents);
    println!("Max 3 elves: {maximum_3_elves}");
}

fn max_elves(contents: String) -> i32 {
    let mut maximum: i32 = 0;
    let mut acc: i32 = 0;

    for element in contents.split("\n") {
        if element.len() == 0 {
            if acc > maximum {
                maximum = acc;
            }
            acc = 0;
        } else {
            let value: i32 = element.parse().expect("Not a number!");
            acc = acc + value;
        }
    }
    return maximum;
}

fn max_3_elves(contents: String) -> i32 {
    let mut max_1: i32 = 0;
    let mut max_2: i32 = 0;
    let mut max_3: i32 = 0;
    let mut acc: i32 = 0;

    // Get array size
    for element in contents.split("\n") {
        if element.len() == 0 {
            if acc > max_1 {
                max_3 = max_2;
                max_2 = max_1;
                max_1 = acc;
            } else if acc > max_2 {
                max_3 = max_2;
                max_2 = acc;
            } else if acc >= max_3 {
                max_3 = acc;
            }
            acc = 0;
        } else {
            let value: i32 = element.parse().expect("Not a number!");
            acc = acc + value;
        }
    }
    return max_1 + max_2 + max_3;
}


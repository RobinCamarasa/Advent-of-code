use std::fs;
use std::cmp;


fn main() {
    let contents: Vec<Vec<i32>> = parse(
        fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day04/input.txt").expect("Should exist")
    );
    let total: i32 = get_fully_contained(contents);
    println!("total: {total}");

    let contents: Vec<Vec<i32>> = parse(
        fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day04/input.txt").expect("Should exist")
    );
    let total: i32 = get_overlap(contents);
    println!("total: {total}");
}


fn parse(contents: String) -> Vec<Vec<i32>> {
    let mut output: Vec<Vec<i32>> = Vec::new();
    for element in contents.split("\n") {
        if element.len() != 0{
            output.push(
                element.replace(",", "-").split("-").map(|s| s.to_string().parse::<i32>().unwrap()).collect()
            );
        }
    }
    return output;
}

fn get_fully_contained(parsed_content: Vec<Vec<i32>>) -> i32 {
    let mut total = 0;
    for line in parsed_content{
        if (line[2] - line[0]) * (line[1] - line[3]) >= 0{
            total += 1;
        }
    }
    return total;
}

fn get_overlap(parsed_content: Vec<Vec<i32>>) -> i32 {
    let mut total = 0;
    for line in parsed_content{
        if cmp::max(line[2], line[0]) <= cmp::min(line[1], line[3]){
            total += 1;
        }
    }
    return total;
}

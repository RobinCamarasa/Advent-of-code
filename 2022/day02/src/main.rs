use std::fs;


fn main() {
    let mut total: i32 = 0;

    let contents = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day02/input.txt")
        .expect("Should have been able to read the file");
    total = eval(contents, true);
    println!("total: {total}");

    let contents = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day02/input.txt")
        .expect("Should have been able to read the file");
    total = eval(contents, false);
    println!("total: {total}");
}

fn parse(round: &str) -> (i32, i32){
    let mut opponent: i32 = 0;
    let mut you: i32 = 0;

    if round.chars().nth(0).expect("empty") == 'A'{
        opponent = 1;
    } else if round.chars().nth(0).expect("empty") == 'B' {
        opponent = 2;
    } else if round.chars().nth(0).expect("empty") == 'C' {
        opponent = 3;
    }

    if round.chars().nth(2).expect("empty") == 'X'{
        you = 1;
    } else if round.chars().nth(2).expect("empty") == 'Y' {
        you = 2;
    } else if round.chars().nth(2).expect("empty") == 'Z' {
        you = 3;
    }
    return (opponent, you);
}

fn parse_loose(round: &str) -> (i32, i32){
    let mut opponent: i32 = 0;
    let mut you: i32 = 0;

    if round.chars().nth(0).expect("empty") == 'A'{
        opponent = 1;
    } else if round.chars().nth(0).expect("empty") == 'B' {
        opponent = 2;
    } else if round.chars().nth(0).expect("empty") == 'C' {
        opponent = 3;
    }

    if round.chars().nth(2).expect("empty") == 'X'{
        you = -1;
    } else if round.chars().nth(2).expect("empty") == 'Y' {
        you = 0;
    } else if round.chars().nth(2).expect("empty") == 'Z' {
        you = 1;
    }
    you = ((opponent + you + 6 - 1) % 3) + 1; // the + 6 is to avoid negative cases
    return (opponent, you);
}

fn eval(contents: String, is_first_strategy: bool) -> i32 {
    let (mut opponent, mut you): (i32, i32) = (0, 0);
    let mut diff: i32 = 0;
    let mut total: i32 = 0;

    for element in contents.split("\n"){
        if element.len() == 3{
            if is_first_strategy{
                (opponent, you) = parse(element);
            } else {
                (opponent, you) = parse_loose(element);
            }
            diff = (you - opponent + 6) % 3; // the + 6 is to avoid negative cases
            if diff == 2{
                total += you;
            } else if diff == 1{
                total += you + 6;
            } else {
                total += you + 3;
            }
        }
    }
    return total;
}

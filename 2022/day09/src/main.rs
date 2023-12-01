use std::fs;
use std::collections::{HashMap, HashSet};
use std::iter::FromIterator;


fn parse(content: &str) -> Vec<(i32, i32)>{
    let mut parsed_content: Vec<(i32, i32)> = Vec::new();
    let mut direction;
    let mut nb_iterations;
    let directions = HashMap::from([
        ('U', (0, 1)),
        ('D', (0, -1)),
        ('R', (1, 0)),
        ('L', (-1, 0))
    ]);
    for element in content.split("\n"){
        if element.len() != 0{
            direction = directions[&element.clone().chars().nth(0).expect("Should exist")];
            nb_iterations = element.clone()[2..].parse::<i32>().unwrap();
            for _ in 0..nb_iterations{
                parsed_content.push((direction.0, direction.1));
            }
        }
    }
    return parsed_content;
}

fn get_squared_norm(head_position: &(i32, i32), tail_position: &(i32, i32)) -> i32{
    (head_position.0 - tail_position.0).pow(2) + (head_position.1 - tail_position.1).pow(2)
}

fn movement_along_direction(x: i32) -> i32{
    match x {
        0 => 0,
        v @ _ => v / v.abs()
    }
}

fn update_direction(head_position: &(i32, i32), tail_position: &mut (i32, i32)){
    let squared_norm = get_squared_norm(&head_position, &tail_position);
    if squared_norm < 4_i32{
        return;
    }
    let direction: (i32, i32) = (
        movement_along_direction(head_position.0 - tail_position.0),
        movement_along_direction(head_position.1 - tail_position.1)
    );
    tail_position.0 += direction.0;
    tail_position.1 += direction.1;
    update_direction(&head_position, tail_position);
}

fn get_n_knots_tail_positions(parsed_content: &Vec<(i32, i32)>, n: i32) -> (Vec<(i32, i32)>, Vec<(i32, i32)>){
    let mut tail_positions: Vec<(i32, i32)> = [(0, 0)].to_vec();
    let mut head_positions: Vec<(i32, i32)> = [(0, 0)].to_vec();

    let mut knots_positions: Vec<(i32, i32)> = Vec::new();
    for _ in 0..n{
        knots_positions.push((0, 0));
    }

    for direction in parsed_content{
        knots_positions[0] = (knots_positions[0].0 + direction.0, knots_positions[0].1 + direction.1);
        for i in 1..n{
            update_direction(&(knots_positions.clone()[(i - 1) as usize]), &mut (knots_positions[i as usize]));
        }
        head_positions.push((knots_positions[0]).clone());
        tail_positions.push((knots_positions[(n - 1) as usize]).clone());
    }
    return (head_positions, tail_positions);
}

fn get_visited_positions(parsed_content: &Vec<(i32, i32)>, n: i32) -> usize{
    return HashSet::<(i32, i32)>::from_iter(get_n_knots_tail_positions(parsed_content, n).1).len();
}

fn main() {
    let content = fs::read_to_string(
        "/home/tuchekaki/documents/gitlab/advent-of-code/2022/day09/input.txt"
    ).expect("File exist");
    let parsed_content = parse(&content);
    println!("Number of visited positions: {}", get_visited_positions(&parsed_content, 2));
    println!("Number of visited positions: {}", get_visited_positions(&parsed_content, 10));
}

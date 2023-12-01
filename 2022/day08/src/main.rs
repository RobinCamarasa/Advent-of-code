use std::fs;
use std::ops::Range;
use std::iter::Rev;

use either::*;


fn parse(content: &str) -> (Vec<Vec<i32>>, Vec<Vec<i32>>){
    let mut grid: Vec<Vec<i32>> = Vec::new();
    let mut mask: Vec<Vec<i32>> = Vec::new();
    for (j, line) in content.split("\n").enumerate(){
        if line.len() > 0{
            let mut line_vec: Vec<i32> = Vec::new();
            let mut line_mask_vec: Vec<i32> = Vec::new();
            for (i, character) in line.chars().enumerate(){
                line_vec.push(character as i32 - '0' as i32);
                if i * j == 0 || i == line.len() - 1 || j == line.len() - 1{
                    line_mask_vec.push(1);
                }
                else{
                    line_mask_vec.push(0);
                }
            }
            grid.push(line_vec);
            mask.push(line_mask_vec);
        }
    }
    return (grid, mask);
}

fn update_mask(grid: &Vec<Vec<i32>>, mask: &mut Vec<Vec<i32>>, direction: (i32, i32)) {
    let size: i32 = grid.len() as i32;
    let masked_direction: (i32, i32) = (direction.0 * direction.0, direction.1 * direction.1);

    let range: Either<Range<i32>, Rev<Range<i32>>> = match direction.0 + direction.1 {
        1 => Left(1..size - 1),
        -1 => Right((1..size - 1).rev()),
        i32::MIN..=-2_i32 | 0_i32 | 2_i32..=i32::MAX => todo!(),
    };

    let start: i32 = match direction.0 + direction.1 {
        1 => 0,
        -1 => size - 1,
        i32::MIN..=-2_i32 | 0_i32 | 2_i32..=i32::MAX => todo!(),
    };

    // Initialize maximum
    let mut maximum = Vec::new();
    for t in 0..size{
        let (grid_i, grid_j): (usize, usize) =  (
            (start * masked_direction.0 + t * (1 - masked_direction.0)) as usize,
            (start * masked_direction.1 + t * (1 - masked_direction.1)) as usize,
        );
        maximum.push(grid[grid_i][grid_j]);
    }

    // Update along direction
    for p in range.clone(){
        for t in range.clone(){
            let (grid_i, grid_j): (usize, usize) =  (
                (t * (1 - masked_direction.0) + p * masked_direction.0) as usize,
                (t * (1 - masked_direction.1) + p * masked_direction.1) as usize
            );
            if maximum[t as usize] < grid[grid_i][grid_j]{
                maximum[t as usize] = grid[grid_i][grid_j];
                mask[grid_i][grid_j] += 1;
            } else {
            }
        }
    }
}

fn count_visible_tree(mask: &Vec<Vec<i32>>) -> i32{
    let size: usize = mask.len();
    let mut visible_tree: i32 = 0;
    for i in 0..size{
        for j in 0..size{
            if mask[i][j] > 0{
                visible_tree += 1;
            }
        }
    }
    return visible_tree;
}

fn get_number_visible_trees(grid: &Vec<Vec<i32>>, mask: &mut Vec<Vec<i32>>) -> i32{
    for direction in [(0, 1), (0, -1), (1, 0), (-1, 0)]{
        update_mask(&grid, mask, direction);
    }
    return count_visible_tree(&mask);
}

fn compute_scenic_score(grid: &Vec<Vec<i32>>, (i, j): (usize, usize)) -> i32{
    let mut scenic_score: i32 = 1;
    let mut direction_score: i32 = 1;
    for direction in [(0, 1), (0, -1), (1, 0), (-1, 0)]{
        for step in 1..(grid.len() - 1){
            direction_score = step as i32;
            let (ii, jj): (i32, i32) = (
                i as i32 + step as i32 * direction.0,
                j as i32 + step as i32 * direction.1
            );
            if ii < 0 || ii >= grid.len() as i32 || jj < 0 || jj >= grid.len() as i32 {
                direction_score -= 1;
                break;
            }
            else if grid[ii as usize][jj as usize] >= grid[i][j]{
                break;
            }
        }
        scenic_score *= direction_score;
    }
    return scenic_score;
}

fn compute_highest_scenic_score(grid: &Vec<Vec<i32>>) -> i32{
    let mut highest_scenic_score: i32 = 0;
    for i in 1..(grid.len() - 1){
        for j in 1..(grid.len() - 1){
            let scenic_score = compute_scenic_score(&grid, (i, j));
            if scenic_score > highest_scenic_score{
                highest_scenic_score = scenic_score;
            }
        }
    }
    return highest_scenic_score;
}


fn main() {
    let content = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day08/input.txt").expect("Should exist");
    let (grid, mut mask) = parse(&content);
    println!("Visible trees: {}", get_number_visible_trees(&grid, &mut mask));
    println!("Highest scenic score: {}", compute_highest_scenic_score(&grid));
}

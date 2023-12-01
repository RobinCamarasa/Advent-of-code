use std::fs;

fn parse_instructions(content: &str) -> Vec<i32>{
    let mut instructions: Vec<i32> = Vec::new();
    for line in content.split("\n"){
        if line.len() != 0{
            if line.chars().nth(0).expect("Should exist") == 'a'{
                instructions.push(
                    line.clone()
                        .split(" ")
                        .nth(1)
                        .expect("Should exist")
                        .parse::<i32>()
                        .unwrap()
                );
            }
            if line.chars().nth(0).expect("Should exist") == 'n'{
                instructions.push(i32::MIN);
            }
        }
    }
    return instructions;
}

fn get_register_values(instructions: &Vec<i32>) -> Vec<i32>{
    let mut register_values: Vec<i32> = Vec::new();
    let mut register = 1;

    register_values.push(register);

    for instruction in instructions{
        if *instruction == i32::MIN{
            register_values.push(register);
        } else {
            register_values.push(register);
            register_values.push(register);
            register += *instruction; 
        }
    }
    register_values.push(register);
    return register_values;
}

fn get_signal_strengths_sum(register_values: &Vec<i32>, clock_cycles: &Vec<i32>) -> i32{
    let mut sum = 0;
    for clock_cycle in clock_cycles{
        sum += clock_cycle * register_values[*clock_cycle as usize];
    }
    return sum;
}

fn get_crt(register_values: &Vec<i32>) -> String{
    let mut acc = String::from("");
    for (i, register_value) in register_values.into_iter().enumerate(){
        if i > 0{
            match (i as i32) % 40 - *register_value  {
                0..=2 => acc.push('#'),
                _ => acc.push(' ')
            };
            if i % 40 == 0{
                acc.push('\n');
            }
        }
    }
    return acc;
}

fn main() {
    let content = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day10/input.txt").expect("File should exist");
    let instructions = parse_instructions(&content);
    let register_values = get_register_values(&instructions);
    println!("Sum of clock cycles: {}", get_signal_strengths_sum(&register_values, &[20, 60, 100, 140, 180, 220].to_vec()));
    println!("{}", get_crt(&register_values));
}

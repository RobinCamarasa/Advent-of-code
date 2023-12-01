use std::fs;


fn main() {
    let path: &str = "/home/tuchekaki/documents/gitlab/advent-of-code/2022/day05/input.txt";
    let (mut stacks,  instructions): (Vec<Vec<char>>, Vec<Vec<usize>>) = parse(path);
    stacks = apply_instructions(stacks, instructions, 9000);
    println!("Solution 1: {}", get_top(stacks));

    let path: &str = "/home/tuchekaki/documents/gitlab/advent-of-code/2022/day05/input.txt";
    let (mut stacks,  instructions): (Vec<Vec<char>>, Vec<Vec<usize>>) = parse(path);
    stacks = apply_instructions(stacks, instructions, 9001);
    println!("Solution 2: {}", get_top(stacks));
}

fn parse(path: &str) -> (Vec<Vec<char>>, Vec<Vec<usize>>){
    let content: String = fs::read_to_string(path).expect("Should exist");
    let mut stacks: Vec<Vec<char>> = Vec::new();
    let mut instructions: Vec<Vec<usize>> = Vec::new();

    // Parse stacks
    for element in content.split("\n"){
        for _ in stacks.len() .. (element.len() + 1) / 4{
            stacks.push(Vec::new());
        }

        if element.chars().nth(1).expect("Should be of length superior to 2") == '1'{
            break;
        }

        for i in 0 .. (element.len() + 1) / 4{
            let character: char = element.chars().nth(4 * i + 1).expect("Should exist");
            if character != ' '{
                stacks[i].push(character);
            };
        }
    }
    for i in 0 .. stacks.len(){
        stacks[i].reverse();
    }

    // Parse instructions
    for element in content.split("\n"){
        if element.len() > 0 && element.chars().nth(0).expect("Should have enough element") == 'm'{
            instructions.push(
                element
                    .replace("move ", "")
                    .replace(" from ", ",")
                    .replace(" to ", ",")
                    .split(",")
                    .map(|x| {x.parse::<usize>().unwrap()})
                    .collect()
                );
        }
    }
    return (stacks, instructions) 
}

fn apply_instruction(mut stacks: Vec<Vec<char>>, instruction: Vec<usize>) -> Vec<Vec<char>>{
    let stack_1 = instruction[1] - 1;
    let stack_2 = instruction[2] - 1;
    for _ in 0 .. instruction[0] {
        let letter = stacks[stack_1].pop().expect("Should have enough element");
        stacks[stack_2].push(letter);
    }
    return stacks
}

fn apply_instruction_9001(mut stacks: Vec<Vec<char>>, instruction: Vec<usize>) -> Vec<Vec<char>>{
    let stack_1 = instruction[1] - 1;
    let stack_2 = instruction[2] - 1;
    let mut tmp_stack = Vec::<char>::new();
    for _ in 0 .. instruction[0] {
        let letter = stacks[stack_1].pop().expect("Should have enough element");
        tmp_stack.push(letter);
    }
    for _ in 0 .. instruction[0] {
        let letter = tmp_stack.pop().expect("Should have enough element");
        stacks[stack_2].push(letter);
    }
    return stacks
}

fn apply_instructions(mut stacks: Vec<Vec<char>>, instructions: Vec<Vec<usize>>, model: i32) -> Vec<Vec<char>> {
    for instruction in instructions {
        if model == 9000{
            stacks = apply_instruction(stacks, instruction);
        }
        else{
            stacks = apply_instruction_9001(stacks, instruction);
        }
    }
    return stacks;
}

fn get_top(stacks: Vec<Vec<char>>) -> String {
    let mut top = "".to_owned();
    for stack in stacks {
        top.push(stack[stack.len() - 1]);
    }
    return top;
}

use std::fs;
use std::collections::HashMap;
use std::option::Option;

#[derive(Debug, Clone)]
struct Monkey{
    number: i64,
    inspected_items: usize,
    items: Vec<i64>,
    operations: Vec<String>,
    condition_divider: i64,
    conditional_monkeys: HashMap<bool, usize>,
    part: i64, //Advent of Code part (either 1 or 2)
    reset: i64,
}

#[derive(Debug, Clone)]
struct MonkeyHerd{
    monkeys: Vec<Monkey>
}

impl Monkey{
    fn new(part: i64) -> Monkey{
        Monkey{
            number: 0,
            items: Vec::new(),
            inspected_items: 0,
            operations: Vec::new(),
            condition_divider: 0,
            conditional_monkeys: HashMap::new(),
            part: part,
            reset: 3,
        }
    }

    fn reset(&mut self, reset: i64) -> (){
        self.reset = reset;
    }

    fn compute(&self, value: i64) -> i64{
        let second_member: i64 = match self.operations[2].as_str() {
            "old" => value,
            v @ _ => v.parse::<i64>().unwrap()
        };
        let result: i64 = match self.operations[1].as_str(){
            "+" => value + second_member,
            "*" => value * second_member,
            _ => todo!()
        };
        // To avoid overflow we consider the modulo by
        // the product of all condition divider instead
        // of the item value itself. It keeps the value
        // small while guarantying the number of inspected
        // items correctness.
        match &self.part {
            1 => return result / self.reset,
            2 => return result % self.reset,
            _ => panic!("Part should either be 1 or 2")
        };
    }

}

impl Iterator for Monkey{
    type Item = HashMap<usize, Vec<i64>>;

    fn next(&mut self) -> Option<Self::Item>{
        let mut next_round: Self::Item = HashMap::from(
            [
                (*(self.conditional_monkeys.get(&true).unwrap()), Vec::new()),
                (*(self.conditional_monkeys.get(&false).unwrap()), Vec::new())
            ]
        );
        
        for value in self.items.iter().map(|x| {self.compute(*x)}){
            next_round
                .get_mut(&self.conditional_monkeys[&(value % &self.condition_divider == 0)])
                .unwrap()
                .push(value);
        }
        self.inspected_items += self.items.len();
        self.items = Vec::new();
        Some(next_round)
    }
}

impl MonkeyHerd{
    fn new() -> MonkeyHerd{
        MonkeyHerd {
            monkeys: Vec::new()
        }
    }

    fn parse(content: &String, part: i64) -> MonkeyHerd{
        let mut monkey_herd = MonkeyHerd::new();
        let mut monkey = Monkey::new(part);
        for line in content.split('\n'){
            if line.len() < 3{
                monkey_herd.monkeys.push(monkey.clone());
                monkey = Monkey::new(part);
            }
            else{
                match line.chars().nth(2).expect("Should exist"){
                    'S' => for item in line.split(':').nth(1).expect("Should exist").split(','){
                        monkey.items.push(
                            item.replace(" ", "").parse::<i64>().unwrap()
                            );
                    },
                    'O' => for operation in line.split("= ").nth(1).expect("Should exist").split(' '){
                        monkey.operations.push(operation.to_string());
                    },
                    'T' => monkey.condition_divider = line
                        .split("by ")
                        .nth(1)
                        .expect("Should exist")
                        .replace(" ", "")
                        .parse::<i64>()
                        .unwrap(),
                    'n' => monkey.number = line
                        .split(" ")
                        .nth(1)
                        .expect("Should exist")
                        .replace(":", "")
                        .parse::<i64>()
                        .unwrap(),
                    _ => {}
                };
                match line.chars().nth(8).expect("Should exist"){
                    'r' => monkey.conditional_monkeys.insert(
                        true,
                        line
                            .split("monkey ")
                            .nth(1)
                            .expect("Should exist")
                            .parse::<usize>()
                            .unwrap()
                     ),
                    'a' => monkey.conditional_monkeys.insert(
                        false,
                        line
                            .split("monkey ")
                            .nth(1)
                            .expect("Should exist")
                            .parse::<usize>()
                            .unwrap()
                     ),
                    _ => Option::None
                };
            }
        }
        if part == 2{
            let mut reset: i64 = 1;
            for monkey in &monkey_herd.monkeys{
                reset *= monkey.condition_divider;
            }
            for monkey in &mut monkey_herd.monkeys{
                monkey.reset(reset);
            }
        }
        monkey_herd
    }

    fn next(&mut self) -> (){
        for i in 0..(&self.monkeys).len(){
            let next = &mut self.monkeys.get_mut(i).unwrap().next().unwrap();
            for (k, v) in next.iter_mut(){
                let _ = &self.monkeys.get_mut(*k).unwrap().items.append(v);
            }
        }
    }

    fn get_monkey_business(&mut self, nb_round: i64) -> i64{
        for _ in 0..nb_round{
            _ = &self.next();
        }
        let mut inspected_items: Vec<usize> = Vec::new();
        for monkey in &self.monkeys{
            inspected_items.push(monkey.inspected_items);
        }
        inspected_items.sort_by(|a,b| a.partial_cmp(b).unwrap());
        (inspected_items[inspected_items.len() - 1] * inspected_items[inspected_items.len() - 2]).try_into().unwrap()
    }
}


fn main() {
    let content = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day11/input.txt").expect("File should exist");

    let mut monkey_herd = MonkeyHerd::parse(&content, 1);
    println!("{:}", monkey_herd.get_monkey_business(20));

    let mut monkey_herd = MonkeyHerd::parse(&content, 2);
    println!("{:}", monkey_herd.get_monkey_business(10000));
}

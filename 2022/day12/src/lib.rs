pub mod utils{
    use std::fs;
    use std::path::Path; 
    use std::error::Error;

    pub trait Puzzle {
        fn new(lines: Vec<&str>) -> Result<Self, Box<dyn Error>>
            where Self: Sized;

        fn parse(path: &Path) -> Result<Self, Box<dyn Error>>
            where Self: Sized{
            let lines = match &path.to_str() {
                Some(p) => fs::read_to_string(p)?,
                None => return Err(String::from("Path is None").into())
                };
            Self::new(lines.split("\n").collect::<Vec<&str>>())
        }

        fn solve() -> Result<String, Box<dyn Error>>;

        fn solve_part_1() -> Result<String, Box<dyn Error>>;

        fn solve_part_2() -> Result<String, Box<dyn Error>>;
    }
}

pub mod hill_climbing{
    use std::error::Error;

    use crate::utils::Puzzle;

    #[derive(Debug)]
    pub struct HeightMap{
        pub elevation: Vec<Vec<char>>
    }

    #[derive(Debug)]
    struct DynamicSolver{
        cost: Vec<Vec<usize>>
    }

    impl DynamicSolver{
        fn new(height_map: HeightMap) -> Self{
            DynamicSolver{cost: vec!(vec!(1)) }
        }

        fn analyse() -> (){
        }

        fn backtrace() -> (){
        }
    }

    impl Puzzle for HeightMap{
        fn new(lines: Vec<&str>) -> Result<Self, Box<dyn Error>>
            where Self: Sized{
            let mut elevation: Vec<Vec<char>> = Vec::new();

            for line in &lines[..lines.len()-1]{
                let mut elevation_line: Vec<char> = Vec::new();
                for character in line.chars(){
                    match character {
                        'A'..='Z' | 'a'..='z' => (),
                        _ => return Err(format!("{} Not a valid character", &character).into())
                    };
                    elevation_line.push(character);
                }
                elevation.push(elevation_line);
            }

            Ok(HeightMap{ elevation: elevation })
        }

        fn solve() -> Result<String, Box<dyn Error>> {
            Err(String::from("Not implemented").into())
        }

        fn solve_part_1() -> Result<String, Box<dyn Error>> {
            Err(String::from("Not implemented").into())
        }

        fn solve_part_2() -> Result<String, Box<dyn Error>> {
            Err(String::from("Not implemented").into())
        }
    }
}

#[cfg(test)]
mod tests_hill_climbing{
    use std::path::Path;
    use crate::utils::Puzzle;
    use crate::hill_climbing::HeightMap;

    #[test]
    fn height_map_parse(){
        match HeightMap::parse(&Path::new("/foo")){
            Err(_) => assert!(true),
            _ => assert!(false),
        };

        match HeightMap::parse(&Path::new("./resources/test.txt")){
            Err(_) => assert!(false),
            Ok(height_map) => {
                assert_eq!(5_usize, height_map.elevation.len());
                assert_eq!(8_usize, height_map.elevation[0].len());
            },
        };
    }

    #[test]
    fn height_map_new(){
        match HeightMap::new(vec!("e")){
            Err(_) => assert!(false),
            _ => assert!(true),
        };
        match HeightMap::new(vec!("é")){
            Err(_) => assert!(true),
            _ => assert!(false),
        };
    }
}

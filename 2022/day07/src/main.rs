use std::fs;
use std::collections::HashMap;


#[derive(Clone)]
struct File<'a>{
    name: &'a str,
    size: u32
}

impl<'a> File<'a>{

    fn new(name: &'a str, size: u32) -> Self{
        return File{
            name: name,
            size: size
        }
    }

    fn get_size(&self) -> u32{
        return self.size;
    }

}

#[derive(Clone)]
struct FileStructure<'a>{
    directories: HashMap<&'a str, FileStructure<'a>>,
    files: Vec<File<'a>>,
}

impl<'a> FileStructure<'a>{  

    fn from_string(content: Vec<&'a str>, current: &mut usize) -> Self{
        let mut file_structure = Self {
            directories: HashMap::<&str, FileStructure>::new(),
            files: Vec::<File>::new()
        };
        *current += 1;

        // Loop the output of the ls command
        while *current <= content.len() - 2 && content[*current].chars().nth(0).unwrap() != '$'{
            if content[*current].chars().nth(0).unwrap() != 'd'{
                let splitted_line: Vec<&str> = content[*current]
                    .clone()
                    .split(' ')
                    .collect();
                file_structure.add_file(
                    splitted_line[1],
                    splitted_line[0].parse::<u32>().unwrap()
                );
            }
            *current += 1;
        }

        // Loop the cd
        while *current <= content.len() - 2 {
            if content[*current] == "$ cd .."{
                break;
            }
            else if content[*current].contains("$ cd "){
                let splitted_line: Vec<&str> = content[*current]
                    .clone()
                    .split(' ')
                    .collect();
                *current += 1;
                file_structure.directories.insert(
                    splitted_line[2],
                    FileStructure::from_string(content.clone(), current)
                );
            }
            *current += 1;
        }
        return file_structure;
    }

    fn add_file(&mut self, name: &'a str, size: u32){
        self.files.push(File::new(name, size));
    }

    fn get_size(&self) -> u32{
        let mut size: u32 = 0;
        for file in &self.files{
            size += file.get_size();
        }
        for (_, directory) in self.directories.clone().into_iter() {
            size += directory.get_size();
        }
        return size;
    }

    fn get_small_folders_size(&self, limit: u32) -> u32{
        let mut size: u32 = 0;
        for (_, directory) in self.directories.clone().into_iter() {
            let directory_size = directory.get_size();
            if directory_size <= limit{
                size += directory_size;
            }
            size += directory.get_small_folders_size(limit);
        }
        return size;
    }

    fn get_best_deleted_size(&self, filesystem_size: u32, update_size: u32) -> u32{
        let min_deletable_size: u32 =  update_size + self.get_size() - filesystem_size;
        return self.closer_folder(min_deletable_size);
    }

    fn closer_folder(&self, value: u32) -> u32 {  
        let mut best_size = self.get_size();
        if best_size < value{
            return 0;
        }

        for (_, directory) in self.directories.clone().into_iter() {
            let best_sub_size = directory.closer_folder(value);
            if best_sub_size <= best_size && best_sub_size >= value{
                best_size = best_sub_size
            }

            let directory_size = directory.get_size();
            if directory_size <= best_size && directory_size >= value {
                best_size = directory_size
            }
        }
        return best_size;
    }

}

fn main() {
    let content = fs::read_to_string("/home/tuchekaki/documents/gitlab/advent-of-code/2022/day07/input.txt")
        .expect("Should not be empty");
    let cloned_content = content.clone();
    let file_structure = FileStructure::from_string(
        cloned_content.split('\n').collect::<Vec<&str>>(), 
        &mut 1
        );

    println!("File system size: {}", file_structure.get_size());
    println!("Small folder size: {}", file_structure.get_small_folders_size(100000));
    println!("Size folder to delete: {}", file_structure.get_best_deleted_size(70000000, 30000000));
}


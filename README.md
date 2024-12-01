# Advent of Code


[Advent of code](https://adventofcode.com) offers every year nice problems to practice your coding.
I take this as an excuse to learn or refresh my knowledge of a programming language:

- [2015: C](/2015): I did not really do it in 2015 (18 days completed)
- [2020: Python](/2020): Whohou I finished it
- [2021: Vimscript](/2021): (Yes really 17 days of vimscript)
- [2022: Rust](/2022): I went blazingly fast (or at least I tried) for 11 days
- [2023: Haskell](/2023): Side effect free since 23
- [2024: roc](/2024): Let's be Fast Friendly and Functional

## Automation

### Installation

- Add an environment variable storing the cookie to advent of code `export AOC_COOKIE="session=#SECRET#"` (highly recommend direnv for this)
- Create your base code for the year in `resources/[ YYYY ]` (knowing that the data are located)

### Usage

- Run the following command to **generate the project in the language of the year**, **get the the input of the day**, **print the url of today's puzzle in the clipboard**, and **add the puzzle instruction as a README.md**

```shell
make start
```
- It also works for other days and years

```shell
make start DAY='[ DAY ]' YEAR='[ YEAR ]'
```

### Worth noticing

- If the folder already exist it will not be recreated
- The test data are not parsed automatically

## Notes

- I lost the commit history of the early year
- Some absolute paths can be found here and there sorry about that...

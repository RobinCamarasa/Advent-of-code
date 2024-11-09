# Advent of Code


[Advent of code](https://adventofcode.com) offers every year nice problems to practice your coding.
I take this as an excuse to learn of refresh my knowledge of a programming language:

- [2015: C](/2015): I did not really do it in 2015 (18 days completed)
- [2020: Python](/2020): Whohou I finished it
- [2021: Vimscript](/2021): (Yes really 17 days of vimscript)
- [2022: Rust](/2022): I went blazingly fast (or at least I tried) for 11 days
- [2023: Haskell](/2023): Side effect free since 23
- [2024: ROC](/2024): Let's be Fast Friendly and Functional

## Automation

### Installation

- Add an environment variable storing the cookie of connection to advent of code `export AOC_COOKIE="session=#SECRET#"`
- Create your base code for the year in `resources/[ YYYY ]` (knowing that the data are located)

### Usage

- To _generate the project in the language of the year_, _get the the input of the day_, and _copy the url of today's puzzle in the clipboard_; launch

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

- The history of the commit was lost as I used to do it with my Research lab in another repository.
- Some absolute paths can be found here and there sorry about that...

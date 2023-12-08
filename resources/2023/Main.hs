import Data.List.Split

-- TODO Data type definitions

-- Input parser
-- parseInput :: String -> TODO
parseInput puzzleInput = splitPuzzleInput
    where splitPuzzleInput = lines puzzleInput

-- Solve part one
-- partOne :: String -> TODO
partOne puzzleInput = "TODO"
    where _ = parseInput puzzleInput

-- Solve part two
-- partTwo :: String -> TODO
partTwo puzzleInput = "TODO"
    where _ = parseInput puzzleInput


main :: IO()
main = do
    puzzleInput <- readFile "data/data.txt"
    putStr . ("Input" ++) . (++ "\n") . show . parseInput $ puzzleInput
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput


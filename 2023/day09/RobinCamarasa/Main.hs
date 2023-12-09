import Data.List.Split as SPL

-- TODO Data type definitions

-- Input parser
parseInput :: String -> [[Int]]
parseInput puzzleInput = (read <$>) <$> reverse <$> (SPL.splitOn " ")  <$> lines puzzleInput

-- Solve part one
partOne :: String -> Int
partOne puzzleInput = sum $ head <$> fillLine <$> parseInput puzzleInput

fillLine line 
    | (sum $ abs <$> line) == 0 = 0 : line
    | otherwise = (head line + head recDiff): line
    where recDiff = fillLine $ (\(a,b) -> a - b) <$> (zip line (tail line))

-- Solve part two
partTwo :: String -> Int
partTwo puzzleInput = sum $ head <$> fillLine <$> reverse <$> parseInput puzzleInput


main :: IO()
main = do
    puzzleInput <- readFile "data/data.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput


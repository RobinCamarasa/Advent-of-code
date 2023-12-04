import Data.List.Split as SPL

data Card = Card Int [Int] [Int] deriving Show

wonNumbers :: Card -> Int
wonNumbers = length. listWonNumbers
    where listWonNumbers (Card _ w p)= (filter (flip elem $ w)) $ p

partOne :: String -> Int
partOne = (foldr (+) 0) . getPoints
    where getPoints = (map ((`div` 2) . (2^) . wonNumbers)) . parseInput

partTwo :: String -> Int
partTwo = fst . (foldl getNumberCards (0, [])) . (map wonNumbers) . parseInput
    where getNumberCards :: (Int, [Int]) -> Int -> (Int, [Int])
          getNumberCards (value, []) number = (value + 1, take number $ repeat 1)
          getNumberCards (value, head:queue) number = (value + head + 1, update queue number (head + 1))
          update :: [Int] -> Int -> Int -> [Int]
          update list 0 _ = list
          update [] n number = take n $ repeat number 
          update (head:queue) n number = (head + number) : (update queue (n - 1) number)

parseInput :: String -> [Card]
parseInput = (map mkCard) . lines

mkCard :: String -> Card
mkCard line = Card (cardNumber :: Int) winningNumbers personalNumbers
    where (card:lineQueue) = SPL.splitOn ":" line
          (winning:personal:[]) = SPL.splitOn "|" (concat lineQueue)
          splitMultipleSpace = (filter (/= "")) . (SPL.splitOn " ")
          splitNumbers = (map (\num -> (read num :: Int))) . splitMultipleSpace
          cardNumber = (read . head . reverse . splitMultipleSpace) card
          winningNumbers = splitNumbers winning
          personalNumbers = splitNumbers personal

main :: IO()
main = do
    puzzleInput <- readFile "data/day04.txt"
    (putStr . ("Part one: " ++) . (++ "\n") . show . partOne) puzzleInput
    (putStr . ("Part two: " ++) . (++ "\n") . show . partTwo) puzzleInput

import Data.List.Split as SPL
data Card = Card Int [Int] [Int] deriving Show

partOne :: String -> Int
partOne puzzleInput = foldr (+) 0 wonNumbers
    where cards = parseInput puzzleInput 
          listWonNumbers (Card _ w p)= (filter (flip elem $ w)) $ p
          wonNumbers = map ((`div` 2) . (2^). length . listWonNumbers) cards

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

import Data.List.Split as SPL

type Time = Double
type Distance = Double
type Range = (Int, Int)

parseOne :: String -> [(Time, Distance)]
parseOne puzzleInput = zip (clean times) (clean distances)
    where (times:distances:_) = lines puzzleInput
          clean = (map (\x -> (read x) :: Double)). (filter (/= "")) . tail . (SPL.splitOn " ")

parseTwo :: String -> [(Time, Distance)]
parseTwo puzzleInput = zip (clean times) (clean distances)
    where (times:distances:_) = lines puzzleInput
          clean = (map (\x -> (read x) :: Double)) . (map (filter (/= ' '))) . tail . (SPL.splitOn ":")

solve :: (String -> [(Time, Distance)]) -> String -> Int
solve parser = (foldr (*) 1) . (map $ \(x,y) -> y - x + 1) . (map timeRange) . parser

timeRange :: (Time, Distance) -> Range
timeRange (time, distance) = (minRange, maxRange)
        where delta = time ^ 2 - 4 * (distance + 1)
              maxRange = floor $ (/2) $ time + sqrt delta
              minRange = ceiling $ (/2) $ time - sqrt delta

main :: IO()
main = do
    puzzleInput <- readFile "data/day06.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . (solve parseOne) $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . (solve parseTwo) $ puzzleInput

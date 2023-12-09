import Data.List
import Data.List.Split
import qualified Data.Map as MP

type Node = (String, String)
type Instruction = Char
type Cost = Int
type Graph = MP.Map String Node 

slice :: Int -> Int -> [a] -> [a]
slice offset number = (take number) . (drop offset)

parseInput :: String -> ([Instruction], Graph)
parseInput puzzleInput = (head $ splitPuzzleInput, MP.fromList . (zip nodes) $ zip lefts rights)
    where splitPuzzleInput = lines puzzleInput
          nodesDesc = drop 2 splitPuzzleInput
          nodes = (slice 0 3) <$> nodesDesc
          lefts = (slice 7 3) <$> nodesDesc
          rights = (slice 12 3) <$> nodesDesc

getNbSteps :: Graph -> [Instruction] -> String -> Int
getNbSteps graph (instruction:instructions) node
    | (== 'Z') $ node !! 2 = 0
    | otherwise = (+1) $ getNbSteps graph instructions next
    where next = (if instruction == 'L' then fst else snd) . ((MP.!) graph) $ node

partOne :: String -> Int
partOne puzzleInput = getNbSteps graph (cycle instructions) "AAA" 
    where (instructions, graph) = parseInput puzzleInput


partTwo :: String -> Int
partTwo puzzleInput = foldr lcm 1 costs
    where (instructions, graph) = parseInput puzzleInput
          getKeys = (filter (\x -> x !! 2 == 'A')) . MP.keys
          costs = (getNbSteps graph (cycle instructions)) <$> getKeys graph

main :: IO()
main = do
    puzzleInput <- readFile "data/data.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput

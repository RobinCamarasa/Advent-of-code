import Data.List.Split
import Data.List
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
          nodes = map (slice 0 3) nodesDesc
          lefts = map (slice 7 3) nodesDesc
          rights = map (slice 12 3) nodesDesc

getNbSteps :: Graph -> [Instruction] -> String -> Int
getNbSteps graph instructions node = 
    let (left, right) = graph MP.! node in 
        case (node, instructions) of
            (_:_:"Z", _) -> 0
            (_, 'L':q) -> 1 + (getNbSteps graph (drop 1 instructions) left)
            (_, 'R':q) -> 1 + (getNbSteps graph (drop 1 instructions) right)

partOne :: String -> Int
partOne puzzleInput = getNbSteps graph (cycle instructions) "AAA" 
    where (instructions, graph) = parseInput puzzleInput


partTwo :: String -> Int
partTwo puzzleInput = foldr lcm 1 costs
    where (instructions, graph) = parseInput puzzleInput
          getKeys = (filter (\x -> x !! 2 == 'A')) . MP.keys
          costs = map (getNbSteps graph (cycle instructions)) . getKeys $ graph

main :: IO()
main = do
    puzzleInput <- readFile "data/data.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput

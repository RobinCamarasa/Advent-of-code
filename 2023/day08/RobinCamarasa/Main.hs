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

getNbSteps :: String -> [Instruction] -> Graph -> Int
getNbSteps node instructions graph = 
    let (left, right) = graph MP.! node in 
        case (node, instructions) of
            ("ZZZ", _) -> 0
            (_, 'L':q) -> 1 + (getNbSteps left (drop 1 instructions) graph)
            (_, 'R':q) -> 1 + (getNbSteps right (drop 1 instructions) graph)

computeCost :: Graph -> 
               [Instruction] ->
               String ->
               Cost
computeCost graph (instruction:instructions) node
    | (== "Z") $ drop 2 node  = 0
    | otherwise = (1+) $ computeCost graph instructions nextNode 
    where (leftNext, rightNext) = (MP.!) graph node
          nextNode = if instruction == 'L' then leftNext else rightNext

partOne :: String -> Int
partOne puzzleInput = getNbSteps "AAA" (cycle instructions) graph
    where (instructions, graph) = parseInput puzzleInput


partTwo :: String -> Int
partTwo puzzleInput = foldr lcm 1 costs
    where (instructions, graph) = parseInput puzzleInput
          getKeys = (filter (\x -> x !! 2 == 'A')) . MP.keys
          costs = map (computeCost graph (cycle instructions)) . getKeys $ graph

main :: IO()
main = do
    puzzleInput <- readFile "data/data.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput

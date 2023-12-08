import Data.List.Split
import qualified Data.Map as MP

type Node = (String, String)
type Instruction = Char
type Instructions = String
type Graph = MP.Map String Node 

slice :: Int -> Int -> [a] -> [a]
slice offset number = (take number) . (drop offset)

parseInput :: String -> (Instructions, Graph)
parseInput puzzleInput = (cycle . head $ splitPuzzleInput, MP.fromList . (zip nodes) $ zip lefts rights)
    where splitPuzzleInput = lines puzzleInput
          nodesDesc = drop 2 splitPuzzleInput
          nodes = map (slice 0 3) nodesDesc
          lefts = map (slice 7 3) nodesDesc
          rights = map (slice 12 3) nodesDesc

getNbSteps :: String -> Instructions -> Graph -> Int
getNbSteps node instructions graph = let (left, right) = graph MP.! node in 
                                     case (node, instructions) of
                                        ("ZZZ", _) -> 0
                                        (_, 'L':q) -> 1 + (getNbSteps left (drop 1 instructions) graph)
                                        (_, 'R':q) -> 1 + (getNbSteps right (drop 1 instructions) graph)

update :: [String] -> Instruction -> Graph -> [String]
update nodes instruction graph = map next nodes
        where next node = let (left, right) = graph MP.! node in if instruction == 'L' then left else right

getGostNbSteps :: [String] -> Instructions -> Graph -> Int
getGostNbSteps nodes instructions graph
    | length notZNodes == 0 = 1
    | otherwise = 1 + getGostNbSteps updatedNodes (tail instructions) graph
    where updatedNodes = update nodes (head instructions) graph
          notZNodes = (filter (/= "Z")) . (map (drop 2)) $ updatedNodes

partOne :: String -> Int
partOne puzzleInput = getNbSteps "AAA" instructions graph
    where (instructions, graph) = parseInput puzzleInput


-- partTwo :: String -> Int
partTwo puzzleInput = getGostNbSteps (getKeys graph) instructions graph
    where (instructions, graph) = parseInput puzzleInput
          getKeys = (filter (\x -> x !! 2 == 'A')) . MP.keys

main :: IO()
main = do
    puzzleInput <- readFile "data/day08.txt"
    -- putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput

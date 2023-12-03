module Main (main) where

import Data.Char as CHR
import Test.Hspec
import Data.Maybe


data PuzzleValue = Value Int | Symbol Char | Blank deriving (Eq, Show)
data Candidate = Candidate CoordinateRange Int deriving (Eq, Show)
data GearCand = GearCand Coordinate deriving (Eq, Show)

type Engine = [[PuzzleValue]]
type EngineSize = Int
type CoordinateRange = (Int, (Int, Int))
type Coordinate = (Int, Int)

translate :: Char -> PuzzleValue
translate character
    | CHR.isDigit character = Value (CHR.digitToInt character)
    | character == '.' = Blank
    | otherwise = Symbol character

mkEngine :: String -> Engine
mkEngine puzzleInput = map (\puzzleLine -> map translate puzzleLine) (lines puzzleInput)

getCandidates :: EngineSize -> Engine -> [Candidate] -> [Candidate]
getCandidates size engine [] = getCandidates size engine [Candidate (0, (-1, 0)) (-1)]
getCandidates size engine candidates@((Candidate (x, (ymin, ymax)) counter):candsQueue)
    | x == size = case counter of
                    -1 -> candsQueue
                    _ -> candidates
    | ymax == size = let newCandidate = Candidate (x + 1, (-1, 0)) (-1) in 
                                    case counter of
                                        -1 -> getCandidates size engine (newCandidate:candsQueue)
                                        _ -> getCandidates size engine (newCandidate:candidates)
    | otherwise = case (counter, (engine !! x) !! ymax) of
                    (-1, Value value) -> getCandidates size engine ((Candidate (x, (ymax - 1, ymax + 1)) value):candsQueue)
                    (_, Value value) -> getCandidates size engine ((Candidate (x, (ymin, ymax + 1)) (10 * counter + value)):candsQueue)
                    (-1, _) -> getCandidates size engine ((Candidate (x, (ymax - 1, ymax + 1)) (-1)):candsQueue)
                    (_, _) -> getCandidates size engine ((Candidate (x, (ymax - 1, ymax + 1)) (-1)):candidates)

getEngineParts :: EngineSize -> Engine -> [Candidate] -> [Candidate]
getEngineParts size engine [] = []
getEngineParts size 
               engine 
               (candidate@(Candidate (x, (ymin, ymax)) _):candsQueue) 
               = if hasSymbolNeighbourg then candidate:recursiveValue else recursiveValue
    where isSymbol :: Coordinate -> Bool
          isSymbol (x, y)
              | x < 0 || x >= size || y < 0 || y >= size = False
              | otherwise = case ((engine !! x) !! y) of
                                Symbol _ -> True
                                _ -> False
          hasSymbolNeighbourg :: Bool
          hasSymbolNeighbourg = any isSymbol [(x_, y_) | x_ <-[(x-1)..(x+1)], y_ <- [ymin..ymax]]
          recursiveValue :: [Candidate]
          recursiveValue = getEngineParts size engine candsQueue

getPotentialGears :: Engine -> [GearCand]
getPotentialGears engine = gearCands
    where indexed = zip [0..] (concat engine)
          size = length engine
          indexedSymbols = filter (\(_, puzzleValue) -> isSymbol puzzleValue) indexed
          gearCands = map (\(indexed, _) -> GearCand (indexed `divMod` size)) indexedSymbols
          isSymbol :: PuzzleValue -> Bool
          isSymbol (Symbol _) = True
          isSymbol _ = False


belong :: Candidate -> GearCand -> Bool
belong (Candidate (xcoor, (ymin,ymax)) _) (GearCand (x, y)) = elem (x, y) [(x_, y_) | x_ <- [(xcoor-1) ..(xcoor+1)], y_ <- [ymin..ymax]]

maybeGearValue :: [Candidate] -> GearCand -> Maybe Int
maybeGearValue candidates gear =
        if length connectedParts == 2 then Just (foldr candidatesProduct 1 connectedParts) else Nothing
     where connectedParts = filter (`belong` gear) candidates
           candidatesProduct :: Candidate -> Int -> Int
           candidatesProduct (Candidate _ value) value' = value * value'

partTwo :: String -> Int
partTwo puzzleInput = (foldr (+) 0) $ catMaybes $ (map (maybeGearValue candidates)) $ gearCandidates
    where candidates = getCandidates size engine []
          gearCandidates = getPotentialGears engine
          engine = mkEngine puzzleInput
          size = length engine

partOne :: String -> Int
partOne puzzleInput = foldr (+) 0 $ map (\(Candidate _ value) -> value) parts
    where engine = mkEngine puzzleInput
          size = length engine
          parts = getEngineParts size engine $ getCandidates size engine []

main :: IO ()
main = do
  puzzleInput <- readFile "data/day03.txt"
  (putStrLn .  (++ "\n") . ("Part one: " ++) . show) $ partOne puzzleInput
  (putStrLn .  (++ "\n") . ("Part two: " ++) . show) $ partTwo puzzleInput

testEngine :: Engine
testEngine = mkEngine "#.45\n350.\n1235\n#123"

test :: IO ()
test = hspec $ do
    describe "Check character translation" $ do
        it ". is Blank" $ do
            (translate '.') `shouldBe` Blank
        it "'#' is Symbol '#'" $ do
            (translate '#') `shouldBe` (Symbol '#')
        it "1 is Value 1" $ do
            (translate '1') `shouldBe` (Value 1)

    describe "Check puzzle input parsing" $ do
        it "..4#\\n.3.. is [[Blank, Blank, Value 4, Symbol #], [Blank, Value 3, Blank, Blank]]" $ do
            (mkEngine "..4#\n.3..") `shouldBe` [[Blank, Blank, Value 4, Symbol '#'], [Blank, Value 3, Blank, Blank]]

    describe "Check if candidates are correctly found" $ do
        it ((show testEngine) ++ "should have 4 candidates") $ do
            (length $ getCandidates 4 testEngine []) `shouldBe` 4

    describe "Check if engine parts are correctly found" $ do
        it ("Test engine should have 3 parts") $ do
            (length $ getEngineParts 4 testEngine $ getCandidates 4 testEngine []) `shouldBe` 3

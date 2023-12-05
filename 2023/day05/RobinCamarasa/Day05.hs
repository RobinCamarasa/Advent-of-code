import Data.Maybe

import Data.List.Split as SPL
import qualified Data.Map as MAP

data Entry = Entry {dest :: Int, src :: Int, range :: Int} deriving (Eq, Show)
data MapEntry = MapEntry {to :: String, entries :: [Entry]} deriving (Eq, Show)

type Step = (String, Int)
type StepRange = (String, (Int, Int))
type Range = (Int, Int)
type Almanach = MAP.Map String MapEntry

parseInput :: String -> ([StepRange], [Step], Almanach)
parseInput puzzleInput = (addSeed seedRanges, addSeed seedValues, MAP.fromList . (map toKeyMapEntry) $ maps)
    where (seeds:maps) = SPL.splitOn "\n\n" puzzleInput
          toInt value =  (read value :: Int)
          seedValues = (map toInt) . (SPL.splitOn " ") . (drop 7) $ seeds 
          seedRanges = toRange seedValues 
          toRange [] = []
          toRange (a:b:q) = ((a,b):(toRange q))
          addSeed = zip (repeat "seed")
          toKeyMapEntry mapValue = (from, MapEntry {to=to, entries=entriesValues})
              where (almaMapDesc:entries) = lines mapValue
                    (from:to:_) = (SPL.splitOn "-to-") . head . (SPL.splitOn " map:") $ almaMapDesc
                    entriesValues = map (toEntry. (map toInt) . (SPL.splitOn " ")) $ entries
                    toEntry (dest:src:range:_) =  Entry dest src range

getValue :: Almanach -> Step -> Step
getValue almanach step@(key, value)
    | not . (MAP.member key) $ almanach = step
    | otherwise = getValue almanach (to, abs . (foldr update value) $ entries)
        where (MapEntry {to=to, entries=entries}) = (almanach MAP.!) $ key
              update (Entry {dest=dest, src=src, range=range}) value
                  | delta < 0 || delta >= range = value
                  | otherwise = -(dest + delta)
                      where delta = value - src


getRanges :: Almanach -> StepRange -> [StepRange]
getRanges almanach step@(key, range) 
    | not . (MAP.member key) $ almanach = [step]
    | otherwise = concat . (map (getRanges almanach)) $ zip (repeat to) (map unEither eitherRanges)
        where (MapEntry {to=to, entries=entries}) = almanach MAP.! key
              applyEntries entry eitherRanges = concat $ map (applyEntry entry) $ eitherRanges
              eitherRanges = foldr applyEntries [Left range] entries
              unEither (Left range) = range
              unEither (Right range) = range

applyEntry :: Entry -> Either Range Range -> [Either Range Range]
applyEntry _ right@(Right range) = [right]
applyEntry entry@(Entry {dest=leftDest, src=leftEnt, range=spanEnt}) range@(Left (leftRan, spanRan)) =
    filter isImpossible [Left (leftRan, tooLowRange), Right (leftOut, inRangeRange), Left (leftTooHigh, tooHighRange)]
    where tooLowRange = min spanRan (leftEnt - leftRan)
          inLeft = max leftEnt leftRan
          inRight = min (leftEnt + spanEnt) (leftRan + spanRan)
          inRangeRange = inRight - inLeft
          leftOut = (+ leftDest) (inLeft - leftEnt) 
          leftTooHigh = max (leftRan) (leftEnt + spanEnt)
          tooHighRange = min spanRan ((leftRan +  spanRan) - (leftEnt + spanEnt))
          isImpossible :: Either Range Range -> Bool
          isImpossible (Right (_, range)) = range > 0
          isImpossible (Left (_, range)) = range > 0

partOne :: String -> Int
partOne puzzleInput = minimum . (map (snd . (getValue almanach))) $ initSteps
    where (_, initSteps, almanach) = parseInput puzzleInput

partTwo :: String -> Int
partTwo puzzleInput = minimum . map (fst . snd) . concat . map (getRanges almanach) $ initStepRanges
    where (initStepRanges, _, almanach) = parseInput puzzleInput

main :: IO()
main = do
    puzzleInput <- readFile "data/day05.txt"
    (putStr . ("Part one: " ++) . (++ "\n") . show . partOne) puzzleInput
    (putStr . ("Part two: " ++) . (++ "\n") . show . partTwo) puzzleInput

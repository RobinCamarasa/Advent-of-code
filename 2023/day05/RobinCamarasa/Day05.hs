import Data.List.Split as SPL
import qualified Data.Map as MAP

data Entry = Entry {dest :: Int, src :: Int, range :: Int} deriving (Eq, Show)
data MapEntry = MapEntry {to :: String, entries :: [Entry]} deriving (Eq, Show)

type Step = (String, Int)
type Almanach = MAP.Map String MapEntry

parseInput :: String -> ([Step], Almanach)
parseInput puzzleInput = (seedValues, MAP.fromList . (map toKeyMapEntry) $ maps)
    where (seeds:maps) = SPL.splitOn "\n\n" puzzleInput
          toInt value =  (read value :: Int)
          seedValues = (zip (repeat "seed")) . (map toInt) . (SPL.splitOn " ") . (drop 7) $ seeds 
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


lowestFinalStep :: Almanach -> [Step] -> Int
lowestFinalStep almanach = minimum . (map (snd . (getValue almanach)))

partOne :: String -> Int
partOne puzzleInput = lowestFinalStep almanach initSteps
    where (initSteps, almanach) = parseInput puzzleInput

main :: IO()
main = do
    puzzleInput <- readFile "data/day05.txt"
    (putStr . ("Part one: " ++) . (++ "\n") . show . partOne) puzzleInput
    (putStr . ("Part two: " ++) . (++ "\n") . show . partOne) puzzleInput

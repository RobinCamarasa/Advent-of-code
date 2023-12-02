import Data.List.Split as SP


data Cube = Red Int | Green Int | Blue Int deriving (Eq, Show)
type Reveal = [Cube]
data Game = Game Int [Reveal] deriving (Eq, Show)

parseGames :: String -> [Game]
parseGames = (map parseGame) . lines

parseGame :: String -> Game
parseGame gameDesc = Game gameId reveals
    where game:[revealsDesc] = SP.splitOn ": " gameDesc
          revealDescs = SP.splitOn "; " revealsDesc
          gameId = read . (drop 5) $ game :: Int
          reveals = map parseReveal revealDescs

parseReveal :: String -> Reveal
parseReveal revealDesc = (map (parseCube)) . (SP.splitOn ", ") $ revealDesc

parseCube :: String -> Cube
parseCube cubeDesc = case SP.splitOn " " cubeDesc of
    value:["blue"]  -> Blue (read value :: Int)
    value:["red"]   -> Red (read value :: Int)
    value:["green"] -> Green (read value :: Int)

partOne :: [Game] -> String
partOne games = "Part one: " ++ (show accumulateIds) ++ "\n"
    where filteredGames = filter (isPossible (Red 12, Blue 13, Green 14)) games
          accumulateIds = foldr (\(Game id _) score -> score + id) 0 filteredGames
          
isPossible :: (Cube, Cube, Cube) -> Game -> Bool
isPossible (Red r, Blue g, Green b) (Game _ reveals)  = all isValid (concat reveals)
    where isValid :: Cube -> Bool
          isValid cube = case cube of
              Red value -> value <= r
              Blue value -> value <= b
              Green value -> value <= g

partTwo :: [Game] -> String
partTwo games = "Part two: " ++ (show cumulatedPowerSets) ++ "\n"
    where cumulatedPowerSets = foldr (+) 0 (map powerSet games)
    
powerSet :: Game -> Int
powerSet (Game _ reveals) = r * g * b
    where (Red r, Blue b, Green g) = foldr aggregate (Red 0, Blue 0, Green 0) (concat reveals)
          aggregate :: Cube -> (Cube, Cube, Cube) -> (Cube, Cube, Cube)
          aggregate cube (Red rA, Blue bA, Green gA) = case cube of
            Red value -> (Red (maximum [rA, value]), Blue bA, Green gA)
            Blue value -> (Red rA, Blue (maximum [bA, value]), Green gA)
            Green value -> (Red rA, Blue bA, Green (maximum [gA, value]))

main :: IO()
main = do
    input <- readFile "puzzle.data"
    (putStr . partOne . parseGames) input
    (putStr . partTwo . parseGames) input

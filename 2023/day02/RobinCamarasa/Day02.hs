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


main :: IO()
main = do
    input <- readFile "puzzle.data"
    (putStr . partOne . parseGames) input

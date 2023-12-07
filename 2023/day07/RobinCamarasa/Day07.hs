import Data.List
import Data.List.Split as SPL

type Card = Int
type Bid = Int
data Type = High Card | Pair Card | Double Card Card | Three Card | Full Card Card | Four Card | Five Card deriving (Eq, Show)

instance Ord Type where
    compare (Five _) (Five _) = EQ
    compare (Five _) _ = GT
    compare _ (Five _) = LT
    compare (Four _) (Four _) = EQ
    compare (Four _) _ = GT
    compare _ (Four _) = LT
    compare (Full _ _) (Full _ _) = EQ
    compare (Full _ _) _ = GT
    compare _ (Full _ _) = LT
    compare (Three _) (Three _) = EQ
    compare (Three _) _ = GT
    compare _ (Three _) = LT
    compare (Double _ _) (Double _ _) = EQ
    compare (Double _ _) _ = GT
    compare _ (Double _ _) = LT
    compare (Pair _) (Pair _) = EQ
    compare (Pair _) _ = GT
    compare _ (Pair _) = LT
    compare (High _) (High _) = EQ

mkCard :: Char -> Card
mkCard 'A' = 14
mkCard 'K' = 13
mkCard 'Q' = 12
mkCard 'J' = 11
mkCard 'T' = 10
mkCard val = (read (val:[]) :: Int)


cardsToGroups :: [Card] -> [[Card]]
cardsToGroups [] = []
cardsToGroups (a:[]) = [[a]]
cardsToGroups (a:q)
    | length lastEntry == 0 = [a] : (tail acc)
    | a == (head lastEntry) = (a:lastEntry) : (tail acc)
    | otherwise = [a] : acc
    where acc = cardsToGroups $ q
          lastEntry = head acc


evalCards :: [Card] -> Type
evalCards = getType . (sortBy sortGroup) . cardsToGroups . sort

parseInput :: String -> ([[Card]], [Bid])
parseInput puzzleInput = (cards, bids)
                         where hands = (map $ SPL.splitOn " ") . lines $ puzzleInput
                               cards = map ((map mkCard) . (\(a:_) -> a)) hands
                               bids = map (\(_:b:_) -> (read b :: Int)) hands

bestReplacement :: [[Card]] -> Card
bestReplacement ((a:_):[]) = (14 :: Card)
bestReplacement ((a:_):(b:_):_)
    | a == (11 :: Card) = b
    | otherwise = a

replace :: [Card] -> [Card]
replace cards = map (\x -> if x == 11 then bestReplacementCard else x) cards
            where bestReplacementCard = bestReplacement . (sortBy sortGroup) . cardsToGroups . sort $ cards

getScore = sum . (map (\(a, b) -> a * b)) . (zip [1..]) . (map (\(_, _, x) -> x)) . sort

partOne puzzleInput =  getScore $ zip3 types cards bids
        where (cards, bids)= parseInput puzzleInput
              types = map evalCards cards

partTwo puzzleInput = getScore $ zip3 typ' cards'  bids
        where (cards, bids) = parseInput puzzleInput
              cards' = map (map (\x -> if x == (11::Card) then (0::Card) else x)) cards
              typ' = map evalCards (map replace cards)


sortGroup :: [Card] -> [Card] -> Ordering
sortGroup g1 g2 
    | (length g1) > (length g2) = LT
    | (length g1) < (length g2) = GT
    | (head g1) > (head g2) = LT
    | (head g1) < (head g2) = GT
    | otherwise = EQ

getType :: [[Card]] -> Type
getType ((a:_):[]) = Five a
getType (aa@(a:_):bb@(b:_):_)
    | (length aa) == 4 = Four a
    | (length aa) == 3  && (length bb) == 2 = Full a b
    | (length aa) == 3 = Three a
    | (length aa) == 2 && (length bb) == 2 = Double a b
    | (length aa) == 2 = Pair a
    | otherwise = High a

main :: IO()
main = do
    puzzleInput <- readFile "data/day07.txt"
    putStr . ("Part one: " ++) . (++ "\n") . show . partOne $ puzzleInput
    putStr . ("Part two: " ++) . (++ "\n") . show . partTwo $ puzzleInput

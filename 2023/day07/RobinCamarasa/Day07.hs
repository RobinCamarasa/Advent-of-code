import Data.List
import Data.List.Split as SPL

type Card = Int
type Bid = Int
data Type = High Card | Pair Card | Double Card Card | Three Card | Full Card Card | Four Card | Five Card deriving Show

mkCard :: Char -> Card
mkCard 'A' = 14
mkCard 'K' = 13
mkCard 'Q' = 12
mkCard 'J' = 11
mkCard 'T' = 10
mkCard val = (read (val:[]) :: Int)

-- groupToType :: [[Card]] -> Type
-- groupToType :: [[Card]] -> Type

cardsToGroups :: String -> [[Card]]
cardsToGroups [] = []
cardsToGroups (a:[]) = [[mkCard a]]
cardsToGroups (a:q)
    | length lastEntry == 0 = [mkCard a] : (tail acc)
    | (mkCard a) == (head lastEntry) = ((mkCard a):lastEntry) : (tail acc)
    | otherwise = [mkCard a] : acc
    where acc = cardsToGroups $ q
          lastEntry = head acc

-- parseInput :: String -> [(([Card], Type), Bid)]
parseInput = (map evalHand) . (map (SPL.splitOn " ")) . lines
    where evalHand (a:b:_) = (((map mkCard) $ a, getType . (sortBy sortGroup) . cardsToGroups . sort $ a), read b :: Int)

partOne :: String -> Int
partOne = snd .
          (foldr (\(_, bid) (i, acc) -> (i+1, acc + (i+1) * bid)) (0, 0)) .
          reverse .
          (sortBy (\(cardType, _) (cardType', _) -> sortHands cardType cardType')) . 
          parseInput 

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

sortHands :: ([Card], Type) -> ([Card], Type) -> Ordering
sortHands (cards, Five _) (cards', Five _) = compare cards cards'
sortHands (_, Five _) _ = GT
sortHands _ (_, Five _) = LT
sortHands (cards, Four _) (cards', Four _) = compare cards cards'
sortHands (_, Four _) _ = GT
sortHands _ (_, Four _) = LT
sortHands (cards, Full _ _) (cards', Full _ _) = compare cards cards'
sortHands (_, Full _ _) _ = GT
sortHands _ (_, Full _ _) = LT
sortHands (cards, Three _) (cards', Three _) = compare cards cards'
sortHands (_, Three _) _ = GT
sortHands _ (_, Three _) = LT
sortHands (cards, Double _ _) (cards', Double _ _) = compare cards cards'
sortHands (_, Double _ _) _ = GT
sortHands _ (_, Double _ _) = LT
sortHands (cards, Pair _) (cards', Pair _) = compare cards cards'
sortHands (_, Pair _) _ = GT
sortHands _ (_, Pair _) = LT
sortHands (cards, High _) (cards', High _) = compare cards cards'

main :: IO()
main = do
    puzzleInput <- readFile "data/day07.txt"
    putStr . show . partOne $ puzzleInput

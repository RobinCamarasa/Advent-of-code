import Data.Char as L

numbers :: [(Int, String)]
numbers = [
    (0, "zero"),
    (1, "one"),
    (2, "two"),
    (3, "three"),
    (4, "four"),
    (5, "five"),
    (6, "six"),
    (7, "seven"),
    (8, "eight"),
    (9, "nine")
    ]

getAlphaDigit :: String -> [(Int, String)] -> Maybe Int
getAlphaDigit line [] = Nothing
getAlphaDigit line ((cifer, spelling):q)
    | (take (length spelling) line) == spelling = Just cifer
    | otherwise = getAlphaDigit line q
 
getNumDigit :: Char -> Maybe Int
getNumDigit a
    | value <= 9 && value >= 0 = Just value
    | otherwise = Nothing
    where value = (L.ord(a) - 48)

getDigitsPartOne :: String -> [Int]
getDigitsPartOne [] = []
getDigitsPartOne (a:q) = case getNumDigit a of
    Nothing -> getDigitsPartOne q
    Just cifer -> cifer : (getDigitsPartOne q)

getDigitsPartTwo :: String -> [Int]
getDigitsPartTwo [] = []
getDigitsPartTwo s@(a:q) = case (getNumDigit a, getAlphaDigit s numbers) of
    (Nothing, Nothing) -> getDigitsPartTwo q
    (Just cifer, _) -> cifer : (getDigitsPartTwo q)
    (_, Just cifer) -> cifer : (getDigitsPartTwo $ q)

getNumber :: [Int] -> Int
getNumber l = 10 * (l !! 0) + (l !! ((length l) - 1))

aggregate :: String -> (String -> [Int]) -> Int
aggregate s digitFunc = foldr (+) 0 $ map getNumber $ map digitFunc (words s)

main :: IO()
main = do
    -- part one
    lines <- readFile "data/day01.txt"
    putStr ("Part one: " ++ (show $ aggregate lines getDigitsPartOne) ++ "\n")
    putStr ("Part two: " ++ (show $ aggregate lines getDigitsPartTwo) ++ "\n")

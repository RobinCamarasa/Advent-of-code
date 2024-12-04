app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br",
}

import pf.Stdout
import "./data/data.txt" as dataContent : Str

main =
    solve { content: dataContent, part: 1 } |> Stdout.line!
    solve { content: dataContent, part: 2 } |> Stdout.line!

solve : { content : Str, part : I32 } -> Str
solve = \{ content: content, part: part } ->
    func =
        when part is
            1 -> partOne
            2 -> partTwo
            _ -> crash "This is not a valid part"
    content
    |> parse
    |> func
    |> \result -> "Part $(Num.toStr part): $(result)"

# TODO 1 change
ParsedType : Str

# TODO 2 add data
testContent =
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content -> content

isDigit = \x -> (x >= '0' && x <= '9')

parseMul = \index, str ->
    sub = List.dropFirst str index
    if List.startsWith sub (Str.toUtf8 "mul(") then
        afterMul = List.dropFirst sub 4
        makeNum1 = \n1 -> Num.toI64 (n1 - '0')
        makeNum2 = \n1, n2 -> 10 * (makeNum1 n1) + (makeNum1 n2)
        makeNum3 = \n1, n2, n3 -> 10 * (makeNum2 n1 n2) + (makeNum1 n3)
        firstNumber =
            when afterMul is
                [n1, ',', ..] if isDigit n1 -> Ok { num: makeNum1 n1, next: List.dropFirst afterMul 2 }
                [n1, n2, ',', ..] if isDigit n1 && isDigit n2 -> Ok { num: makeNum2 n1 n2, next: List.dropFirst afterMul 3 }
                [n1, n2, n3, ',', ..] if isDigit n1 && isDigit n2 && isDigit n3 -> Ok { num: makeNum3 n1 n2 n3, next: List.dropFirst afterMul 4 }
                _ -> Err NoMatch
        when firstNumber is
            Ok { num: num, next: next } ->
                when next is
                    [n1, ')', ..] if isDigit n1 -> Ok (Mul num (makeNum1 n1))
                    [n1, n2, ')', ..] if isDigit n1 && isDigit n2 -> Ok (Mul num (makeNum2 n1 n2))
                    [n1, n2, n3, ')', ..] if isDigit n1 && isDigit n2 && isDigit n3 -> Ok (Mul num (makeNum3 n1 n2 n3))
                    _ -> Err NoMatch
            Err NoMatch -> Err NoMatch
    else
        Err NoMatch

parseDoAndDont = \index, str ->
    sub = List.dropFirst str index
    when sub is
        ['d', 'o', '(', ')', ..] -> Ok Do
        ['d', 'o', 'n', '\'', 't', ..] -> Ok Dont
        _ -> Err NoMatch

parsePart2 = \index, str ->
    doOrDont = parseDoAndDont index str
    mul = parseMul index str
    when (doOrDont, mul) is
        (Ok Do, _) -> Ok Do
        (Ok Dont, _) -> Ok Dont
        (_, Ok (Mul x y)) -> Ok (Mul x y)
        _ -> Err NoMatch

expect parseDoAndDont 0 (Str.toUtf8 "do()") == Ok Do
expect parseDoAndDont 0 (Str.toUtf8 "don't()") == Ok Dont
expect parseDoAndDont 0 (Str.toUtf8 "1don't()") == Err NoMatch
expect parsePart2 0 (Str.toUtf8 "do()") == Ok Do
expect parsePart2 0 (Str.toUtf8 "don't()") == Ok Dont
expect parsePart2 0 (Str.toUtf8 "1don't()") == Err NoMatch
expect parsePart2 0 (Str.toUtf8 "mul(1,2)") == Ok (Mul 1 2)
expect parsePart2 0 (Str.toUtf8 "mul(25,123)") == Ok (Mul 25 123)
expect parsePart2 0 (Str.toUtf8 "mul%(1, 2)") == Err NoMatch

partOne : ParsedType -> Str
partOne = \parsedContent ->
    str = Str.toUtf8 parsedContent
    n = str |> List.len
    List.range { start: At 0, end: Before n }
    |> List.keepOks (\index -> parseMul index str)
    |> List.map \Mul x y -> x * y
    |> List.walk 0 Num.add
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    str = Str.toUtf8 parsedContent
    n = str |> List.len
    List.range { start: At 0, end: Before n }
    |> List.keepOks (\index -> parsePart2 index str)
    |> List.walk {state: Do, acc: 0} (\{state, acc}, element -> when element is
        Mul x y if state == Do -> {state, acc: (acc + x * y)}
        Mul _ _ -> {state, acc}
        Do -> {state: Do, acc}
        Dont -> {state: Dont, acc})
    |> (\{state, acc} -> Num.toStr acc)

expect solve { content: testContent, part: 1 } == "Part 1: 161"
expect solve {content: testContent, part: 2} == "Part 2: 48"


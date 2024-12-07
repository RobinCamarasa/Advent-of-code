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

ParsedType : List { target : I64, options : List I64 }

testContent =
    """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.trim
    |> Str.split "\n"
    |> List.map
        \str ->
            Str.split str ": "
            |>
            \list ->
                when list is
                    [targetStr, optionStr] ->
                        options =
                            optionStr
                            |> Str.split " "
                            |> List.keepOks Str.toI64
                        target =
                            when Str.toI64 targetStr is
                                Ok x -> x
                                _ -> crash "Wrong input format"
                        { target, options }

                    _ -> crash "Wrong input format"

checkPart1 =
    \{ target, options } ->
        when options is
            [a] if a == target -> Bool.true
            [.. as rest, a] ->
                mulOption =
                    if target % a == 0 then
                        checkPart1 { target: target // a, options: rest }
                    else
                        Bool.false
                addOption = checkPart1 { target: target - a, options: rest }
                mulOption || addOption

            _ -> Bool.false

expect checkPart1 { target: 190, options: [10, 19] } == Bool.true

partOne : ParsedType -> Str
partOne = \parsedContent ->
    parsedContent
    |> List.keepIf checkPart1
    |> List.map \{ target } -> target
    |> List.walk 0 Num.add
    |> Num.toStr

getUpperTenPower = \x ->
    if x < 1 then
        1
    else
        10 * (getUpperTenPower (x // 10))

expect getUpperTenPower 0 == 1
expect getUpperTenPower 1 == 10
expect getUpperTenPower 56 == 100
expect getUpperTenPower 526 == 1000

checkPart2 =
    \{ target, options } ->
        when options is
            [a] if a == target -> Bool.true
            [.. as rest, a] if target >= a ->
                mulOption =
                    if target % a == 0 then
                        checkPart2 { target: target // a, options: rest }
                    else
                        Bool.false
                addOption = checkPart2 { target: target - a, options: rest }
                concatOption =
                    upperTenPower = getUpperTenPower a
                    if target % upperTenPower == a then
                        checkPart2 { target: target // upperTenPower, options: rest }
                    else
                        Bool.false
                mulOption || addOption || concatOption

            _ -> Bool.false

expect checkPart2 { target: 190, options: [10, 19] } == Bool.true
expect checkPart2 { target: 7290, options: [6, 8, 6, 15] } == Bool.true

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    parsedContent
    |> List.keepIf checkPart2
    |> List.map \{ target } -> target
    |> List.walk 0 Num.add
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 3749" # TODO 3 Adapt test
expect solve { content: testContent, part: 2 } == "Part 2: 11387"


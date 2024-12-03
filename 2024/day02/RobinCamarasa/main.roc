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
ParsedType : List (List I64)

# TODO 2 add data
testContent =
    """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.split "\n"
    |> List.map (\line -> Str.split line " ")
    |> List.map (\items -> List.keepOks items Str.toI64)
    |> List.keepOks \list -> if List.len list == 0 then Err 1 else Ok list

checkSafety1 = \items ->
    n = List.len items
    mappedItems = List.map2 (List.takeFirst items (n - 1)) (List.takeLast items (n - 1)) (\a, b -> a - b)
    max = List.max? mappedItems
    min = List.min? mappedItems
    absVals = List.map mappedItems Num.abs
    if min < 0 && max >= 0 then
        Err ListWasEmpty
    else if List.min? absVals == 0 || List.max? absVals > 3 then
        Err ListWasEmpty
    else
        Ok mappedItems

# TODO 5 implement
partOne : ParsedType -> Str
partOne = \parsedContent ->
    parsedContent
    |> List.keepOks checkSafety1
    |> List.len
    |> Num.toStr

# checkSafety2 : List I64 -> Bool
checkSafety2 = \items ->
    n = List.len items
    val = (
        List.range { start: At 0, end: Before n }
        |> List.map (\id -> List.dropAt items id)
        |> List.append items
        |> List.map checkSafety1
        |> List.walk
            (Err 1)
            (\state, value ->
                when (state, value) is
                    (_, Ok _) -> Ok 1
                    (Ok _, _) -> Ok 1
                    _ -> Err 1)
    )
    val

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    val = (
        parsedContent
        |> List.keepOks checkSafety2
        |> List.len
        |> Num.toStr
    )
    val

expect solve { content: testContent, part: 1 } == "Part 1: 2" # TODO 3 Adapt test
expect solve { content: testContent, part: 2 } == "Part 2: 4"


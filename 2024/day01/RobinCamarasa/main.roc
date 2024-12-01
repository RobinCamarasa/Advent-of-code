app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br",
}

import pf.Stdout
import "./data/data.txt" as dataContent : Str

main =
    solve { content: dataContent, part: 1 } |> Stdout.line!
    solve { content: dataContent, part: 2 } |> Stdout.line!

solve : { content : Str, part : I64 } -> Str
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

ParsedType : { left : List I64, right : List I64 }

testContent =
    """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

parse : Str -> ParsedType
parse = \content ->
    lines = Str.split content "\n"
    lines
    |> List.map (\str -> Str.split str "   ")
    |> List.keepOks
        (\list ->
            when (List.get list 0, List.get list 1) is
                (Ok left, Ok right) ->
                    when (Str.toI64 left, Str.toI64 right) is
                        (Ok leftNum, Ok rightNum) -> Ok { left: leftNum, right: rightNum }
                        _ -> Err 1

                _ -> Err 1
        )
    |> List.walk
        { left: [], right: [] }
        (
            \{ left: leftList, right: rightList }, { left: left, right: right } -> { left: List.append leftList left, right: List.append rightList right }
        )

partOne : ParsedType -> Str
partOne = \{ left: left, right: right } ->
    leftSorted = List.sortAsc left
    rightSorted = List.sortAsc right
    List.map2 leftSorted rightSorted (\leftVal, rightVal -> (rightVal - leftVal) |> Num.abs)
    |> List.walk 0 Num.add
    |> Num.toStr

count : I64, List I64 -> I64
count = \n, list -> list |> List.walk 0 (\val, item -> if n == item then val + n else val)

partTwo : ParsedType -> Str
partTwo = \{ left: left, right: right } ->
    left |> List.map (\x -> count x right) |> List.walk 0 Num.add |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 11"
expect solve { content: testContent, part: 2 } == "Part 2: 31"


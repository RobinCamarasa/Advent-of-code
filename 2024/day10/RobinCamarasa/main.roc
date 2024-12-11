app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br"
}

import pf.Stdout
import "./data/data.txt" as dataContent : Str

main =
    solve {content: dataContent, part: 1} |> Stdout.line!
    solve {content: dataContent, part: 2} |> Stdout.line!

solve : {content : Str, part: I32} ->  Str
solve = \{content: content, part: part} -> 
    func = when part is
        1 -> partOne
        2 -> partTwo
        _ -> crash "This is not a valid part"
    content
        |> parse
        |> func
        |> \result -> "Part $(Num.toStr part): $(result)"


# TODO 1 change
ParsedType : List (List {row: I64, col: I64})

# TODO 2 add data
testContent =
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content -> 
    parsed = content
        |> Str.trim
        |> Str.split "\n"
        |> List.mapWithIndex
            \row, rowIndex ->
                row
                |> Str.toUtf8
                |> List.mapWithIndex
                    \char, colIndex -> ({row: Num.toI64 rowIndex, col: Num.toI64 colIndex}, char - '0')
        |> List.walk [] List.concat
    filter =
        \list, char ->
            list
            |> List.keepIf
                \(_, char2) -> char2 == char
            |> List.map
                \(coor, _) -> coor
    reversed =
        [
            filter parsed 0,
            filter parsed 1,
            filter parsed 2,
            filter parsed 3,
            filter parsed 4,
            filter parsed 5,
            filter parsed 6,
            filter parsed 7,
            filter parsed 8,
            filter parsed 9,
        ]
    reversed

computeTrails =
    \parsedContent, init ->
        parsedContent
        |> List.dropFirst 1
        |> List.walk
            [init]
            \prev, current ->
                current
                |> List.map
                    \{row: r1, col: c1} ->
                        newNb =
                            prev
                            |> List.keepIf
                                \{row: r2, col: c2} -> Num.abs (r1 - r2) + Num.abs (c1 - c2) == 1
                            |> List.map
                                \{nb} -> nb
                            |> List.sum
                        {row: r1, col: c1, nb: newNb}
                |> List.keepIf
                    \{nb} -> nb != 0
        |> List.map
            \{nb} -> nb

partOne : ParsedType -> Str
partOne = \parsedContent ->
    init =
        when List.get parsedContent 0 is
            Err _ -> crash "wrong input"
            Ok (items) -> items |> List.map \{row, col} -> {row, col, nb: 1}
    init
    |> List.map 
        \in -> 
            computeTrails parsedContent in
            |> List.len
    |> List.sum
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    init =
        when List.get parsedContent 0 is
            Err _ -> crash "wrong input"
            Ok (items) -> items |> List.map \{row, col} -> {row, col, nb: 1}
    init
    |> List.map 
        \in -> 
            computeTrails parsedContent in
            |> List.sum
    |> List.sum
    |> Num.toStr

expect solve {content: testContent, part: 1} == "Part 1: 36" # TODO 3 Adapt test
expect solve {content: testContent, part: 2} == "Part 2: 81"


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

Frequency : U8
Coordinates : { row : I64, col : I64 }
ParsedType : { frequencies : Dict Frequency (Set Coordinates), size : { nRows : I64, nCols : I64 } }

testContent =
    """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

parse : Str -> ParsedType
parse = \content ->
    splittedContent =
        content
        |> Str.trim
        |> Str.split "\n"
    size =
        nRows = List.len splittedContent |> Num.toI64
        nCols =
            List.get splittedContent 0
            |> \list ->
                when list is
                    Ok items -> Str.toUtf8 items |> List.len |> Num.toI64
                    _ -> crash "Wrong input"
        { nRows, nCols }
    frequencies =
        splittedContent
        |> List.mapWithIndex
            \str, row ->
                Str.toUtf8 str
                |> List.mapWithIndex
                    \frequency, col -> { frequency, col }
                |> List.keepOks
                    \{ frequency, col } ->
                        when frequency is
                            '.' -> Err NotAFrequency
                            _ -> Ok { frequency, row: Num.toI64 row, col: Num.toI64 col }
        |> List.walk [] List.concat
        |> List.walk
            (Dict.empty {})
            \dict, { frequency, row, col } ->
                updateSet =
                    \possibleValue ->
                        when possibleValue is
                            Ok set -> Ok (Set.insert set { row, col })
                            _ -> Ok ([{ row, col }] |> Set.fromList)
                Dict.update dict frequency updateSet
    { frequencies, size }

getAntinodes =
    \{ nRows, nCols }, { row: r1, col: c1 }, { row: r2, col: c2 } ->
        delta = { row: r2 - r1, col: c2 - c1 }
        [
            { row: r1 - delta.row, col: c1 - delta.col },
            { row: r2 + delta.row, col: c2 + delta.col },
        ]
        |> List.keepOks
            \{ row, col } ->
                if row == r1 && col == c1 then
                    Err SamePoint
                else if row < 0 || row >= nRows then
                    Err OutOfGrid
                else if col < 0 || col >= nCols then
                    Err OutOfGrid
                else
                    Ok { row, col }

expect getAntinodes { nRows: 10, nCols: 10 } { row: 4, col: 8 } { row: 3, col: 4 } == [{ row: 2, col: 0 }]

# TODO 5 implement
partOne : ParsedType -> Str
partOne = \{ frequencies, size } ->
    antinodes =
        Dict.walk
            frequencies
            (Set.empty {})
            \accSet, _, set ->
                elements = Set.toList set
                newCoor =
                    List.map
                        elements
                        \coor1 ->
                            List.map
                                elements
                                \coor2 -> getAntinodes size coor1 coor2
                    |> List.walk [] List.concat
                    |> List.walk [] List.concat
                    |> Set.fromList
                    |> Set.union accSet
                newCoor
    antinodes
    |> Set.len
    |> Num.toStr

getReasonance =
    \{ nRows, nCols }, { row: r1, col: c1 }, { row: r2, col: c2 } ->
        delta = { row: r2 - r1, col: c2 - c1 }
        List.range { start: At (-nRows), end: At nRows }
        |> List.map
            \k ->
                { row: r1 - k * delta.row, col: c1 - k * delta.col }
        |> List.keepOks
            \{ row, col } ->
                if row == r1 && col == c1 then
                    Err SamePoint
                else if row < 0 || row >= nRows then
                    Err OutOfGrid
                else if col < 0 || col >= nCols then
                    Err OutOfGrid
                else
                    Ok { row, col }

partTwo : ParsedType -> Str
partTwo = \{ frequencies, size } ->
    antinodes =
        Dict.walk
            frequencies
            (Set.empty {})
            \accSet, _, set ->
                elements = Set.toList set
                newCoor =
                    List.map
                        elements
                        \coor1 ->
                            List.map
                                elements
                                \coor2 -> getReasonance size coor1 coor2
                    |> List.walk [] List.concat
                    |> List.walk [] List.concat
                    |> Set.fromList
                    |> Set.union accSet
                newCoor
    antinodes
    |> Set.len
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 14"
expect solve { content: testContent, part: 2 } == "Part 2: 34"


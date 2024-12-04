app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br",
}

import pf.Stdout
import "./data/data.txt" as dataContent : Str
import "./data/test.txt" as testContent : Str

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

ParsedType : { grid : List (List U8), nrows : I64, ncols : I64 }
Direction : [UpLeft, Up, UpRight, Left, Right, DownLeft, Down, DownRight]
allDirections : List Direction
allDirections = [UpLeft, Up, UpRight, Left, Right, DownLeft, Down, DownRight]

getValue =
    \{ gridMeta, shift, position } ->
        { grid, nrows, ncols } = gridMeta
        { row, col } = position
        { direction, steps } = shift
        { row: rowShift, col: colShift } =
            when direction is
                UpLeft -> { row: -1, col: -1 }
                Up -> { row: -1, col: 0 }
                UpRight -> { row: -1, col: 1 }
                Left -> { row: 0, col: -1 }
                Right -> { row: 0, col: 1 }
                DownLeft -> { row: 1, col: -1 }
                Down -> { row: 1, col: 0 }
                DownRight -> { row: 1, col: 1 }
        newRow =
            row
                + Num.toI64 rowShift
                * Num.toI64 steps
                |> Num.toU64Checked?
        newCol =
            col
                + Num.toI64 colShift
                * Num.toI64 steps
                |> Num.toU64Checked?

        List.get? grid newRow
            |> List.get? newCol

checkXMAS = \{ gridMeta, direction, position } ->
    matches =
        "XMAS"
            |> Str.toUtf8
            |> List.mapWithIndex
                \char, index ->
                    if getValue? { gridMeta: gridMeta, shift: { steps: index, direction: direction }, position: position } == char then
                        Ok Match
                    else
                        Err NoMatch
            |> List.keepOks \x -> x
    if List.len matches == 4 then
        Ok { direction, position }
    else
        Err NoMatch

checkXMAS2 = \{ gridMeta, position } ->
    center = getValue { gridMeta, shift: { steps: 0, direction: Up }, position }
    when center is
        Ok 'A' ->
            neededSet = Set.fromList ['M', 'S']
            firstDiag =
                List.keepOks
                    [
                        getValue { gridMeta, shift: { steps: 1, direction: UpLeft }, position },
                        getValue { gridMeta, shift: { steps: 1, direction: DownRight }, position },
                    ]
                    \x -> x
                |> Set.fromList
            secondDiag =
                List.keepOks
                    [
                        getValue { gridMeta, shift: { steps: 1, direction: UpRight }, position },
                        getValue { gridMeta, shift: { steps: 1, direction: DownLeft }, position },
                    ]
                    \x -> x
                |> Set.fromList
            if neededSet == firstDiag && neededSet == secondDiag then
                Ok position
            else
                Err NoTheRightDiagonals

        _ -> Err NoCenteredA

parse : Str -> ParsedType
parse = \content ->
    grid =
        content
        |> Str.trim
        |> Str.split "\n"
        |> List.map Str.toUtf8
    nrows = List.len grid |> Num.toI64
    ncols =
        when List.get grid 0 is
            Ok list -> List.len list |> Num.toI64
            Err _ -> Num.toI64 0
    { grid, nrows, ncols }

partOne : ParsedType -> Str
partOne = \gridMeta ->
    { grid, nrows, ncols } = gridMeta
    positions =
        List.range { start: At 0, end: Before nrows }
        |> List.map
            \row ->
                List.range { start: At 0, end: Before ncols }
                |> List.map
                    \col -> { row: Num.toI64 row, col: Num.toI64 col }
        |> List.walk [] List.concat
    positions
    |> List.map
        \position ->
            List.keepOks
                allDirections
                (\direction -> checkXMAS { gridMeta, direction, position })
    |> List.walk [] List.concat
    |> List.len
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \gridMeta ->
    { grid, nrows, ncols } = gridMeta
    positions =
        List.range { start: At 0, end: Before nrows }
        |> List.map
            \row ->
                List.range { start: At 0, end: Before ncols }
                |> List.map
                    \col -> { row: Num.toI64 row, col: Num.toI64 col }
        |> List.walk [] List.concat

    positions
    |> List.keepOks
        \position -> checkXMAS2 { gridMeta, position }
    |> List.len
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 18"


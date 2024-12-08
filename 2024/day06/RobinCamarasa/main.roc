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

Direction : [Up, Right, Down, Left, NoDirection]
Size : { row : U64, col : U64 }
Coor : { row : I64, col : I64 }
ObstaclePositions : List (List I64)
ParsedType : { x : ObstaclePositions, y : ObstaclePositions, cursor : Coor, nonCursor : Set Coor, direction : Direction, size : Size }

# TODO 2 add data
testContent =
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

# TODO 4 implement and do basic test
# parse : Str -> ParsedType

toY =
    \{ row: nCols }, set ->
        sortedItems =
            set
            |> Set.toList
            |> List.sortWith
                \{ row: r1, col: c1 }, { row: r2, col: c2 } ->
                    if r1 < r2 then
                        LT
                    else if r1 > r2 then
                        GT
                    else if c1 > c2 then
                        GT
                    else if c1 < c2 then
                        LT
                    else
                        EQ
        List.range { start: At 0, end: Before nCols }
        |> List.map Num.toI64
        |> List.map
            \colIndex ->
                sortedItems
                |> List.keepIf
                    \{ col } -> col == colIndex
                |> List.map
                    \{ row } -> row

toX =
    \{ row: nRows }, set ->
        sortedItems =
            set
            |> Set.toList
            |> List.sortWith
                \{ row: r1, col: c1 }, { row: r2, col: c2 } ->
                    if c1 < c2 then
                        LT
                    else if c1 > c2 then
                        GT
                    else if r1 > r2 then
                        GT
                    else if r1 < r2 then
                        LT
                    else
                        EQ
        List.range { start: At 0, end: Before nRows }
        |> List.map Num.toI64
        |> List.map
            \rowIndex ->
                sortedItems
                |> List.keepIf
                    \{ row } -> row == rowIndex
                |> List.map
                    \{ col } -> col

parse = \content ->
    splitContent =
        content
        |> Str.trim
        |> Str.split "\n"
    nRows = List.len splitContent |> Num.toU64
    nCols =
        when List.get splitContent 0 is
            Ok str -> str |> Str.toUtf8 |> List.len |> Num.toU64
            _ -> crash "The input is empty"

    simplifiedFormat =
        splitContent
        |> List.mapWithIndex
            \str, indexRow ->
                str
                |> Str.toUtf8
                |> List.mapWithIndex
                    \char, indexCol -> (char, { row: Num.toI64 indexRow, col: Num.toI64 indexCol })
                |> List.keepIf
                    \(char, _) -> char == '#' || char == '^'
    cursor =
        simplifiedFormat
        |> List.walk [] List.concat
        |> List.keepIf
            \(char, _) -> char == '^'
        |> \list ->
            when list is
                [(char, coor)] -> coor
                _ -> crash "The input have more than one cursor"

    nonCursor =
        simplifiedFormat
        |> List.walk [] List.concat
        |> List.keepIf
            \(char, _) -> char == '#'
        |> List.map \(_, coor) -> coor
        |> Set.fromList

    x = toX { row: nRows, col: nCols } nonCursor
    y = toY { row: nRows, col: nCols } nonCursor

    { x, y, nonCursor, cursor: cursor, size: { row: nRows, col: nCols }, direction: Up }

testParsedContent = parse testContent
testNonCursor =
    [
        { col: 4, row: 0 },
        { col: 9, row: 1 },
        { col: 2, row: 3 },
        { col: 7, row: 4 },
        { col: 1, row: 6 },
        { col: 8, row: 7 },
        { col: 0, row: 8 },
        { col: 6, row: 9 },
    ]
    |> Set.fromList

expect
    testParsedContent
    == {
        x: [[4], [9], [], [2], [7], [], [1], [8], [0], [6]],
        y: [[8], [6], [3], [], [0], [], [9], [4], [7], [1]],
        nonCursor: testNonCursor,
        cursor: { row: 6, col: 4 },
        direction: Up,
        size: { row: 10, col: 10 },
    }

getNextStage =
    \{ x, y, size }, { cursor, direction } ->
        val =
            when direction is
                Up ->
                    when List.get y (Num.toU64 cursor.col) is
                        Ok obstaclesIndices ->
                            obstaclesIndices
                            |> List.keepIf
                                \value -> value < cursor.row
                            |> \list ->
                                when list is
                                    [.., a] -> { cursor: { row: (a + 1), col: cursor.col }, direction: Right }
                                    [] -> { cursor: { row: -1, col: cursor.col }, direction: NoDirection }

                        _ -> crash "Should not happen"

                Right ->
                    when List.get x (Num.toU64 cursor.row) is
                        Ok obstaclesIndices ->
                            obstaclesIndices
                            |> List.keepIf
                                \value -> value > cursor.col
                            |> \list ->
                                when list is
                                    [a, ..] -> { cursor: { row: cursor.row, col: a - 1 }, direction: Down }
                                    [] -> { cursor: { row: cursor.row, col: Num.toI64 size.col }, direction: NoDirection }

                        _ -> crash "Should not happen"

                Down ->
                    when List.get y (Num.toU64 cursor.col) is
                        Ok obstaclesIndices ->
                            obstaclesIndices
                            |> List.keepIf
                                \value -> value > cursor.row
                            |> \list ->
                                when list is
                                    [a, ..] -> { cursor: { row: (a - 1), col: cursor.col }, direction: Left }
                                    [] -> { cursor: { row: 10, col: cursor.col }, direction: NoDirection }

                        _ -> crash "Should not happen"

                Left ->
                    when List.get x (Num.toU64 cursor.row) is
                        Ok obstaclesIndices ->
                            obstaclesIndices
                            |> List.keepIf
                                \value -> value < cursor.col
                            |> \list ->
                                when list is
                                    [.., a] -> { cursor: { row: cursor.row, col: a + 1 }, direction: Up }
                                    [] -> { cursor: { row: cursor.row, col: -1 }, direction: NoDirection }

                        _ -> crash "Should not happen"

                NoDirection -> crash "Should not happen"
        val

expect { cursor: { row: 1, col: 4 }, direction: Right } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: testParsedContent.cursor, direction: testParsedContent.direction }
expect { cursor: { row: -1, col: 3 }, direction: NoDirection } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 3, col: 3 }, direction: Up }
expect { cursor: { row: 1, col: 8 }, direction: Down } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 1, col: 5 }, direction: Right }
expect { cursor: { row: 2, col: 10 }, direction: NoDirection } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 2, col: 3 }, direction: Right }
expect { cursor: { row: 10, col: 2 }, direction: NoDirection } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 4, col: 2 }, direction: Down }
expect { cursor: { row: 5, col: 1 }, direction: Left } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 4, col: 1 }, direction: Down }
expect { cursor: { row: 2, col: -1 }, direction: NoDirection } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 2, col: 4 }, direction: Left }
expect { cursor: { row: 3, col: 3 }, direction: Up } == getNextStage { x: testParsedContent.x, y: testParsedContent.y, size: testParsedContent.size } { cursor: { row: 3, col: 4 }, direction: Left }

getWalk : { x : ObstaclePositions, y : ObstaclePositions, size : Size }, { cursor : Coor, direction : Direction }, List { cursor : Coor, direction : Direction } -> List { cursor : Coor, direction : Direction }
getWalk =
    \meta, stage, acc ->
        nextStage = getNextStage meta stage
        nextAcc = List.append acc nextStage
        when nextStage.direction is
            NoDirection -> nextAcc
            _ -> getWalk meta nextStage nextAcc

isIn =
    \c, (a, b) -> Num.min a b <= c && c <= Num.max a b

getIntersection =
    \({ row: r1, col: c1 }, { row: r2, col: c2 }), ({ row: r3, col: c3 }, { row: r4, col: c4 }) ->
        if r1 == r2 && c3 == c4 && isIn r1 (r3, r4) && isIn c3 (c1, c2) then
            Ok { row: r2, col: c4 }
        else if c1 == c2 && r3 == r4 && isIn c1 (c3, c4) && isIn r3 (r1, r2) then
            Ok { row: r4, col: c2 }
        else
            Err NoIntersection

expect Ok { row: 5, col: 6 } == getIntersection ({ row: 4, col: 6 }, { row: 10, col: 6 }) ({ row: 5, col: 6 }, { row: 5, col: 10 })

getDistance =
    \{ row: r1, col: c1 }, { row: r2, col: c2 } ->
        Num.abs (r1 - r2) + Num.abs (c1 - c2)

partOne : ParsedType -> Str
partOne = \parsedContent ->
    { x, y, cursor, direction, size } = parsedContent
    walk = getWalk { x, y, size } { cursor, direction } [{ cursor, direction }]
    n = List.len walk
    paired =
        List.map2
            (List.takeFirst walk (n - 1))
            (List.takeLast walk (n - 1))
            \{ cursor: { row: r1, col: c1 } }, { cursor: { row: r2, col: c2 } } -> ({ row: r1, col: c1 }, { row: r2, col: c2 })
    distance =
        paired
        |> List.mapWithIndex
            \(coor1, coor2), index ->
                dist = getDistance coor1 coor2
                previous =
                    if index > 1 then
                        List.takeFirst paired (index - 1)
                    else
                        []
                nbIntersection =
                    List.keepOks
                        previous
                        \(coor3, coor4) -> getIntersection (coor1, coor2) (coor3, coor4)
                    |> Set.fromList
                    |> Set.len
                    |> Num.toI64
                dist - nbIntersection
        |> List.walk 0 Num.add
    Num.toStr distance

getWalk2 =
    \meta, stage, acc ->
        nextStage = getNextStage meta stage
        nextAcc = List.append acc nextStage
        if List.contains acc nextStage then
            Err Cycle
        else
            when nextStage.direction is
                NoDirection -> Ok nextAcc
                _ ->
                    when getWalk2 meta nextStage nextAcc is
                        Err Cycle -> Err Cycle
                        Ok value -> Ok value

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    { x, y, nonCursor, cursor, direction, size } = parsedContent
    { row: nRows, col: nCols } = size
    potentialObstacles =
        List.range { start: At 0, end: Before nRows }
        |> List.map Num.toI64
        |> List.map
            \row ->
                List.range { start: At 0, end: Before nCols }
                |> List.map Num.toI64
                |> List.map
                    \col -> { row, col }
        |> List.walk [] List.concat
        |> Set.fromList
        |> Set.difference nonCursor
        |> Set.remove cursor
    potentialObstacles
    |> Set.toList
    |> List.keepErrs
        \newObstacle ->
            newNonCursors = Set.insert nonCursor newObstacle
            newX = toX size newNonCursors
            newY = toY size newNonCursors
            walk = getWalk2 { x: newX, y: newY, size } { cursor, direction } [{ cursor, direction }]
            walk
    |> List.len
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 41"
expect solve { content: testContent, part: 2 } == "Part 2: 6"


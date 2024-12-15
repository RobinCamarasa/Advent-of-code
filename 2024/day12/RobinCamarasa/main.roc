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

ParsedType : Dict U8 (Set { row : I64, col : I64 })

testContent =
    """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.trim
    |> Str.split "\n"
    |> List.map Str.toUtf8
    |> List.mapWithIndex
        \row, rowIndex ->
            row
            |> List.mapWithIndex
                \char, colIndex -> (char, { row: Num.toI64 rowIndex, col: Num.toI64 colIndex })
    |> List.walk [] List.concat
    |> List.walk
        (Dict.empty {})
        \grid, (char, rowCol) ->
            when Dict.get grid char is
                Ok set ->
                    Dict.insert
                        grid
                        char
                        (Set.insert set rowCol)

                Err _ ->
                    Dict.insert
                        grid
                        char
                        (Set.single rowCol)

findConnected =
    \{ node, set, acc } ->
        { row: r1, col: c1 } = node
        newAcc = Set.insert acc node
        neighbours =
            [
                { row: r1 - 1, col: c1 },
                { row: r1 + 1, col: c1 },
                { row: r1, col: c1 - 1 },
                { row: r1, col: c1 + 1 },
            ]
            |> Set.fromList
        intersection =
            Set.intersection
                set
                neighbours
        remaining =
            Set.difference
                set
                neighbours
            |> Set.remove node
        Set.walk
            intersection
            { set: remaining, acc: newAcc }
            \{ set: stepSet, acc: stepAcc }, stepNode ->
                findConnected { node: stepNode, set: stepSet, acc: stepAcc }

testSet =
    [
        { row: 1, col: 1 },
        { row: 2, col: 1 },
        { row: 2, col: 2 },
        { row: 3, col: 1 },
        { row: 2, col: 0 },
        { row: 0, col: 0 },
        { row: 5, col: 6 },
    ]
    |> Set.fromList

expect findConnected { node: { row: 2, col: 2 }, set: testSet, acc: Set.empty {} } == { set: [{ row: 0, col: 0 }, { row: 5, col: 6 }] |> Set.fromList, acc: [{ col: 2, row: 2 }, { col: 1, row: 2 }, { col: 1, row: 1 }, { col: 1, row: 3 }, { col: 0, row: 2 }] |> Set.fromList }

partition =
    \set ->
        Set.walk
            set
            { remaining: set, acc: [] }
            \stepState, node ->
                { remaining: stepRemaining, acc: stepAcc } = stepState
                if !(Set.contains stepRemaining node) then
                    stepState
                else
                    { set: newRemaining, acc: newAccElement } = findConnected { node: node, set: stepRemaining, acc: Set.empty {} }
                    { remaining: newRemaining, acc: List.append stepAcc newAccElement }
        |> \{ acc } -> acc

getArea =
    \set -> Set.len set

getPerimeter =
    \set ->
        Set.walk
            set
            0
            \acc, node ->
                { row: r1, col: c1 } = node
                [
                    { row: r1 - 1, col: c1 },
                    { row: r1 + 1, col: c1 },
                    { row: r1, col: c1 - 1 },
                    { row: r1, col: c1 + 1 },
                ]
                |> Set.fromList
                |> Set.difference set
                |> Set.len
                |> \nbOutOfSetNeighbours -> acc + nbOutOfSetNeighbours

isCorner =
    \{ set, node, orientation } ->
        { row: r1, col: c1 } = node
        { row: dr1, col: dc1 } = orientation
        containsDiag = Set.contains set { row: r1 + dr1, col: c1 + dc1 }
        containsRow = Set.contains set { row: r1 + dr1, col: c1 }
        containsCol = Set.contains set { row: r1, col: c1 + dc1 }
        ((containsRow == containsCol) && !containsDiag) || (!containsRow && !containsCol)

getCorners =
    \set ->
        Set.walk
            set
            0
            \acc, node ->
                [
                    { row: -1, col: -1 },
                    { row: 1, col: 1 },
                    { row: -1, col: 1 },
                    { row: 1, col: -1 },
                ]
                |> List.keepIf \orientation -> isCorner { set, node, orientation }
                |> List.len
                |> \nbCorners -> acc + nbCorners

partOne : ParsedType -> Str
partOne = \parsedContent ->
    partitionedContent =
        parsedContent
        |> Dict.map
            \_, set -> partition set
    partitionedContent
    |> Dict.map
        \_, setList ->
            List.map
                setList
                \set -> (getArea set) * (getPerimeter set)
    |> Dict.values
    |> List.walk [] List.concat
    |> List.sum
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    partitionedContent =
        parsedContent
        |> Dict.map
            \_, set -> partition set
    partitionedContent
    |> Dict.map
        \_, setList ->
            List.map
                setList
                \set -> (getArea set) * (getCorners set)
    |> Dict.values
    |> List.walk [] List.concat
    |> List.sum
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 1930"
expect solve { content: testContent, part: 2 } == "Part 2: 1206"


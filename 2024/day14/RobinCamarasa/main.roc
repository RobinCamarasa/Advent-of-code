app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br",
}

import pf.Stdout
import "./data/data.txt" as dataContent : Str

Size : { sx : I64, sy : I64 }

main =
    # solve {content: dataContent, part: 1, size: {sx: 101, sy: 103}} |> Stdout.line!
    solve { content: dataContent, part: 2, size: { sx: 101, sy: 103 } } |> Stdout.line!

solve : { content : Str, part : I32, size : Size } -> Str
solve = \{ content: content, part: part, size } ->
    func =
        when part is
            1 -> partOne
            2 -> partTwo
            _ -> crash "This is not a valid part"
    content
    |> parse
    |> func size
    |> \result -> "Part $(Num.toStr part): $(result)"

# TODO 1 change
ParsedType : List { px : I64, py : I64, vx : I64, vy : I64 }

# TODO 2 add data
testContent =
    """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.trim
    |> Str.split "\n"
    |> List.map
        \str ->
            str
            |> Str.replaceFirst "p=" ""
            |> Str.replaceFirst "v=" ""
            |> Str.split " "
            |> List.map
                \subStr ->
                    subStr
                    |> Str.split ","
                    |> List.keepOks Str.toI64
    |> List.keepOks
        \lists ->
            when lists is
                [[px, py], [vx, vy]] -> Ok { px, py, vx, vy }
                _ -> Err WrongFormatting

update =
    \robot, size, nbIteration ->
        { sx, sy } = size
        List.range { start: At 0, end: Before nbIteration }
        |> List.walk
            [robot]
            \list, _ ->
                when list is
                    [.., { px, py, vx, vy }] as acc ->
                        List.append
                            acc
                            { px: (px + vx) % sx, py: (py + vy) % sy, vx, vy }

                    _ -> crash "Impossible"

updateRobots =
    \robotPositions, size ->
        { sx, sy } = size
        List.map
            robotPositions
            \{ px, py, vx, vy } ->
                { px: (px + vx) % sx, py: (py + vy) % sy, vx, vy }

makePositive =
    \{ px, py, vx, vy }, { sx, sy } ->
        { px, py, vx: (vx + sx) % sx, vy: (vy + sy) % sy }

getQuadrant =
    \{ px, py }, { sx, sy } ->
        midX = sx // 2
        midY = sy // 2
        if px < midX && py < midY then
            Ok Q1
        else if px > midX && py < midY then
            Ok Q2
        else if px < midX && py > midY then
            Ok Q3
        else if px > midX && py > midY then
            Ok Q4
        else
            Err NotInQuadrant

getSafetyFactor =
    \list ->
        nbQ1 = List.keepIf list (\el -> el == Q1) |> List.len
        nbQ2 = List.keepIf list (\el -> el == Q2) |> List.len
        nbQ3 = List.keepIf list (\el -> el == Q3) |> List.len
        nbQ4 = List.keepIf list (\el -> el == Q4) |> List.len
        nbQ1 * nbQ2 * nbQ3 * nbQ4

# TODO 5 implement
partOne : ParsedType, Size -> Str
partOne = \parsedContent, size ->
    parsedContent
    |> List.map
        \robot -> makePositive robot size
    |> List.keepOks
        \robot ->
            update robot size 100
            |> List.last
    |> List.keepOks
        \robot ->
            getQuadrant robot size
    |> getSafetyFactor
    |> Num.toStr

toStr =
    \robotPositions, size ->
        { sx, sy } = size
        grid =
            List.range { start: At 0, end: Before sx }
            |> List.map
                \_ ->
                    List.range { start: At 0, end: Before sy }
                    |> List.map
                        \_ -> ' '
        val =
            List.walk
                robotPositions
                grid
                \prevGrid, { px, py, vx, vy } ->
                    when List.get prevGrid (Num.toU64 px) is
                        Ok list ->
                            List.set
                                prevGrid
                                (Num.toU64 px)
                                (List.set list (Num.toU64 py) 'X')

                        Err _ ->
                            dbg (px, py)

                            crash "Impossible"
            |> List.keepOks Str.fromUtf8
            |> Str.joinWith "\n"
            |> Str.concat "\n\n==================================\n\n"
        Str.concat "\n\n" val

partTwo : ParsedType, Size -> Str
partTwo = \parsedContent, size ->
    robotPositions =
        parsedContent
        |> List.map
            \robot -> makePositive robot size
    _ = List.walk
        (List.range { start: At 0, end: Before 200000 })
        robotPositions
        \prevRobotPositions, n ->
            val = prevRobotPositions |> List.map (\{ px, py } -> { px, py }) |> Set.fromList |> Set.len
            _ =
                if n % 103 == 27 then
                    dbg n

                    dbg toStr prevRobotPositions size

                    1
                else
                    1
            # _ =
            #         1
            #     else
            #         1
            updateRobots prevRobotPositions size
    "This has to be visually assessed"

expect solve { content: testContent, part: 1, size: { sx: 11, sy: 7 } } == "Part 1: 12"

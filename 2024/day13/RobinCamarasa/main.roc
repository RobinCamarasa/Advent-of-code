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
ParsedType : List { buttonA : { x : I64, y : I64 }, buttonB : { x : I64, y : I64 }, prize : { x : I64, y : I64 } }

# TODO 2 add data
testContent =
    """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.trim
    |> Str.split "\n\n"
    |> List.keepOks
        \str ->
            toXY =
                \list ->
                    when list is
                        [x, y] -> { x, y }
                        _ -> crash "Invalid input"
            when Str.split str "\n" is
                [buttonA, buttonB, prizes] ->
                    Ok {
                        buttonA: buttonA
                        |> Str.dropPrefix "Button A: X+"
                        |> Str.split ", Y+"
                        |> List.keepOks Str.toI64
                        |> toXY,
                        buttonB: buttonB
                        |> Str.dropPrefix "Button B: X+"
                        |> Str.split ", Y+"
                        |> List.keepOks Str.toI64
                        |> toXY,
                        prize: prizes
                        |> Str.dropPrefix "Prize: X="
                        |> Str.split ", Y="
                        |> List.keepOks Str.toI64
                        |> toXY,
                    }

                _ -> Err WrongInput

solveClawMachine =
    \{ buttonA: { x: xa, y: ya }, buttonB: { x: xb, y: yb }, prize: { x: xp, y: yp } } ->
        denominator = xa * yb - xb * ya
        nbNumeratorA = yb * xp - xb * yp
        nbNumeratorB = xa * yp - ya * xp
        if (nbNumeratorA % denominator) == 0 && (nbNumeratorB % denominator) == 0 then
            nbA = nbNumeratorA // denominator
            nbB = nbNumeratorB // denominator
            if (nbA >= 0 && nbB >= 0) then
                Ok { nbA, nbB }
            else
                Err NoPositiveSolution
        else
            Err NoIntegerSolution
# Based on the data delta is never 0

# TODO 5 implement
partOne : ParsedType -> Str
partOne = \parsedContent ->
    parsedContent
    |> List.keepOks
        \x -> solveClawMachine x
    |> List.keepIf
        \{ nbA, nbB } -> (nbA <= 100) && (nbB <= 100)
    |> List.map
        \{ nbA, nbB } -> 3 * nbA + nbB
    |> List.sum
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    addedValue = 10000000000000
    parsedContent
    |> List.map
        \{ buttonA, buttonB, prize } ->
            { buttonA, buttonB, prize: { x: prize.x + addedValue, y: prize.y + addedValue } }
    |> List.keepOks
        \x -> solveClawMachine x
    |> List.map
        \{ nbA, nbB } -> 3 * nbA + nbB
    |> List.sum
    |> Num.toStr
    |> \val ->
        dbg val

        val

expect solve { content: testContent, part: 1 } == "Part 1: 480"
# expect solve {content: testContent, part: 2} == "Part 2: 480"


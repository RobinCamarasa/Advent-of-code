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


drop0 =
    \list ->
        when list is
            [] -> [0]
            [.. as rest, 0] -> drop0 rest
            _ -> list


multiplyBy2024 =
    \list ->
        {acc: accumulator, carried: carriedValue} =
            List.map3
                (list
                |> List.append(0)
                |> List.append(0)
                |> List.append(0)
                |> List.map \x -> x * 4)
                (list
                |> List.prepend(0)
                |> List.append(0)
                |> List.append(0)
                |> List.map \x -> x * 2)
                (list
                |> List.prepend(0)
                |> List.prepend(0)
                |> List.prepend(0)
                |> List.map \x -> x * 2)
                \x, y, z -> x + y + z
                |> List.walk
                    {acc: [], carried: 0}
                    \{acc: localAcc, carried: localCarried}, val ->
                        {
                            acc: localAcc |> List.append ((localCarried + val) % 10),
                            carried: (localCarried + val) // 10
                        }
        if carriedValue == 0 then
            accumulator
            |> drop0
        else
            accumulator
            |> List.append carriedValue
            |> drop0

expect multiplyBy2024 [3, 1]  == [2, 1, 3, 6, 2]
expect multiplyBy2024 [9]  == [6, 1, 2, 8, 1]
expect multiplyBy2024 [0]  == [0]

# TODO 1 change
ParsedType : List (List U8)

# TODO 2 add data
testContent =
    """
    125 17
    """

getNext =
    \val ->
        n = List.len val
        when val is
            [0] -> [[1]]
            list if n % 2 == 0 -> [List.takeFirst list (n//2) |> drop0, List.takeLast list (n//2) |> drop0]
            _ -> [multiplyBy2024 val]

expect getNext [0] == [[1]]
expect getNext [1] == [[4, 2, 0, 2]]
expect getNext [5, 6] == [[5], [6]]

parse : Str -> ParsedType
parse = \content ->
    content
    |> Str.trim
    |> Str.split " "
    |> List.map
        \str -> 
            str 
            |> Str.toUtf8
            |> List.map
                \el -> el - '0'
            |> List.reverse

expect parse testContent == [[5, 2, 1], [7, 1]]

nextStones =
    \dict ->
        dict
        |> Dict.map
            \stone, number ->
                List.map
                    (getNext stone)
                    \newStone -> (newStone, number)
        |> Dict.values
        |> List.walk [] List.concat
        |> List.walk
            (Dict.empty {})
            \state, (key, value) ->
                when Dict.get state key is
                    Ok nb ->
                        state
                        |> Dict.insert key (nb+value)
                    Err _ ->
                        state
                        |> Dict.insert key value

partOne : ParsedType -> Str
partOne = \parsedContent ->
    init =
        parsedContent
        |> List.map
            \value -> (value, 1)
        |> Dict.fromList
    List.range {start: At 0, end: Before 25}
    |> List.walk
        init
        \state, _ ->
            nextStones state
    |> Dict.values
    |> List.sum
    |> Num.toStr

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    init =
        parsedContent
        |> List.map
            \value -> (value, 1)
        |> Dict.fromList
    List.range {start: At 0, end: Before 75}
    |> List.walk
        init
        \state, _ ->
            nextStones state
    |> Dict.values
    |> List.sum
    |> Num.toStr

expect solve {content: testContent, part: 1} == "Part 1: 55312"


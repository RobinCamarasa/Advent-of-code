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
ParsedType : { rules : Set { before : I64, after : I64 }, prints : List (List I64) }

# TODO 2 add data
testContent =
    """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47\n
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content ->
    splitContent = Str.split content "\n\n"
    rules =
        List.get splitContent 0
        |> \x ->
            when x is
                Ok val -> val
                Err _ -> crash "Error input"
        |> Str.split "\n"
        |> List.map
            \ruleStr ->
                Str.split ruleStr "|"
                |> List.map Str.toI64
        |> List.keepOks
            \list ->
                when list is
                    [Ok before, Ok after] -> Ok { before, after }
                    _ -> Err NoMatch
        |> Set.fromList

    prints =
        List.get splitContent 1
        |> \x ->
            when x is
                Ok val -> val
                Err _ -> crash "Error input"
        |> Str.split "\n"
        |> List.map
            \printStr ->
                Str.split printStr ","
                |> List.keepOks Str.toI64
    { rules, prints }

isCorrect = \{ rules, print } ->
    test =
        print
        |> List.mapWithIndex
            \page, index ->
                if index >= 1 then
                    List.takeFirst print index
                    |> List.walk
                        (Ok Valid)
                        \previous, beforePage ->
                            when (previous, Set.contains rules { before: page, after: beforePage }) is
                                (Ok Valid, val) if !val -> Ok Valid
                                _ -> Err Invalid
                else
                    Ok Valid
        |> List.keepOks (\x -> x)
    if List.len test == List.len print then
        Ok print
    else
        Err print

getMidValue = \list ->
    n = List.len list
    if n % 2 == 0 then
        Err Even
    else
        List.get list (n // 2)

parsed = parse testContent
expect Ok [75, 47, 61, 53, 29] == isCorrect { rules: parsed.rules, print: [75, 47, 61, 53, 29] }

partOne : ParsedType -> Str
partOne = \{ rules, prints } ->
    val =
        prints
        |> List.dropLast 1
        |> List.keepOks
            \print -> isCorrect { rules, print }
        |> List.keepOks getMidValue
        |> List.walk 0 Num.add
        |> Num.toStr
    val

reOrder = \{ rules, print } ->
    graph =
        print
        |> List.map
            \page ->
                neighbours =
                    print
                    |> List.keepOks
                        \otherPage ->
                            if Set.contains rules { before: page, after: otherPage } then
                                Ok otherPage
                            else
                                Err NotFound
                { node: page, neighbours: Set.fromList neighbours }
        |> List.walk
            (Dict.empty {})
            \state, { node, neighbours } ->
                state
                |> Dict.insert node neighbours
    reOrderGraph { acc: [], rules, graph }

reOrderGraph = \{ acc, rules, graph } ->
    when Dict.len graph is
        0 -> Ok acc
        _ ->
            emptyKeys =
                graph
                |> Dict.keepIf
                    \(_, value) -> Set.len value == 0
                |> Dict.keys
            when emptyKeys is
                [key] ->
                    newGraph =
                        graph
                        |> Dict.remove key
                        |> Dict.map
                            \_, value ->
                                value
                                |> Set.remove key
                    reOrderGraph { acc: List.append acc key, rules, graph: newGraph }

                _ -> Err WrongGraphStructure

testGraph =
    Dict.empty {}
    |> Dict.insert
        97
        (Set.fromList [13, 75, 29, 47])
    |> Dict.insert
        13
        (Set.fromList [])
    |> Dict.insert
        75
        (Set.fromList [13, 29, 47])
    |> Dict.insert
        29
        (Set.fromList [13])
    |> Dict.insert
        47
        (Set.fromList [13, 29])

expect Ok [13, 29, 47, 75, 97] == reOrderGraph { acc: [], rules: parsed.rules, graph: testGraph }

partTwo : ParsedType -> Str
partTwo = \{ rules, prints } ->
    prints
    |> List.dropLast 1
    |> List.keepErrs
        \print -> isCorrect { rules, print }
    |> List.keepOks
        \print -> reOrder { rules, print }
    |> List.keepOks getMidValue
    |> List.walk 0 Num.add
    |> Num.toStr

expect solve { content: testContent, part: 1 } == "Part 1: 143"
expect solve { content: testContent, part: 2 } == "Part 2: 123"


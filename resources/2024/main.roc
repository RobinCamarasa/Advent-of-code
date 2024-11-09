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
ParsedType : List U32

# TODO 2 add data
testContent =
    """
    """

# TODO 4 implement and do basic test
parse : Str -> ParsedType
parse = \content -> 
    crash "Not implemented"

# TODO 5 implement
partOne : ParsedType -> Str
partOne = \parsedContent ->
    crash "Not implemented"

partTwo : ParsedType -> Str
partTwo = \parsedContent ->
    crash "Not implemented"

expect solve {content: testContent, part: 1} == "Part 1: ??" # TODO 3 Adapt test
# expect solve {content: testContent, part: 2} == "Part 2: 30"


app "advent-13"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

Val : [IntVal U32, ListVal (List Val)]

Pair : { left : Val, right : Val }

filename = "13.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await

        p1 = parse1 inputStr |> part1 |> Num.toStr
        p2 = parse2 inputStr |> part2 |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \error ->
        when error is
            ParseError msg -> crash "Parse error: \(msg)"
            _ -> crash "Failed to read input"

part1 : List Pair -> Nat
part1 = \pairs ->
    List.mapWithIndex pairs \pair, i -> { i: i + 1, order: compare pair }
    |> List.keepIf \p -> p.order == LT
    |> List.map .i
    |> List.sum

part2 : List Val -> Nat
part2 = \packets ->
    # not adding this signature segfaults the compiler
    dividerPackets : List Val
    dividerPackets = [ListVal [ListVal [IntVal 2]], ListVal [ListVal [IntVal 6]]]

    List.join [dividerPackets, packets]
    |> memesort
    |> List.mapWithIndex \packet, i -> { packet, i: i + 1 }
    |> List.keepIf \{ packet } -> List.contains dividerPackets packet
    |> List.map .i
    |> List.product

# List.sortWith \left, right -> compare { left, right }
memesort : List Val -> List Val
memesort = \list ->
    when List.first list is
        Ok right ->
            tail = List.dropFirst list
            lesser = List.keepIf tail \left -> compare { left, right } == LT
            greater = List.dropIf tail \left -> compare { left, right } == LT

            List.join [memesort lesser, [right], memesort greater]

        _ -> []

compare : Pair -> [LT, GT, EQ]
compare = \pair ->
    when pair is
        { left: IntVal left, right: IntVal right } -> Num.compare left right
        { left: IntVal _, right: ListVal _ } -> compare { left: ListVal [pair.left], right: pair.right }
        { left: ListVal _, right: IntVal _ } -> compare { left: pair.left, right: ListVal [pair.right] }
        { left: ListVal l, right: ListVal r } ->
            final =
                state, current <- List.map2 l r (\left, right -> { left, right }) |> List.walk EQ
                if state == EQ then
                    compare current
                else
                    state

            if final == EQ then
                Num.compare (List.len l) (List.len r)
            else
                final

parse1 : Str -> List Pair
parse1 = \inputStr ->
    Str.toScalars inputStr |> parsePairs []

parse2 : Str -> List Val
parse2 = \inputStr ->
    Str.toScalars inputStr |> parseLists []

parsePairs = \chars, acc ->
    { value: left, rest: restLeft } = parseList chars
    { value: right, rest: restRight } = parseNewline restLeft |> parseList

    newAcc = List.append acc { left, right }

    when restRight is
        ['\n', '\n', ..] -> List.drop restRight 2 |> parsePairs newAcc
        [] -> newAcc
        _ -> crash "expecting two newlines or EOF"

parseNewline = \chars ->
    when List.first chars is
        Ok '\n' -> List.dropFirst chars
        _ -> crash "expecting a newline"

parseLists = \chars, acc ->
    when List.first chars is
        Ok '[' ->
            { value, rest } = parseList chars

            parseLists rest (List.append acc value)

        Ok '\n' ->
            parseNewline chars |> parseLists acc

        _ -> acc

parseList = \chars ->
    when List.first chars is
        Ok '[' -> List.dropFirst chars |> parseListItems []
        _ -> crash "expecting a list"

parseListItems : List U32, List Val -> { value : Val, rest : List U32 }
parseListItems = \chars, acc ->
    when List.first chars is
        Ok c if isDigit c ->
            { value, rest } = parseInteger chars 0

            parseListItems rest (List.append acc (IntVal value))

        Ok '[' ->
            { value, rest } = parseListItems (List.dropFirst chars) []

            parseListItems rest (List.append acc value)

        # lazy hack
        Ok ',' -> List.dropFirst chars |> parseListItems acc
        Ok ']' -> { value: ListVal acc, rest: List.dropFirst chars }
        _ -> crash "expecting brackets, comma, or digit"

parseInteger = \chars, acc ->
    when List.first chars is
        Ok c if isDigit c ->
            List.dropFirst chars |> parseInteger (acc * 10 + c - '0')

        _ -> { value: acc, rest: chars }

isDigit = \c ->
    c >= '0' && c <= '9'

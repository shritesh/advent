app "advent-13"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "13_example.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input = parse inputStr

        p1 = part1 input |> Num.toStr

        Stdout.write "Part 1: \(p1)"

    Task.onFail task \error ->
        when error is
            ParseError msg -> crash "Parse error: \(msg)"
            _ -> crash "Failed to read input"

part1 = \pairs ->
    List.countIf pairs isCorrectOrder

isCorrectOrder = \pair ->
    when pair is
        { left: IsInteger left, right: IsInteger right } -> left < right
        { left: IsList l, right: IsList r } ->
            if List.map2 l r (\left, right -> { left, right }) |> List.all isCorrectOrder then
                List.len l < List.len r
            else
                Bool.false

        { left: IsList _, right: IsInteger _ } -> isCorrectOrder { left: pair.left, right: IsList [pair.right] }
        { left: IsInteger _, right: IsList _ } -> isCorrectOrder { left: IsList [pair.left], right: pair.right }

parse = \inputStr ->
    Str.toScalars inputStr |> parsePairs []

parsePairs = \chars, acc ->
    { value: left, rest: restLeft } = parseList chars
    { value: right, rest: restRight } = parseNewline restLeft |> parseList

    newAcc = List.append acc { left, right }

    when restRight is
        ['\n', '\n', ..] -> List.dropFirst restRight |> List.dropFirst |> parsePairs newAcc
        [] -> newAcc
        _ -> crash "expecting two newlines"

parseNewline = \chars ->
    when List.first chars is
        Ok '\n' -> List.dropFirst chars
        _ -> crash "expecting a newline"

parseList = \chars ->
    when List.first chars is
        Ok '[' ->
            { value, rest } = List.dropFirst chars |> parseListItems []

            { value: IsList value, rest }

        _ -> crash "expecting a list"

parseListItems = \chars, acc ->
    when List.first chars is
        Ok c if isDigit c ->
            { value, rest } = parseInteger chars 0

            parseListItems rest (List.append acc (IsInteger value))

        Ok '[' ->
            { value, rest } = parseListItems (List.dropFirst chars) []

            parseListItems rest (List.append acc (IsList value))

        # lazy hack
        Ok ',' -> List.dropFirst chars |> parseListItems acc
        Ok ']' -> { value: acc, rest: List.dropFirst chars }
        _ -> crash "expecting brackets, comma, or digit"

parseInteger = \chars, acc ->
    when List.first chars is
        Ok c if isDigit c ->
            List.dropFirst chars
            |> parseInteger (acc * 10 + c - '0')

        _ -> { value: acc, rest: chars }

isDigit = \c ->
    c >= '0' && c <= '9'

app "advent-10"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "11.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \error ->
        when error is
            ParseError msg -> crash "Parse error: \(msg)"
            _ -> crash "Failed to read input"

part1 = \input ->
    run input 20 \n -> n // 3

part2 = \input ->
    product = List.map input.monkeys .test |> List.product

    run input 10000 \n -> n % product

run = \{ items, monkeys }, rounds, mapper ->
    finalState =
        roundState, _ <- List.range { start: At 0, end: Length rounds } |> List.walk { items, inspections: List.repeat 0 (List.len monkeys) }

        state, { id, monkey } <- monkeys
            |> List.mapWithIndex \m, i -> { id: i, monkey: m }
            |> List.walk roundState

        newItems =
            old <- List.get state.items id |> unwrap |> List.map
            when monkey.operation is
                OldTimesOld -> mapper (old * old)
                OldTimes n -> mapper (old * n)
                OldPlus n -> mapper (old + n)

        trueItems = List.keepIf newItems \n -> n % monkey.test == 0
        falseItems = List.dropIf newItems \n -> n % monkey.test == 0

        finalItems =
            List.mapWithIndex state.items \list, j ->
                if j == id then
                    []
                else if j == monkey.ifTrue then
                    List.join [list, trueItems]
                else if j == monkey.ifFalse then
                    List.join [list, falseItems]
                else
                    list

        inspection = List.get state.inspections id |> unwrap |> Num.add (List.len newItems)

        newInspections = List.set state.inspections id inspection

        { items: finalItems, inspections: newInspections }

    List.sortDesc finalState.inspections |> List.takeFirst 2 |> List.product

parse = \inputStr ->
    results =
        group <- Str.split inputStr "\n\n" |> List.mapTry

        when Str.split group "\n" is
            [_idLine, startingLine, operationLine, testLine, ifTrueLine, ifFalseLine] ->
                startingItems <- parseStartingLine startingLine |> Result.try
                operation <- parseOperationLine operationLine |> Result.try
                test <- parseLastNumberInLine testLine "test" |> Result.map Num.toU128 |> Result.try
                ifTrue <- parseLastNumberInLine ifTrueLine "true condition" |> Result.try
                ifFalse <- parseLastNumberInLine ifFalseLine "false condition" |> Result.map

                {
                    startingItems,
                    operation,
                    test,
                    ifTrue,
                    ifFalse,
                }

            _ -> Err (ParseError "found more than expected lines:\n\n\(group)")

    list <- Result.map results

    items = List.map list .startingItems
    monkeys = List.map list \{ operation, test, ifTrue, ifFalse } -> { operation, test, ifTrue, ifFalse }

    { items, monkeys }

parseStartingLine = \startingLine ->
    when Str.split startingLine ": " is
        [_, numbers] ->
            Str.split numbers ", "
            |> List.mapTry Str.toU128
            |> Result.mapErr \_ -> ParseError "starting items number parsing failed: \(numbers)"

        _ -> Err (ParseError "starting line parse failed")

parseOperationLine = \operationLine ->
    when Str.split operationLine " " |> List.takeLast 2 is
        ["*", "old"] -> Ok OldTimesOld
        ["+", n] -> Str.toU128 n |> Result.map OldPlus
        ["*", n] -> Str.toU128 n |> Result.map OldTimes
        _ -> Err (ParseError "invalid operation: \(operationLine)")

parseLastNumberInLine = \line, title ->
    Str.split line " "
    |> List.last
    |> Result.try Str.toNat
    |> Result.mapErr \_ -> ParseError "invalid \(title): \(line)"

unwrap = \result ->
    when result is
        Ok x -> x
        Err _ -> crash "unwrapped an error"

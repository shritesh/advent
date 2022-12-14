app "advent-12"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "12.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input = parse inputStr

        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> Stdout.line "Failed to read input"

part1 = \input ->
    (T stop _) = List.findFirst input (\T _ v -> v == 'E') |> unwrap

    list = List.map input \T k v ->
        if v == 'S' then
            T k { height: 0, hop: 0 }
        else if v == 'E' then
            T k { height: 26, hop: Num.maxU32 }
        else
            T k { height: (v - 'a'), hop: Num.maxU32 }

    toVisit = List.map list (\T k _ -> k) |> Set.fromList

    Dict.fromList list
    |> travel toVisit
    |> Dict.get stop
    |> unwrap
    |> .hop

part2 = \input ->
    list = List.map input \T k v ->
        if v == 'S' then
            T k { height: 26, hop: Num.maxU32 }
        else if v == 'E' then
            T k { height: 0, hop: 0 }
        else
            T k { height: 26 - (v - 'a'), hop: Num.maxU32 }

    toVisit = List.map list (\T k _ -> k) |> Set.fromList

    Dict.fromList list
    |> travel toVisit
    |> Dict.toList
    |> List.keepIf \T _ { height } -> height == 26
    |> List.map \T _ { hop } -> hop
    |> List.min
    |> unwrap

travel = \grid, toVisit ->
    when next grid toVisit is
        Ok { position, height, hop, toVisit: newToVisit } ->
            newGrid =
                state, { r, c } <- [{ r: -1, c: 0 }, { r: 1, c: 0 }, { r: 0, c: -1 }, { r: 0, c: 1 }] |> List.walk grid
                adjPosition = { col: position.col + c, row: position.row + r }

                when Dict.get state adjPosition is
                    Ok { height: adjHeight, hop: adjHop } if adjHeight <= height + 1 && hop < adjHop ->
                        Dict.insert state adjPosition { height: adjHeight, hop: hop + 1 }

                    _ -> state

            travel newGrid newToVisit

        Err _ -> grid

next = \grid, toVisit ->
    (T position { height, hop }) <-
        Dict.toList grid
        |> List.keepIf \T k _ -> Set.contains toVisit k
        |> List.sortWith \T _ a, T _ b -> Num.compare a.hop b.hop
        |> List.first
        |> Result.map

    { position, height, hop, toVisit: Set.remove toVisit position }

parse = \inputStr ->
    lists =
        line, row <- Str.split inputStr "\n" |> List.mapWithIndex
        s, col <- Str.toScalars line |> List.mapWithIndex

        # I32 simplifies out of range indexing
        T { row: Num.toI32 row, col: Num.toI32 col } s

    List.join lists

unwrap = \result ->
    when result is
        Ok x -> x
        _ -> crash "unwrapped an err"

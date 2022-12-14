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

    Task.onFail task \_ -> crash "Failed to read input"

part1 = \input ->
    (T start _) = List.findFirst input (\T _ v -> v == 'S') |> unwrap
    (T stop _) = List.findFirst input (\T _ v -> v == 'E') |> unwrap

    toVisit = List.map input (\T k _ -> k) |> Set.fromList
    hops = List.map input (\T k _ -> if k == start then T k 0 else T k Num.maxU32) |> Dict.fromList

    list = List.map input \T k v ->
        if v == 'S' then
            T k 0
        else if v == 'E' then
            T k 26
        else
            T k (v - 'a')

    Dict.fromList list
    |> helper toVisit hops
    |> Dict.get stop
    |> unwrap

part2 = \input ->
    (T start _) = List.findFirst input (\T _ v -> v == 'E') |> unwrap

    toVisit = List.map input (\T k _ -> k) |> Set.fromList
    hops = List.map input (\T k _ -> if k == start then T k 0 else T k Num.maxU32) |> Dict.fromList

    list = List.map input \T k v ->
        if v == 'S' then
            T k 26
        else if v == 'E' then
            T k 0
        else
            T k (26 - (v - 'a'))

    final = Dict.fromList list |> helper toVisit hops

    List.keepIf list \T _ v -> v == 26
    |> List.map \T k _ -> k
    |> List.map \position -> Dict.get final position |> unwrap
    |> List.min
    |> unwrap

helper = \grid, toVisit, hops ->
    when nextVisit toVisit hops is
        Ok { position, toVisit: newToVisit } ->
            height = Dict.get grid position |> unwrap
            hop = Dict.get hops position |> unwrap

            newHops =
                state, { r, c } <- [{ r: -1, c: 0 }, { r: 1, c: 0 }, { r: 0, c: -1 }, { r: 0, c: 1 }] |> List.walk hops
                adjPosition = { col: position.col + c, row: position.row + r }

                when Dict.get grid adjPosition is
                    Ok adjHeight if adjHeight <= height + 1 ->
                        adjHop = Dict.get state adjPosition |> unwrap

                        if hop < adjHop then
                            Dict.insert state adjPosition (hop + 1)
                        else
                            state

                    _ -> state

            helper grid newToVisit newHops

        Err _ -> hops

nextVisit = \toVisit, hops ->
    (T position _) <-
        Dict.toList hops
        |> List.keepIf \T k _ -> Set.contains toVisit k
        |> List.sortWith \T _ a, T _ b -> Num.compare a b
        |> List.first
        |> Result.map

    { position, toVisit: Set.remove toVisit position }

parse = \inputStr ->
    lists =
        line, row <- Str.split inputStr "\n" |> List.mapWithIndex
        s, col <- Str.toScalars line |> List.mapWithIndex

        # I32 makes out of bounds indexing easier later
        T { row: Num.toI32 row, col: Num.toI32 col } s

    List.join lists

unwrap = \result ->
    when result is
        Ok x -> x
        _ -> crash "unwrapped an err"

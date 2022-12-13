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

        Stdout.write "Part 1: \(p1)\n"

    Task.onFail task \_ -> crash "Failed to read input"

part1 = \grid ->
    toVisit = Set.fromList (Dict.keys grid)
    hops =
        Dict.keys grid
        |> List.map \k -> if k == { row: 20, col: 0 } then T k 0 else T k Num.maxU32
        |> Dict.fromList

    finalHops = helper grid toVisit hops

    Dict.get finalHops { row: 20, col: 52 } |> unwrap "finalHops"

helper = \grid, toVisit, hops ->
    when nextVisit toVisit hops is
        Ok { position: currentPosition, toVisit: newToVisit } ->
            currentHeight = Dict.get grid currentPosition |> unwrap "currentHeight"
            hx = Num.toStr currentPosition.row
            hy = Num.toStr currentPosition.col
            currentHop = Dict.get hops currentPosition |> unwrap "currentHop \(hx) \(hy)"

            newHops =
                state, { c, r } <- [
                        { r: -1, c: 0 }, # up
                        { r: 1, c: 0 }, # down
                        { r: 0, c: -1 }, # left
                        { r: 0, c: 1 }, # right
                    ]
                    |> List.walk hops

                candidatePosition = { col: currentPosition.col + c, row: currentPosition.row + r }

                when Dict.get grid candidatePosition is
                    Ok candidateHeight if candidateHeight == currentHeight || candidateHeight == currentHeight + 1 ->
                        candidateHop = Dict.get state candidatePosition |> unwrap "candidateHop"
                        alt = currentHop + 1

                        if alt < candidateHop then
                            Dict.insert state candidatePosition alt
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
    # TODO: Return start and end too
    list =
        line, row <- Str.split inputStr "\n" |> List.mapWithIndex
        s, col <- Str.toScalars line |> List.mapWithIndex

        c =
            if s >= 'a' && s <= 'z' then
                s - 'a'
            else if s == 'S' then
                0
            else if s == 'E' then
                26
            else
                crash "potato"

        T { row: Num.toI32 row, col: Num.toI32 col } c

    List.join list |> Dict.fromList

unwrap = \result, msg ->
    when result is
        Ok x -> x
        _ -> crash msg

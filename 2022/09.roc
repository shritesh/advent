app "advent-09"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "09.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = run input 2 |> Num.toStr
        p2 = run input 10 |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "Unable to read or parse input"

start = { x: 0i32, y: 0i32 }

run = \motions, knots ->
    result =
        motions
        |> List.walk { head: start, tails: List.repeat { location: start, visits: Set.single start } (knots - 1) } move
        |> .tails
        |> List.last
        |> Result.map .visits
        |> Result.map Set.len

    when result is
        Ok x -> x
        Err _ -> crash "need more knots"

move = \state, { direction, count } ->
    if count == 0 then
        state
    else
        head = when direction is
            Up -> { x: state.head.x, y: state.head.y + 1 }
            Down -> { x: state.head.x, y: state.head.y - 1 }
            Left -> { x: state.head.x - 1, y: state.head.y }
            Right -> { x: state.head.x + 1, y: state.head.y }

        tails =
            prev, tail <- scanWith state.tails head .location
            distx = prev.x - tail.location.x
            disty = prev.y - tail.location.y

            location =
                # touches
                if distx >= -1 && distx <= 1 && disty >= -1 && disty <= 1 then
                    tail.location
                else
                    { x: tail.location.x + norm distx, y: tail.location.y + norm disty }

            visits = Set.insert tail.visits location

            { location, visits }

        move { head, tails } { direction, count: count - 1 }

# convert to -1, 0 or 1
norm = \n ->
    when n is
        _ if n < 0 -> -1
        _ if n > 0 -> 1
        _ -> 0

scanWith = \list, init, accessor, fn ->
    List.walk list { state: init, acc: [] } \{ state, acc }, elem ->
        res = fn state elem

        { state: accessor res, acc: List.append acc res }
    |> .acc

parse = \inputStr ->
    line <- Str.split inputStr "\n" |> List.mapTry

    when Str.split line " " is
        ["R", steps] -> Str.toNat steps |> Result.map \count -> { direction: Right, count }
        ["U", steps] -> Str.toNat steps |> Result.map \count -> { direction: Up, count }
        ["L", steps] -> Str.toNat steps |> Result.map \count -> { direction: Left, count }
        ["D", steps] -> Str.toNat steps |> Result.map \count -> { direction: Down, count }
        _ -> Err InvalidInput

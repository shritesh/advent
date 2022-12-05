app "advent-05"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "05.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = run CrateMover9000 input
        p2 = run CrateMover9001 input

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "failed to read and parse file: \(filename)"

run = \machine, { crates, moves } ->
    final =
        state, { count, from, to } <- List.walk moves crates
        { crates: newCrates, removed } = pop state from count

        moved = when machine is
            CrateMover9000 -> List.reverse removed
            CrateMover9001 -> removed

        List.walk moved newCrates \c, n -> push c to n

    final
    |> List.joinMap \l -> List.takeLast l 1
    |> Str.joinWith ""

# I should really learn how to use `Parser`
parse = \inputStr ->
    { before, after } <- Str.splitFirst inputStr "\n\n" |> Result.try

    crates =
        state, line <- before
            |> Str.split "\n"
            |> List.dropLast # the last line is the footer
            |> List.reverse # bottom crates should go first in stack
            |> List.walk (List.repeat [] 9) # max 9 stacks
        acc, char, idx <- Str.graphemes line |> walkWithIndex state

        # chars 1, 5, 9,... are either ' ' or a crate character
        if char != " " && idx % 4 == 1 then
            push acc ((idx - 1) // 4) char
        else
            acc

    moves =
        line <- Str.split after "\n" |> List.mapTry
        words = Str.split line " "

        # "words" at these indices are the numbers we want
        nums <- [1, 3, 5]
            |> List.mapTry \i -> List.get words i
            |> Result.try \nums -> List.mapTry nums Str.toNat
            |> Result.map

        when nums is
            [count, from, to] -> { count, from: from - 1, to: to - 1 } # 0 indexing
            _ -> crash "unreachable"

    Result.map moves \m -> { crates, moves: m }

push = \crates, num, char ->
    when List.get crates num is
        Ok list -> List.set crates num (List.append list char)
        Err _ -> crash "out of bounds"

pop = \crates, num, count ->
    when List.get crates num is
        Ok list ->
            remaining = List.takeFirst list (List.len list - count)
            removed = List.takeLast list count

            { crates: List.set crates num remaining, removed }

        Err _ -> crash "out of bounds"

walkWithIndex = \list, initial, fn ->
    acc = List.walk list { count: 0, state: initial } \{ count, state }, elem -> { count: count + 1, state: fn state elem count }

    acc.state

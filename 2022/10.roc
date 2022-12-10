app "advent-10"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "10.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = part1 input |> Num.toStr
        p2 = part2 input

        Stdout.write "Part 1: \(p1)\nPart 2:\n\(p2)\n"

    Task.onFail task \_ -> crash "Unable to read or parse input"

cycles = \instructions ->
    final =
        state, instruction <- List.walk instructions { acc: 1, cycles: [] }
        when instruction is
            NoOp -> { state & cycles: List.join [state.cycles, [state.acc]] }
            Addx n ->
                { acc: state.acc + n, cycles: List.join [state.cycles, [state.acc, state.acc]] }

    final.cycles

part1 = \instructions ->
    strengths =
        n, idx <- cycles instructions |> List.mapWithIndex
        cycle = Num.toI32 idx + 1

        if (cycle + 20) % 40 == 0 then
            cycle * n
        else
            0

    List.sum strengths

part2 = \instructions ->
    pixels =
        n, idx <- cycles instructions |> List.mapWithIndex
        position = Num.toI32 idx % 40

        pixel =
            if position >= n - 1 && position <= n + 1 then
                "█"
            else
                " "

        if position == 39 then
            "\(pixel)\n"
        else
            pixel

    Str.joinWith pixels ""

parse = \inputStr ->
    line <- Str.split inputStr "\n" |> List.mapTry

    when Str.split line " " is
        ["noop"] -> Ok NoOp
        ["addx", n] -> Str.toI32 n |> Result.map Addx
        _ -> Err InvalidInput

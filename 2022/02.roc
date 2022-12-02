app "advent-02"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "02.txt"

main =
    task =
        input <- Path.fromStr filename |> File.readUtf8 |> Task.await
        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "failed to read file: \(filename)"

part1 = \input ->
    scores =
        line <- Str.split input "\n" |> List.map
        when Str.split line " " is
            # rock
            ["A", "X"] -> 3 + 1
            ["B", "X"] -> 0 + 1
            ["C", "X"] -> 6 + 1
            # paper
            ["A", "Y"] -> 6 + 2
            ["B", "Y"] -> 3 + 2
            ["C", "Y"] -> 0 + 2
            # scissors
            ["A", "Z"] -> 0 + 3
            ["B", "Z"] -> 6 + 3
            ["C", "Z"] -> 3 + 3
            _ -> crash "invalid input: \(line)"

    List.sum scores

part2 = \input ->
    scores =
        line <- Str.split input "\n" |> List.map
        when Str.split line " " is
            # lose
            ["A", "X"] -> 0 + 3
            ["B", "X"] -> 0 + 1
            ["C", "X"] -> 0 + 2
            # draw
            ["A", "Y"] -> 3 + 1
            ["B", "Y"] -> 3 + 2
            ["C", "Y"] -> 3 + 3
            # win
            ["A", "Z"] -> 6 + 2
            ["B", "Z"] -> 6 + 3
            ["C", "Z"] -> 6 + 1
            _ -> crash "invalid input: \(line)"

    List.sum scores

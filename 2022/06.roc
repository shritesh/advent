app "advent-06"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "06.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await

        p1 <- run inputStr 4 |> Result.map Num.toStr |> Task.fromResult |> Task.await
        p2 <- run inputStr 14 |> Result.map Num.toStr |> Task.fromResult |> Task.await

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "Unable to read input or find results"

run = \input, count ->
    input
    |> Str.graphemes
    |> windows count
    |> List.map Set.fromList
    |> List.findFirstIndex \set -> Set.len set == count
    |> Result.map \n -> n + count

windows = \list, count ->
    n <- List.range 0 (List.len list - count + 1) |> List.map
    List.sublist list { start: n, len: count }

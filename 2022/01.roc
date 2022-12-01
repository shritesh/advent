app "advent-01"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

inputFile = Path.fromStr "01.txt"

main =
    task =
        inputStr <- inputFile |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part1: \(p1)\nPart2: \(p2)\n"

    Task.onFail task \_ -> crash "Parse error"

parse = \inputStr ->
    group <- Str.split inputStr "\n\n" |> List.mapTry
    line <- Str.split group "\n" |> List.mapTry
    Str.toU32 line

part1 = \calories ->
    when List.map calories List.sum |> List.sortDesc is
        [first, ..] -> first
        _ -> crash "Empty list"

part2 = \calories ->
    when List.map calories List.sum |> List.sortDesc is
        [first, second, third, ..] -> first + second + third
        _ -> crash "Empty list"

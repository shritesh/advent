app "advent-04"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "04.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input <- parse inputStr |> Task.fromResult |> Task.await

        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "failed to read and parse file: \(filename)"

part1 = \pairs ->
    { first, second } <- List.countIf pairs
    (Set.difference first second |> Set.len) == 0 || (Set.difference second first |> Set.len) == 0

part2 = \pairs ->
    { first, second } <- List.countIf pairs
    (Set.intersection first second |> Set.len) != 0

parse = \inputStr ->
    replaced <- Str.replaceEach inputStr "," "-" |> Result.try
    line <- Str.split replaced "\n" |> List.mapTry
    nums <- Str.split line "-" |> List.mapTry Str.toU32 |> Result.try

    when nums is
        [a, b, c, d] ->
            Ok {
                first: range a b |> Set.fromList,
                second: range c d |> Set.fromList,
            }

        _ -> Err InvalidInput

# range is still broken in roc: https://github.com/roc-lang/roc/issues/4196
# List.range 1 1 == List.range 1 2
range = \a, b ->
    if a == b then
        List.range a b
    else if a < b then
        List.range a (b + 1)
    else
        # order matters
        List.range b (a + 1) |> List.reverse

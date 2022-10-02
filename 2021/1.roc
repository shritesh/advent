app "advent-1"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [
        pf.File,
        pf.Path,
        pf.Program,
        pf.Task,
        pf.Stderr,
        pf.Stdout,
    ]
    provides [main] to pf

main = Program.quick task

task =
    input <-
        Path.fromStr "1.txt"
        |> File.readUtf8
        |> Task.await

    when parse input is
        Ok nums ->
            p1 = part1 nums |> Num.toStr
            p2 = part2 nums |> Num.toStr

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    input
    |> Str.trim
    |> Str.split "\n"
    |> List.mapTry Str.toU16

part1 = \numbers ->
    List.walk numbers { count: 0, prev: None } \{ count, prev }, n ->
        when prev is
            Some p if n > p -> { count: count + 1, prev: Some n }
            _ -> { count, prev: Some n }
    |> .count

part2 = \numbers ->
    numbers2 = List.dropFirst numbers
    numbers3 = List.dropFirst numbers2

    sums = List.map3 numbers numbers2 numbers3 \a, b, c -> a + b + c

    part1 sums

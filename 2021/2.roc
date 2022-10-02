app "advent-2"
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
        Path.fromStr "2.txt"
        |> File.readUtf8
        |> Task.await

    when parse input is
        Ok commands ->
            p1 = part1 commands |> Num.toStr
            p2 = part2 commands |> Num.toStr

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    input
    |> Str.trim
    |> Str.split "\n"
    |> List.mapTry parseLine

parseLine = \line ->
    when Str.splitFirst line " " is
        Ok { before: "forward", after } -> Str.toI32 after |> Result.map Forward
        Ok { before: "down", after } -> Str.toI32 after |> Result.map Down
        Ok { before: "up", after } -> Str.toI32 after |> Result.map Up
        _ -> Err InvalidInput

part1 = \commands ->
    submarine = List.walk commands { position: 0, depth: 0 } \{ position, depth }, command ->
        when command is
            Forward n -> { position: position + n, depth }
            Down n -> { position, depth: depth + n }
            Up n -> { position, depth: depth - n }

    submarine.position * submarine.depth

part2 = \commands ->
    submarine = List.walk commands { position: 0, depth: 0, aim: 0 } \{ position, depth, aim }, command ->
        when command is
            Forward n -> { position: position + n, depth: depth + aim * n, aim }
            Down n -> { position, depth, aim: aim + n }
            Up n -> { position, depth, aim: aim - n }

    submarine.position * submarine.depth

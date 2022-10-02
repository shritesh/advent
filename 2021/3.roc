app "advent-3"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    # imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <-
        Path.fromStr "3_example.txt"
        |> File.readUtf8
        |> Task.await

    parse input
    |> part1
    |> Num.toStr
    |> Stdout.line

parse = \input ->
    input
    |> Str.trim
    |> Str.split "\n"
    |> List.map parseNum

parseNum = \line ->
    Str.walkScalars line 0u32 \n, s ->
        when s is
            '1' -> Num.shiftLeftBy n 1 + 1
            _ -> Num.shiftLeftBy n 1

# WIP To appease the compiler, no luck
part1 = \numbers ->
    List.len numbers

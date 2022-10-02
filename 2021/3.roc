app "advent-3"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
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
    Str.walkScalars line 0u16 \n, s ->
        if s == '1' then
            Num.shiftLeftBy n 1 + 1
        else
            # Should error on invalid chars but walkTry is not exposed to userspace
            Num.shiftLeftBy n 1

bitCount = \numbers, index ->
    mask = Num.shiftLeftBy 1 index

    List.walk numbers { zeroes: 0, ones: 0 } \{ zeroes, ones }, num ->
        if Num.bitwiseAnd num mask == 0 then
            { zeroes: zeroes + 1, ones }
        else
            { zeroes, ones: ones + 1 }

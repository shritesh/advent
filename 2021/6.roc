app "advent-6"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "6.txt" |> File.readUtf8 |> Task.await

    when parse input is
        Ok fishes ->
            p1 = simulate fishes 80 |> Num.toStr
            p2 = simulate fishes 256 |> Num.toStr

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

        Err _ -> Stderr.line "Invalid input"

parse = \input -> input |> Str.trim |> Str.split "," |> List.mapTry Str.toNat

simulate = \fishes, days ->
    initBirths = List.walk fishes (List.repeat 0 9) \births, fish -> incrementListIdx births fish 1

    final = List.walk (List.range 0 days) initBirths \births, _day ->
        first = getWithDefault births 0

        # rotate and increment
        births
        |> List.dropFirst
        |> List.append first
        |> incrementListIdx 6 first

    List.sum final

getWithDefault = \list, index -> List.get list index |> Result.withDefault 0

incrementListIdx = \list, index, value ->
    List.set list index (value + getWithDefault list index)

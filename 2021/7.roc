app "advent-7"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "7.txt" |> File.readUtf8 |> Task.await

    when parse input is
        Ok positions ->
            p1 = part1 positions |> Num.toStr
            p2 = part2 positions |> Num.toStr

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

        Err _ -> Stderr.line "Invalid input"

parse = \input -> input |> Str.trim |> Str.split "," |> List.mapTry Str.toU32

part1 = \positions -> solve positions \x -> x

part2 = \positions -> solve positions \x -> x * (x + 1) // 2

solve = \positions, rate ->
    min = List.min positions |> Result.withDefault Num.maxU32
    max = List.max positions |> Result.withDefault 0

    List.range min max
    |> List.map (\target -> fuelCost positions target rate)
    |> List.min
    |> Result.withDefault Num.maxU32

fuelCost = \positions, target, rate ->
    positions
    |> List.map (\pos -> if target > pos then target - pos else pos - target)
    |> List.map rate
    |> List.sum

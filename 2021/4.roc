app "advent-4"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <-
        Path.fromStr "4_example.txt"
        |> File.readUtf8
        |> Task.await

    when parse input is
        Ok { numbers, boards } ->
            n = Num.toStr (List.len numbers)
            b = Num.toStr (List.len boards)

            Stdout.line "\(n) \(b)"

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    contents = input |> Str.trim |> Str.split "\n\n"

    numbers <- contents |> List.first |> Result.try parseNumbers |> Result.try
    boards <- contents |> List.dropFirst |> parseBoards |> Result.map

    { numbers, boards }

parseNumbers = \str ->
    str |> Str.split "," |> List.mapTry Str.toU8

parseBoards = \list ->
    board <- List.mapTry list
    line <- board |> Str.split "\n" |> List.mapTry

    line
    |> Str.split " "
    |> List.dropIf Str.isEmpty
    |> List.mapTry Str.toU8

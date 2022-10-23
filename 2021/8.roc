app "advent-8"
    packages { pf: "../../roc/examples/cli/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "8.txt" |> File.readUtf8 |> Task.await

    when parse input is
        Ok entries ->
            p1 = part1 entries |> Num.toStr

            Stdout.line "Part 1: \(p1)"

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    lines <- Str.split input "\n" |> List.mapTry
    
    { before, after } <- Str.splitFirst lines " | " |> Result.map
    
    {segments: parseDigits before, numbers: parseDigits after}


parseDigits = \str -> 
    digitChars <- str |> Str.split " " |> List.map 
    set, c <- digitChars |> Str.walkScalars Set.empty

    when c is 
        'a' -> Set.insert set A
        'b' -> Set.insert set B
        'c' -> Set.insert set C
        'd' -> Set.insert set D
        'e' -> Set.insert set E
        'f' -> Set.insert set F
        'g' -> Set.insert set G
        _ -> set


part1 = \entries ->
    counts  = List.map entries \{numbers} ->
        numbers
        |> List.map Set.len
        |> List.keepIf (\c -> c == 2 || c == 3 || c == 4 || c == 7)
        |> List.len
    
    List.sum counts

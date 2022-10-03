app "advent-4"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "4.txt" |> File.readUtf8 |> Task.await

    when parse input |> Result.try part1 is
        Ok score ->
            score |> Num.toStr |> Stdout.line

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    contents = input |> Str.trim |> Str.split "\n\n"

    numbers <- contents |> List.first |> Result.try parseNumbers |> Result.try
    boards <- contents |> List.dropFirst |> parseBoards |> Result.map

    { numbers, boards }

parseNumbers = \str -> str |> Str.split "," |> List.mapTry Str.toU32

parseBoards = \list ->
    board <- List.mapTry list

    # use a 25 element list instead of 5x5 nested list to make my life easier
    str <- board |> Str.replaceEach "\n" " " |> Result.try

    str
    |> Str.split " "
    |> List.dropIf Str.isEmpty # remove repeated spaces
    |> List.mapTry Str.toU32

part1 = \{ numbers, boards } ->
    initialGames = List.map boards \board -> { board, played: Set.empty }

    { status: finalStatus } = List.walkUntil numbers { games: initialGames, status: Err NoGameWon } \{ games, status }, number ->
        # play the games first
        newGames = List.map games \{ board, played } -> { board, played: play board played number }

        # check if any board has won
        when List.findFirst newGames hasWon is
            Ok { board, played } -> Break { games: newGames, status: Ok (number * boardScore board played) }
            Err _ -> Continue { games: newGames, status }

    finalStatus

hasWon = \{ played } ->
    # Indices position
    #  0  1  2  3  4
    #  5  6  7  8  9
    # 10 11 12 13 14
    # 15 16 17 18 19
    # 20 21 22 23 24
    horizontals = List.map (List.range 0 5) \row -> # [0, 1, 2, 3, 4], [5, 6, 7, 8, 9]...
        [5 * row + 0, 5 * row + 1, 5 * row + 2, 5 * row + 3, 5 * row + 4]

    verticals = List.map (List.range 0 5) \col -> # [0, 5, 10, 15, 20], [1, 6, 11, 16, 21]...
        [0 + col, 5 + col, 10 + col, 15 + col, 20 + col]

    indices <- List.join [horizontals, verticals] |> List.any

    List.all indices \index -> Set.contains played index

boardScore = \board, played ->
    # skip indices that have been played
    scores = List.mapWithIndex board \n, idx -> if Set.contains played idx then 0 else n

    List.sum scores

# return new indices with the number played in the board
play = \board, played, number ->
    when List.findFirstIndex board \n -> n == number is
        Ok idx -> Set.insert played idx
        Err _ -> played # shouldn't really happen

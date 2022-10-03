app "advent-4"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "4.txt" |> File.readUtf8 |> Task.await

    when parse input is
        Ok parsed ->
            p1 = part1 parsed |> Result.map Num.toStr |> Result.withDefault "No games won"
            p2 = part2 parsed |> Result.map Num.toStr |> Result.withDefault "Last board doesn't ever win"

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

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
    initialGames = List.map boards \board -> { board, marked: Set.empty }

    endState = List.walkUntil numbers { games: initialGames, score: Err NoGameWon } \{ games, score }, number ->
        # play the games first
        newGames = List.map games \{ board, marked } -> { board, marked: play board marked number }

        # check if any board has won
        when List.findFirst newGames \{ marked } -> hasWon marked is
            Ok { board, marked } -> Break { games: newGames, score: Ok (boardScore board marked number) }
            Err _ -> Continue { games: newGames, score }

    endState.score

part2 = \{ numbers, boards } ->
    # the winning number of moves and score for each board
    outcomes = List.map boards \board ->
        List.walkUntil numbers { moves: 0, score: Err HasntWon, marked: Set.empty } \{ moves, marked, score }, number ->
            newMarked = play board marked number

            if hasWon newMarked then
                Break { moves: moves + 1, score: Ok (boardScore board newMarked number), marked: newMarked }
            else
                Continue { moves: moves + 1, score, marked: newMarked }

    last = List.walk outcomes { moves: 0, score: Err HasntWon } \lastWinner, current ->
        if current.moves > lastWinner.moves then { moves: current.moves, score: current.score } else lastWinner

    last.score

hasWon = \marked ->
    # Indices position
    #  0  1  2  3  4
    #  5  6  7  8  9
    # 10 11 12 13 14
    # 15 16 17 18 19
    # 20 21 22 23 24
    horizontals = List.map (List.range 0 5) \row ->
        # [0, 1, 2, 3, 4], [5, 6, 7, 8, 9]...
        [5 * row + 0, 5 * row + 1, 5 * row + 2, 5 * row + 3, 5 * row + 4]

    verticals = List.map (List.range 0 5) \col ->
        # [0, 5, 10, 15, 20], [1, 6, 11, 16, 21]...
        [0 + col, 5 + col, 10 + col, 15 + col, 20 + col]

    indices <- List.join [horizontals, verticals] |> List.any

    List.all indices \index -> Set.contains marked index

boardScore = \board, marked, number ->
    # set marked numbers to 0
    unmarkedScores = List.mapWithIndex board \n, idx -> if Set.contains marked idx then 0 else n

    number * List.sum unmarkedScores

# return new indices with the number marked in the board
play = \board, marked, number ->
    when List.findFirstIndex board \n -> n == number is
        Ok idx -> Set.insert marked idx
        Err _ -> marked # shouldn't really happen

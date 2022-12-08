app "advent-08"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "08.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        grid <- parse inputStr |> Task.fromResult |> Task.await

        p1 = part1 grid |> Num.toStr
        p2 = part2 grid |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "Unable to read input"

part1 = \grid ->
    { x, y } <- allTrees grid |> List.countIf

    direction <- List.any [Top, Left, Right, Bottom]
    { col, row } <- neighbors grid x y direction |> List.all
    get grid col row < get grid x y

part2 = \grid ->
    scores =
        { x, y } <- allTrees grid |> List.map

        [Top, Left, Right, Bottom]
        |> List.map \direction -> neighbors grid x y direction |> countWhileInclusive \{ col, row } -> get grid col row < get grid x y
        |> List.product

    when List.max scores is
        Ok x -> x
        Err _ -> crash "unreachable"

parse = \inputStr ->
    trees <-
        Str.split inputStr "\n"
        |> List.mapTry \line -> Str.graphemes line |> List.mapTry Str.toNat
        |> Result.map

    height = List.len trees
    width = List.first trees |> Result.withDefault [] |> List.len

    { width, height, trees }

# neighbors going outwards order from `direction`
neighbors = \grid, x, y, direction ->
    when direction is
        Top -> range 0 y |> List.reverse |> List.map \row -> { col: x, row }
        Left -> range 0 x |> List.reverse |> List.map \col -> { col, row: y }
        Right -> range (x + 1) (grid.width) |> List.map \col -> { col, row: y }
        Bottom -> range (y + 1) (grid.height) |> List.map \row -> { col: x, row }

allTrees = \grid ->
    List.joinMap (range 0 grid.width) \x -> List.range 0 grid.height |> List.map \y -> { x, y }

get = \grid, x, y ->
    grid.trees
    |> List.get y
    |> Result.try \row -> List.get row x
    |> Result.withDefault 0

# counts the "stopping" value too
countWhileInclusive = \list, fn ->
    count, elem <- List.walkUntil list 0
    if fn elem then
        Continue (count + 1)
    else
        Break (count + 1)

# List.range is fixed in main, not in nightly yet
# https://github.com/roc-lang/roc/issues/4196
range = \a, b ->
    if a == b then
        []
    else
        List.range a b

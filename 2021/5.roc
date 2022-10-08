app "advent-5"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stderr, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <- Path.fromStr "5.txt" |> File.readUtf8 |> Task.await

    when parse input is
        Ok lines ->
            p1 = part1 lines |> Num.toStr
            p2 = part2 lines |> Num.toStr

            Stdout.line "Part 1: \(p1)\nPart 2: \(p2)"

        Err _ -> Stderr.line "Invalid input"

parse = \input ->
    line <- input |> Str.trim |> Str.split "\n" |> List.mapTry

    when parseLine line is
        Fourth { first, second, third, fourth } -> Ok { from: { x: first, y: second }, to: { x: third, y: fourth } }
        _ -> Err ParseError

parseLine = \input ->
    state, c <- Str.walkScalars input WantFirst

    # if char is a digit
    if c >= '0' && c <= '9' then
        digit = Num.toNat (c - '0') # typechecker loves Nats

        when state is
            # Move to the state wanted
            WantFirst -> First { first: digit }
            WantSecond { first } -> Second { first, second: digit }
            WantThird { first, second } -> Third { first, second, third: digit }
            WantFourth { first, second, third } -> Fourth { first, second, third, fourth: digit }
            # Add the digit to the end of the current number
            First { first } -> First { first: first * 10 + digit }
            Second { first, second } -> Second { first, second: second * 10 + digit }
            Third { first, second, third } -> Third { first, second, third: third * 10 + digit }
            Fourth { first, second, third, fourth } -> Fourth { first, second, third, fourth: fourth * 10 + digit }
    else
        # not a digit, want the next number now
        when state is
            First numbers -> WantSecond numbers
            Second numbers -> WantThird numbers
            Third numbers -> WantFourth numbers
            _ -> state

part1 = \lines ->
    coveredGrid = List.walk lines (makeGrid lines) \grid, { from, to } ->
        if from.x == to.x then
            List.walk (inclusiveRange from.y to.y) grid \innerGrid, y -> cover innerGrid from.x y
        else if from.y == to.y then
            List.walk (inclusiveRange from.x to.x) grid \innerGrid, x -> cover innerGrid x from.y
        else
            # skip diagonals
            grid

    countTwoOrMore coveredGrid

part2 = \lines ->
    coveredGrid = List.walk lines (makeGrid lines) \grid, { from, to } ->
        if from.x == to.x then
            List.walk (inclusiveRange from.y to.y) grid \innerGrid, y -> cover innerGrid from.x y
        else if from.y == to.y then
            List.walk (inclusiveRange from.x to.x) grid \innerGrid, x -> cover innerGrid x from.y
        else
            points = List.map2 (inclusiveRange from.x to.x) (inclusiveRange from.y to.y) \x, y -> { x, y }

            List.walk points grid \innerGrid, { x, y } -> cover innerGrid x y

    countTwoOrMore coveredGrid

makeGrid = \lines ->
    width = lines |> List.joinMap (\{ from, to } -> [from.x, to.x]) |> List.max |> Result.withDefault 0
    height = lines |> List.joinMap (\{ from, to } -> [from.y, to.y]) |> List.max |> Result.withDefault 0

    { width, data: List.repeat None (width * height) }

# range is just broken in roc:
# List.range 1 1 == List.range 1 2
inclusiveRange = \a, b ->
    if a == b then
        List.range a b
    else if a < b then
        List.range a (b + 1)
    else
        # order matters
        List.range b (a + 1) |> List.reverse

cover = \{ width, data }, x, y ->
    index = width * x + y

    # branch prediction (lol)
    when List.replace data index One is
        # If it was previously None, we guessed right
        { value: None, list } -> { width, data: list }
        # If it was One or TwoOrMore, set it to TwoOrMore
        { value: _, list } -> { width, data: List.set list index TwoOrMore }

countTwoOrMore = \grid ->
    grid.data
    |> List.keepIf (\overlap -> overlap == TwoOrMore)
    |> List.len

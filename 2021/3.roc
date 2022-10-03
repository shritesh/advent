app "advent-3"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stdout]
    provides [main] to pf

main = Program.quick task

task =
    input <-
        Path.fromStr "3.txt"
        |> File.readUtf8
        |> Task.await

    parsed = parse input

    p1 = part1 parsed |> Num.toStr
    p2 = part2 parsed |> Num.toStr

    Stdout.line "Part1: \(p1)\nPart2: \(p2)"

parse = \input ->
    strs =
        input
        |> Str.trim
        |> Str.split "\n"

    # poor man's clz-ish
    len =
        List.takeFirst strs 1
        |> List.map Str.countGraphemes
        |> List.sum

    numbers = List.map strs parseNum

    { numbers, len }

parseNum = \line ->
    Str.walkScalars line 0 \n, s ->
        if s == '1' then
            Num.shiftLeftBy n 1 + 1
        else
            # Should error on invalid chars but walkTry is not exposed to userspace
            Num.shiftLeftBy n 1

bitCount = \numbers, index ->
    List.walk numbers { zeroes: 0, ones: 0 } \{ zeroes, ones }, num ->
        if Num.bitwiseAnd num (mask index) == 0 then
            { zeroes: zeroes + 1, ones }
        else
            { zeroes, ones: ones + 1 }

mask = \index -> Num.shiftLeftBy 1 index

setBit = \num, index ->
    Num.bitwiseOr num (mask index)

part1 = \{ numbers, len } ->
    rates = List.walk (List.range 0 len) { gamma: 0, epsilon: 0 } \{ gamma, epsilon }, index ->
        { zeroes, ones } = bitCount numbers index

        if ones > zeroes then
            # isGammaOne
            { gamma: setBit gamma index, epsilon }
        else if zeroes > ones then
            # isEpsilonOne
            { gamma, epsilon: setBit epsilon index }
        else
            { gamma, epsilon }

    rates.gamma * rates.epsilon

filter = \numbers, index, keep ->
    zeroAtIndex = \num -> Num.bitwiseAnd num (mask index) == 0

    if keep == 0 then
        List.keepIf numbers zeroAtIndex
    else
        List.dropIf numbers zeroAtIndex

criteria = \numbers, len, which, tieBreaker ->
    List.walkUntil (List.range 0 len) numbers \nums, index ->
        if List.len nums == 1 then
            Break nums
        else
            actualIndex = len - index - 1
            { zeroes, ones } = bitCount nums actualIndex

            keep = 
                when which is
                    Most -> if zeroes > ones then 0 else if ones > zeroes then 1 else tieBreaker
                    Least -> if zeroes < ones then 0 else if ones < zeroes then 1 else tieBreaker

            Continue (filter nums actualIndex keep)

part2 = \{ numbers, len } ->
    oxygen = criteria numbers len Most 1
    co2 = criteria numbers len Least 0

    List.join [oxygen, co2]
    |> List.product

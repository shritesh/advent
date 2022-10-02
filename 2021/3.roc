app "advent-3"
    packages { pf: "../../roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.File, pf.Path, pf.Program, pf.Task, pf.Stdout]
    provides [main] to pf

expect bitCount [1, 2, 3] 0 != { zeroes: 0, ones: 0 }

main = Program.quick task

# make sure the same type is used everywhere
zero = 0u16

task =
    input <-
        Path.fromStr "3_example.txt"
        |> File.readUtf8
        |> Task.await

    parse input
    |> part1 # |> Num.toStr
    |> Stdout.line

parse = \input ->
    input
    |> Str.trim
    |> Str.split "\n"
    |> List.map parseNum

parseNum = \line ->
    Str.walkScalars line zero \n, s ->
        if s == '1' then
            Num.shiftLeftBy n 1 + 1
        else
            # Should error on invalid chars but walkTry is not exposed to userspace
            Num.shiftLeftBy n 1

bitCount = \numbers, index ->
    mask = Num.shiftLeftBy 1 index

    List.walk numbers { zeroes: 0, ones: 0, max: 0 } \{ zeroes, ones }, num ->
        if Num.bitwiseAnd num mask == 0 then
            { zeroes: zeroes + 1, ones }
        else
            { zeroes, ones: ones + 1 }

setBit = \num, index ->
    mask = Num.shiftLeftBy 1 index

    Num.bitwiseOr num mask

part1 = \numbers ->
    len = List.map numbers

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

    gr = Num.toStr rates.gamma
    er = Num.toStr rates.epsilon

    "\(gr) \(er)"

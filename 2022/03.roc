app "advent-03"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "03.txt"

main =
    task =
        input <- Path.fromStr filename |> File.readUtf8 |> Task.await
        p1 = part1 input |> Num.toStr
        p2 = part2 input |> Num.toStr

        Stdout.write "Part 1: \(p1)\nPart 2: \(p2)\n"

    Task.onFail task \_ -> crash "failed to read file: \(filename)"

part1 = \input ->
    priorities =
        line <- Str.split input "\n" |> List.map Str.toScalars |> List.map
        { before, others } = List.split line (List.len line // 2)
        first = Set.fromList before
        second = Set.fromList others

        Set.intersection first second
        |> Set.toList
        |> List.map scalarToPriority
        |> List.sum

    List.sum priorities

part2 = \input ->
    priorities =
        lines = Str.split input "\n" |> List.map Str.toScalars |> List.map Set.fromList

        # poor man's chunk
        group <-
            List.range 0 (List.len lines // 3)
            |> List.map \n -> List.sublist lines { start: n * 3, len: 3 }
            |> List.map

        when group is
            # can't walk (reduce) with an initial Set.empty for intersection
            [first, second, third] ->
                first
                |> Set.intersection second
                |> Set.intersection third
                |> Set.toList
                |> List.map scalarToPriority
                |> List.sum

            _ -> crash "groups must be of len 3"

    List.sum priorities

scalarToPriority = \scalar ->
    when scalar is
        lowercase if (lowercase >= 'a' && lowercase <= 'z') -> lowercase - 'a' + 1 # 1 - 26
        uppercase if (uppercase >= 'A' && uppercase <= 'Z') -> uppercase - 'A' + 27 # 27 - 52
        _ -> crash "priority out of range"

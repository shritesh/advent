app "advent-07"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

filename = "07.txt"

main =
    task =
        inputStr <- Path.fromStr filename |> File.readUtf8 |> Task.await
        input = parse inputStr

        p1 = part1 input |> Num.toStr

        p2 <- part2 input |> Result.map Num.toStr |> Task.fromResult |> Task.await

        Stdout.write "Part 1: \(p1)\n Part 2: \(p2)\n"

    Task.onFail task \_ -> crash "Unable to read input or find results"

part1 = \fs ->
    Dict.keys fs
    |> List.map \dir -> dirSize fs dir
    |> List.keepIf \size -> size <= 100000
    |> List.sum

part2 = \fs ->
    unused = 70000000 - dirSize fs ["/"]
    required = 30000000 - unused

    Dict.keys fs
    |> List.map \dir -> dirSize fs dir
    |> List.keepIf \n -> n >= required
    |> List.min

dirSize = \fs, dir ->
    when Dict.get fs dir is
        Ok list ->
            sizes =
                entry <- List.map list
                when entry is
                    File _name size -> size
                    Dir subdir -> dirSize fs subdir

            List.sum sizes

        Err _ -> crash "Dir not found"

parse = \inputStr ->
    acc =
        state, cmd <- Str.split inputStr "$ "
            |> List.dropFirst # There is nothing before the first "$ "
            |> List.walk { cwd: [], fs: Dict.empty }

        { before: command, others: listing } =
            cmd
            |> Str.split "\n"
            |> List.map \line -> Str.split line " "
            |> List.split 1

        when command is
            [["cd", "/"]] -> { state & cwd: ["/"] }
            [["cd", ".."]] ->
                parentDir =
                    when state.cwd is
                        ["/"] -> crash "Already at the root"
                        _ -> List.dropLast state.cwd

                { state & cwd: parentDir }

            [["cd", dir]] -> { state & cwd: List.append state.cwd dir }
            [["ls"]] ->
                entries =
                    line <- List.joinMap listing
                    when line is
                        [""] -> []
                        ["dir", d] -> [List.append state.cwd d |> Dir]
                        [size, name] ->
                            when Str.toNat size is
                                Ok s -> [File name s]
                                Err _ -> crash "invalid size '\(size)' for '\(name)'"

                        _ -> crash "invalid listing"

                { state & fs: Dict.insert state.fs state.cwd entries }

            _ -> crash "invalid command"

    acc.fs

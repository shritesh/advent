defmodule Advent.Day3 do
  defmodule TobogganMap do
    defstruct [:rows, :columns, :map]

    def new(input) do
      lines = String.split(input, "\n", trim: true)

      map =
        for {line, row} <- Enum.with_index(lines),
            {char, col} <- Enum.with_index(String.codepoints(line)),
            into: %{},
            do: {{row, col}, char}

      %__MODULE__{
        rows: Enum.count(lines),
        columns: hd(lines) |> String.length(),
        map: map
      }
    end

    def at(%__MODULE__{rows: rows, columns: columns, map: map}, {row, col})
        when row in 0..(rows - 1) and col in 0..(columns - 1) do
      Map.get(map, {row, col})
    end

    def at(%__MODULE__{rows: rows, columns: columns} = tm, {row, col}) do
      at(tm, {rem(row, rows), rem(col, columns)})
    end

    def count_trees_of_slope(%__MODULE__{} = tm, {right, down}) do
      rows = :lists.seq(0, tm.rows - 1, down)
      cols = Stream.iterate(0, &(&1 + right))

      Enum.zip(rows, cols)
      |> Enum.count(&(at(tm, &1) == "#"))
    end
  end

  def part_1(input) do
    TobogganMap.new(input)
    |> TobogganMap.count_trees_of_slope({3, 1})
  end

  def part_2(input, slopes \\ [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]) do
    tm = TobogganMap.new(input)

    slopes
    |> Enum.map(&TobogganMap.count_trees_of_slope(tm, &1))
    |> Enum.reduce(1, &*/2)
  end
end

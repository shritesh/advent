defmodule Advent.Day1 do
  defp input_to_numbers(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part_1(input) do
    numbers = input_to_numbers(input)

    Stream.flat_map(numbers, fn x -> Stream.map(numbers, fn y -> [x, y] end) end)
    |> Enum.find(&(Enum.sum(&1) == 2020))
    |> Enum.reduce(1, &*/2)
  end

  def part_2(input) do
    numbers = input_to_numbers(input)

    Stream.flat_map(numbers, fn x ->
      Stream.flat_map(numbers, fn y ->
        Stream.map(numbers, fn z ->
          [x, y, z]
        end)
      end)
    end)
    |> Enum.find(&(Enum.sum(&1) == 2020))
    |> Enum.reduce(1, &*/2)
  end
end

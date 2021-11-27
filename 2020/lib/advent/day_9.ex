defmodule Advent.Day9 do
  defp input_to_numbers(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp valid_chunk?(chunk) do
    [sum | numbers] = Enum.reverse(chunk)

    Stream.flat_map(numbers, fn x -> Stream.map(numbers, fn y -> {x, y} end) end)
    |> Stream.filter(fn {x, y} -> x != y end)
    |> Enum.any?(fn {x, y} -> x + y == sum end)
  end

  defp find_invalid_number(numbers, preamble_length) do
    numbers
    |> Enum.chunk_every(preamble_length + 1, 1, :discard)
    |> Enum.find(&(!valid_chunk?(&1)))
    |> List.last()
  end

  def part_1(input, preamble_length \\ 25) do
    input_to_numbers(input)
    |> find_invalid_number(preamble_length)
  end

  # Returns the slice of `chunk` that sums to `sum`, nil otherwise
  defp sums_up_to_slice?(chunk, sum) do
    Enum.reduce_while(chunk, {0, []}, fn n, {acc, list} ->
      case acc + n do
        ^sum -> {:halt, [n | list]}
        new_sum when new_sum > sum -> {:halt, nil}
        new_sum -> {:cont, {new_sum, [n | list]}}
      end
    end)
  end

  def part_2(input, preamble_length \\ 25) do
    numbers = input_to_numbers(input)
    invalid_number = find_invalid_number(numbers, preamble_length)

    # Chunks of numbers[0..n], numbers[1..n], ...
    chunks =
      Enum.reverse(numbers)
      |> Enum.scan([], fn x, acc -> [x | acc] end)
      |> Enum.reverse()

    {min, max} =
      Enum.find_value(chunks, &sums_up_to_slice?(&1, invalid_number))
      |> Enum.min_max()

    min + max
  end
end

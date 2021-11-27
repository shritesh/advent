defmodule Advent.Day15 do
  defp number_stream(numbers) do
    store =
      Enum.with_index(numbers)
      |> Enum.into(%{})

    spoken_stream =
      Stream.unfold({store, List.last(numbers)}, fn {store, last} ->
        {next, idx} =
          case store[last] do
            {prev, curr} -> {curr - prev, curr + 1}
            curr -> {0, curr + 1}
          end

        new_store =
          Map.update(store, next, idx, fn
            {_prev, curr} -> {curr, idx}
            curr -> {curr, idx}
          end)

        {next, {new_store, next}}
      end)

    Stream.concat(numbers, spoken_stream)
  end

  def part_1(numbers) do
    number_stream(numbers)
    |> Enum.at(2020 - 1)
  end

  def part_2(numbers) do
    number_stream(numbers)
    |> Enum.at(30_000_000 - 1)
  end
end

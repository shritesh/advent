defmodule Advent.Day10 do
  defp sorted_adapter_list(input) do
    numbers =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    device_jolt = Enum.max(numbers) + 3
    Enum.sort([0, device_jolt | numbers])
  end

  def part_1(input) do
    adapters = sorted_adapter_list(input)

    %{1 => ones, 3 => threes} =
      adapters
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies_by(fn [x, y] -> y - x end)

    ones * threes
  end

  def part_2(input) do
    adapters = sorted_adapter_list(input)

    adapter_set = MapSet.new(adapters)

    fitting_adapters_map =
      Enum.into(adapters, %{}, fn n ->
        fitting_adapters = Enum.filter([n + 1, n + 2, n + 3], &MapSet.member?(adapter_set, &1))
        {n, fitting_adapters}
      end)

    # Map of adapter and number of arragements
    arrangement_map =
      Enum.reverse(adapters)
      |> Enum.reduce(%{}, fn n, acc ->
        count =
          case fitting_adapters_map[n] do
            # Final adapter
            [] ->
              1

            fitting_adapters ->
              Enum.map(fitting_adapters, &acc[&1])
              |> Enum.sum()
          end

        Map.put(acc, n, count)
      end)

    arrangement_map[0]
  end
end

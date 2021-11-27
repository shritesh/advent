defmodule Advent.Day13 do
  defp bus_at(bus_ids, tick) do
    Enum.find(bus_ids, &(rem(tick, &1) == 0))
  end

  defp bus_stream(bus_ids) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.flat_map(
      &case bus_at(bus_ids, &1) do
        nil -> []
        bus_id -> [{&1, bus_id}]
      end
    )
  end

  def part_1(input) do
    [line_1, line_2] = String.split(input, "\n", trim: true)

    earliest = String.to_integer(line_1)

    bus_ids =
      for number <- String.split(line_2, ","), number != "x", do: String.to_integer(number)

    Enum.find_value(bus_stream(bus_ids), fn {tick, bus_id} ->
      if tick > earliest do
        (tick - earliest) * bus_id
      end
    end)
  end

  defp chinese_remainder(pairs) do
    # Based on https://www.youtube.com/watch?v=zIFehsBHB8o
    big_n = Enum.reduce(pairs, 1, fn {ni, _bi}, acc -> acc * ni end)

    for {ni, bi} <- pairs do
      big_ni = div(big_n, ni)

      m = rem(big_ni, ni)
      xi = Enum.find(1..ni, &(rem(m * &1, ni) == 1))
      bi * big_ni * xi
    end
    |> Enum.sum()
    |> rem(big_n)
  end

  def part_2(input) do
    String.split(input, ",")
    |> Enum.with_index()
    |> Enum.filter(fn {n, _idx} -> n != "x" end)
    |> Enum.map(fn {n, idx} ->
      n = String.to_integer(n)
      {n, n - idx}
    end)
    |> chinese_remainder()
  end
end

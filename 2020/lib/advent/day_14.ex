defmodule Advent.Day14 do
  use Bitwise

  defp input_to_assignments(input) do
    for line <- String.split(input, "\n", trim: true) do
      [location, value] = String.split(line, " = ")

      case location do
        "mask" ->
          {:mask, value}

        "mem[" <> address ->
          {address, "]"} = Integer.parse(address)
          value = String.to_integer(value)
          {address, value}
      end
    end
  end

  defp run(input, fun) do
    Enum.reduce(input_to_assignments(input), {%{}, nil}, fun)
    |> elem(0)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part_1(input) do
    run(input, fn
      {:mask, value}, {memory, _mask} ->
        zero_mask = String.replace(value, "X", "1") |> String.to_integer(2)
        one_mask = String.replace(value, "X", "0") |> String.to_integer(2)
        {memory, {zero_mask, one_mask}}

      {address, value}, {memory, {zero_mask, one_mask} = mask} ->
        masked_value =
          value
          |> band(zero_mask)
          |> bor(one_mask)

        new_memory = Map.put(memory, address, masked_value)

        {new_memory, mask}
    end)
  end

  def masked_addresses(address, mask) do
    base_mask =
      Integer.to_string(address, 2)
      |> String.pad_leading(String.length(mask), "0")
      |> String.codepoints()
      |> Enum.zip(String.codepoints(mask))
      |> Enum.map(fn
        {char, "0"} -> char
        {_char, "1"} -> "1"
        {_char, "X"} -> "X"
      end)
      |> Enum.join()

    base_address = String.replace(base_mask, "X", "0") |> String.to_integer(2)

    String.replace(base_mask, "1", "0")
    |> String.codepoints()
    |> Enum.reduce([], fn
      "X", [] ->
        ["0", "1"]

      "X", list ->
        Enum.concat(
          Enum.map(list, &("0" <> &1)),
          Enum.map(list, &("1" <> &1))
        )

      char, [] ->
        [char]

      char, list ->
        Enum.map(list, &(char <> &1))
    end)
    |> Enum.map(&String.reverse/1)
    |> Enum.map(&String.to_integer(&1, 2))
    |> Enum.map(&bor(&1, base_address))
  end

  def part_2(input) do
    run(input, fn
      {:mask, new_mask}, {memory, _mask} ->
        {memory, new_mask}

      {address, value}, {memory, mask} ->
        new_memory =
          masked_addresses(address, mask)
          |> Enum.reduce(memory, &Map.put(&2, &1, value))

        {new_memory, mask}
    end)
  end
end

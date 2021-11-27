defmodule Advent.Day8 do
  defp instruction_map(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {[op, argument], idx} ->
      {idx, {op, String.to_integer(argument)}}
    end)
  end

  defp execution_stream(instructions) do
    Stream.iterate({0, 0}, fn {idx, acc} ->
      case instructions[idx] do
        {"nop", _} -> {idx + 1, acc}
        {"jmp", argument} -> {idx + argument, acc}
        {"acc", argument} -> {idx + 1, acc + argument}
        nil -> {:done, acc}
      end
    end)
  end

  defp run(instructions) do
    instructions
    |> execution_stream()
    |> Enum.reduce_while(MapSet.new(), fn
      {:done, acc}, _executed_ids ->
        {:halt, {:done, acc}}

      {idx, acc}, executed_ids ->
        if MapSet.member?(executed_ids, idx),
          do: {:halt, {:loop, acc}},
          else: {:cont, MapSet.put(executed_ids, idx)}
    end)
  end

  def part_1(input) do
    instructions = instruction_map(input)
    {:loop, acc} = run(instructions)
    acc
  end

  def part_2(input) do
    instructions = instruction_map(input)

    instructions
    |> Enum.filter(fn {_idx, {op, _}} -> op != "acc" end)
    |> Enum.find_value(fn {idx, {op, offset}} ->
      new_op = if op == "jmp", do: "nop", else: "jmp"
      mutated_instructions = Map.put(instructions, idx, {new_op, offset})

      case run(mutated_instructions) do
        {:done, acc} -> acc
        {:loop, _acc} -> false
      end
    end)
  end
end

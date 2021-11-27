defmodule Advent.Day16 do
  @rule_regex ~r/(.*): (\d+)-(\d+) or (\d+)-(\d+)/

  defp ticket_to_list(line), do: String.split(line, ",") |> Enum.map(&String.to_integer/1)

  def parse_input(input) do
    [rules, your_ticket, nearby_tickets] = String.split(input, "\n\n", trim: true)

    rules =
      for [rule_name | numbers] <- Regex.scan(@rule_regex, rules, capture: :all_but_first),
          into: %{} do
        [a, b, c, d] = Enum.map(numbers, &String.to_integer/1)
        {rule_name, {a..b, c..d}}
      end

    ["your ticket:", your_ticket] = String.split(your_ticket, "\n", trim: true)
    your_ticket = ticket_to_list(your_ticket)

    ["nearby tickets:" | nearby_tickets] = String.split(nearby_tickets, "\n", trim: true)
    nearby_tickets = Enum.map(nearby_tickets, &ticket_to_list/1)

    {rules, your_ticket, nearby_tickets}
  end

  defp rule_applies?({_rule_name, {range_1, range_2}}, n), do: n in range_1 || n in range_2

  defp valid_ticket?(rules, n), do: Enum.any?(rules, &rule_applies?(&1, n))

  def part_1(input) do
    {rules, _your, nearby} = parse_input(input)

    Enum.map(nearby, fn tickets ->
      Enum.find(tickets, &(!valid_ticket?(rules, &1)))
    end)
    |> Enum.filter(& &1)
    |> Enum.sum()
  end

  def solve_columns(columns) do
    Enum.map(columns, &MapSet.new/1)
    |> Enum.with_index()
    |> Enum.sort_by(&Enum.count(elem(&1, 0)))
    |> Enum.map_reduce(MapSet.new(), fn {column_set, idx}, acc ->
      [n] = MapSet.difference(column_set, acc) |> Enum.to_list()
      {{idx, n}, MapSet.put(acc, n)}
    end)
    |> elem(0)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end

  def part_2(input, prefix \\ "departure") do
    {rules, your, nearby} = parse_input(input)

    valid_nearby_tickets =
      Enum.filter(nearby, fn ticket -> Enum.all?(ticket, &valid_ticket?(rules, &1)) end)

    # Transpose all tickets
    all_columns =
      List.zip([your | valid_nearby_tickets])
      |> Enum.map(&Tuple.to_list/1)

    possible_columns =
      Enum.map(all_columns, fn column ->
        Enum.flat_map(rules, fn {rule_name, _} = rule ->
          if Enum.all?(column, &rule_applies?(rule, &1)), do: [rule_name], else: []
        end)
      end)

    solve_columns(possible_columns)
    |> Enum.with_index()
    |> Enum.filter(fn {column, _idx} -> String.starts_with?(column, prefix) end)
    |> Enum.map(fn {_column, idx} -> Enum.at(your, idx) end)
    |> Enum.reduce(1, &*/2)
  end
end

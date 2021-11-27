defmodule Advent.Day7 do
  @rule_regex ~r/(?<color>[\w ]*) bags contain (?<contents>.*)\./
  @contents_regex ~r/(?<count>\d+) (?<color>[a-z ]+) bags?/

  def parse_rules(input) do
    for sentence <- String.split(input, "\n", trim: true), into: %{} do
      %{"color" => color, "contents" => contents} = Regex.named_captures(@rule_regex, sentence)

      bags =
        for [color, count] <- Regex.scan(@contents_regex, contents, capture: :all_names),
            into: %{},
            do: {color, String.to_integer(count)}

      {color, bags}
    end
  end

  defp holds?(rules, container_color, bag_color) do
    holding_colors = Map.keys(rules[container_color])

    bag_color in holding_colors || Enum.any?(holding_colors, &holds?(rules, &1, bag_color))
  end

  def part_1(input, bag_color \\ "shiny gold") do
    rules = parse_rules(input)

    Map.keys(rules)
    |> Enum.filter(&(&1 != bag_color))
    |> Enum.count(&holds?(rules, &1, bag_color))
  end

  defp count_bags(rules, color) do
    rules[color]
    |> Enum.map(fn {bag_color, count} -> count + count * count_bags(rules, bag_color) end)
    |> Enum.sum()
  end

  def part_2(input, bag_color \\ "shiny gold") do
    parse_rules(input)
    |> count_bags(bag_color)
  end
end

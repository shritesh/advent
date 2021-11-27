defmodule Advent.Day4 do
  defp passport_map(passport_text) do
    String.split(passport_text, ["\n", " "], trim: true)
    |> Enum.into(%{}, &List.to_tuple(String.split(&1, ":")))
  end

  defp valid_passport_1?(passport) do
    required_fields = ~w{byr iyr eyr hgt hcl ecl pid}
    keys = Map.keys(passport)
    Enum.all?(required_fields, &(&1 in keys))
  end

  def part_1(input) do
    String.split(input, "\n\n")
    |> Enum.map(&passport_map/1)
    |> Enum.count(&valid_passport_1?/1)
  end

  defp valid_passport_2?(passport) do
    validations = %{
      "byr" => &(Regex.match?(~r/^\d{4}$/, &1) and String.to_integer(&1) in 1920..2002),
      "iyr" => &(Regex.match?(~r/^\d{4}$/, &1) and String.to_integer(&1) in 2010..2020),
      "eyr" => &(Regex.match?(~r/^\d{4}$/, &1) and String.to_integer(&1) in 2020..2030),
      "hgt" =>
        &case Integer.parse(&1) do
          {h, "cm"} -> h in 150..193
          {h, "in"} -> h in 59..76
          _ -> false
        end,
      "hcl" => &Regex.match?(~r/^#[a-f,0-9]{6}$/, &1),
      "ecl" => &(&1 in ~w{amb blu brn gry grn hzl oth}),
      "pid" => &Regex.match?(~r/^\d{9}$/, &1)
    }

    Enum.all?(validations, fn {field, validation} ->
      Map.has_key?(passport, field) and validation.(passport[field])
    end)
  end

  def part_2(input) do
    String.split(input, "\n\n")
    |> Enum.map(&passport_map/1)
    |> Enum.count(&valid_passport_2?/1)
  end
end

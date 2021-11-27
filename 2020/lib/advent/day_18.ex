defmodule Advent.Day18 do
  defp tokenize(input) do
    input
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split(" ", trim: true)
    |> Enum.map(fn
      "+" -> :add
      "*" -> :mul
      "(" -> :open
      ")" -> :close
      n -> String.to_integer(n)
    end)
  end

  defp parse([:open | rest], acc) do
    {parens, rest} = parse(rest, [])
    parse(rest, [parens | acc])
  end

  defp parse([:close | rest], acc), do: {Enum.reverse(acc), rest}
  defp parse([n | rest], acc), do: parse(rest, [n | acc])
  defp parse([], acc), do: Enum.reverse(acc)

  defmodule Day1 do
    def eval([n]), do: n
    def eval([a, :add, b | rest]), do: eval([eval(a) + eval(b) | rest])
    def eval([a, :mul, b | rest]), do: eval([eval(a) * eval(b) | rest])
    def eval(n), do: n
  end

  defmodule Day2 do
    def eval([n]), do: n
    def eval([a, :add, b | rest]), do: eval([eval(a) + eval(b) | rest])
    def eval([a, :mul, b | rest]), do: eval(a) * eval([eval(b) | rest])
    def eval(n), do: n
  end

  defp run(lines, day) do
    for input <- String.split(lines, "\n", trim: true) do
      input
      |> tokenize()
      |> parse([])
      |> day.eval()
    end
    |> Enum.sum()
  end

  def part_1(lines) do
    run(lines, Day1)
  end

  def part_2(lines) do
    run(lines, Day2)
  end
end

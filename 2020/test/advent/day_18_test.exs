defmodule Advent.Day18Test do
  use ExUnit.Case
  alias Advent.Day18

  describe "part 1" do
    @examples [
      {"1 + 2 * 3 + 4 * 5 + 6", 71},
      {"1 + (2 * 3) + (4 * (5 + 6))", 51},
      {"2 * 3 + (4 * 5)", 26},
      {"5 + (8 * 3 + 9 + 3 * 4 * 3)", 437},
      {"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240},
      {"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632}
    ]

    test "eval" do
      for {exp, result} <- @examples do
        assert Day18.part_1(exp) == result
      end
    end

    test "sum" do
      input = Enum.map(@examples, &elem(&1, 0)) |> Enum.join("\n")
      expectation = Enum.map(@examples, &elem(&1, 1)) |> Enum.sum()

      assert Day18.part_1(input) == expectation
    end
  end

  describe "part 2" do
    @examples [
      {"1 + 2 * 3 + 4 * 5 + 6", 231},
      {"1 + (2 * 3) + (4 * (5 + 6))", 51},
      {"2 * 3 + (4 * 5)", 46},
      {"5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445},
      {"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669_060},
      {"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340}
    ]

    test "eval" do
      for {exp, result} <- @examples do
        assert Day18.part_2(exp) == result
      end
    end

    test "sum" do
      input = Enum.map(@examples, &elem(&1, 0)) |> Enum.join("\n")
      expectation = Enum.map(@examples, &elem(&1, 1)) |> Enum.sum()

      assert Day18.part_2(input) == expectation
    end
  end
end

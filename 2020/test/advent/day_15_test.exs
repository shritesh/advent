defmodule Advent.Day15Test do
  use ExUnit.Case
  alias Advent.Day15

  test "part_1" do
    [
      {[0, 3, 6], 436},
      {[1, 3, 2], 1},
      {[2, 1, 3], 10},
      {[1, 2, 3], 27},
      {[2, 3, 1], 78},
      {[3, 2, 1], 438},
      {[3, 1, 2], 1836}
    ]
    |> Enum.each(fn {input, expectation} ->
      assert Day15.part_1(input) == expectation
    end)
  end

  @tag :skip
  test "part_2" do
    [
      {[0, 3, 6], 175_594},
      {[1, 3, 2], 2578},
      {[2, 1, 3], 3_544_142},
      {[1, 2, 3], 261_214},
      {[2, 3, 1], 6_895_259},
      {[3, 2, 1], 18},
      {[3, 1, 2], 362}
    ]
    |> Enum.each(fn {input, expectation} ->
      assert Day15.part_2(input) == expectation
    end)
  end
end

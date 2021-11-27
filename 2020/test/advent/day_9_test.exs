defmodule Advent.Day9Test do
  use ExUnit.Case
  alias Advent.Day9

  @example """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  test "part_1" do
    assert Day9.part_1(@example, 5) == 127
  end

  test "part_2" do
    assert Day9.part_2(@example, 5) == 62
  end
end

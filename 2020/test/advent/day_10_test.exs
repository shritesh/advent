defmodule Advent.Day10Test do
  use ExUnit.Case
  alias Advent.Day10

  @example1 """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """

  @example2 """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
  """

  test "part_1" do
    assert Day10.part_1(@example1) == 7 * 5
    assert Day10.part_1(@example2) == 22 * 10
  end

  test "part_2" do
    assert Day10.part_2(@example1) == 8
    assert Day10.part_2(@example2) == 19208
  end
end

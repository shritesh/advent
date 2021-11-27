defmodule Advent.Day1Test do
  use ExUnit.Case
  alias Advent.Day1

  @example """
  1721
  979
  366
  299
  675
  1456
  """

  test "part_1" do
    assert Day1.part_1(@example) == 514_579
  end

  test "part_2" do
    assert Day1.part_2(@example) == 241_861_950
  end
end

defmodule Advent.Day11Test do
  use ExUnit.Case
  alias Advent.Day11

  @example """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """

  test "part_1" do
    assert Day11.part_1(@example) == 37
  end

  test "part_2" do
    assert Day11.part_2(@example) == 26
  end
end

defmodule Advent.Day12Test do
  use ExUnit.Case
  alias Advent.Day12

  @example """
  F10
  N3
  F7
  R90
  F11
  """

  test "part_1" do
    assert Day12.part_1(@example) == 25
  end

  test "part_2" do
    assert Day12.part_2(@example) == 286
  end
end

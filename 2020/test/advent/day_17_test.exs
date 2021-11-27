defmodule Advent.Day17Test do
  use ExUnit.Case
  alias Advent.Day17

  @example """
  .#.
  ..#
  ###
  """

  test "part_1" do
    assert Day17.part_1(@example) == 112
  end

  test "part_4" do
    assert Day17.part_2(@example) == 848
  end
end

defmodule Advent.Day22Test do
  use ExUnit.Case
  alias Advent.Day22

  @example """
  Player 1:
  9
  2
  6
  3
  1

  Player 2:
  5
  8
  4
  7
  10
  """

  test "part_1" do
    assert Day22.part_1(@example) == 306
  end
end

defmodule Advent.Day2Test do
  use ExUnit.Case
  alias Advent.Day2

  @example """
  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
  """

  test "part_1" do
    assert Day2.part_1(@example) == 2
  end

  test "part_2" do
    assert Day2.part_2(@example) == 1
  end
end

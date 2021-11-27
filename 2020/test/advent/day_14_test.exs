defmodule Advent.Day14Test do
  use ExUnit.Case
  alias Advent.Day14

  test "part_1" do
    example = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    assert Day14.part_1(example) == 165
  end

  test "masked_addresses" do
    result = Day14.masked_addresses(42, "000000000000000000000000000000X1001X")

    for expectation <- [26, 27, 58, 59] do
      assert expectation in result
    end
  end

  test "part_2" do
    example = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

    assert Day14.part_2(example) == 208
  end
end

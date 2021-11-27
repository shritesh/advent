defmodule Advent.Day8Test do
  use ExUnit.Case
  alias Advent.Day8

  @example """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  test "part_1" do
    assert Day8.part_1(@example) == 5
  end

  test "part_2" do
    assert Day8.part_2(@example) == 8
  end
end

defmodule Advent.Day16Test do
  use ExUnit.Case
  alias Advent.Day16

  test "part_1" do
    example = """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """

    assert Day16.part_1(example) == 71
  end

  test "part_2" do
    example = """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """

    assert Day16.part_2(example, "") == 12 * 11 * 13
  end

  test "solve_columns" do
    assert Day16.solve_columns([[1, 2], [1], [1, 2, 3]]) == [2, 1, 3]
  end
end

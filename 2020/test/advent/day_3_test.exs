defmodule Advent.Day3Test do
  use ExUnit.Case
  alias Advent.Day3

  @example """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  test "part_1" do
    assert Day3.part_1(@example) == 7
  end

  test "part_2" do
    assert Day3.part_2(@example) == 336
  end
end

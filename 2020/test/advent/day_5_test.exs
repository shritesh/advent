defmodule Advent.Day5Test do
  use ExUnit.Case
  alias Advent.Day5

  @passes %{
    "FBFBBFFRLR" => 357,
    "BFFFBBFRRR" => 567,
    "FFFBBBFRRR" => 119,
    "BBFFBBFRLL" => 820
  }

  test "seat_number" do
    Enum.each(@passes, fn {pass, result} ->
      assert Day5.seat_number(pass) == result
    end)
  end

  test "part_1" do
    assert 820 ==
             @passes
             |> Map.keys()
             |> Enum.join("\n")
             |> Day5.part_1()
  end
end

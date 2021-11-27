defmodule Advent.Day13Test do
  use ExUnit.Case
  alias Advent.Day13

  test "part_1" do
    example = """
    939
    7,13,x,x,59,x,31,19
    """

    assert Day13.part_1(example) == 295
  end

  test "part_2" do
    for {schedule, result} <- [
          {"17,x,13,19", 3417},
          {"67,7,59,61", 754_018},
          {"67,x,7,59,61", 779_210},
          {"67,7,x,59,61", 1_261_476},
          {"1789,37,47,1889", 1_202_161_486}
        ] do
      assert Day13.part_2(schedule) == result
    end
  end
end

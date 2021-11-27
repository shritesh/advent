defmodule Advent.Day12 do
  defmodule Ship do
    defstruct [:location, :direction]

    def new do
      %__MODULE__{location: {0, 0}, direction: {1, 0}}
    end

    def action(%__MODULE__{location: {x, y}} = ship, {:move, {dx, dy}}) do
      %{ship | location: {x + dx, y + dy}}
    end

    def action(%__MODULE__{direction: direction} = ship, {:rotate, angle}) do
      %{ship | direction: Advent.Day12.rotate(direction, angle)}
    end

    def action(%__MODULE__{direction: {rx, ry}} = ship, {:forward, units}) do
      action(ship, {:move, {rx * units, ry * units}})
    end
  end

  defmodule WaypointShip do
    defstruct [:location, :waypoint]

    def new do
      %__MODULE__{location: {0, 0}, waypoint: {10, 1}}
    end

    def action(%__MODULE__{waypoint: {x, y}} = ship, {:move, {dx, dy}}) do
      %{ship | waypoint: {x + dx, y + dy}}
    end

    def action(%__MODULE__{waypoint: waypoint} = ship, {:rotate, angle}) do
      %{ship | waypoint: Advent.Day12.rotate(waypoint, angle)}
    end

    def action(
          %__MODULE__{location: {x, y}, waypoint: {wx, wy}} = ship,
          {:forward, times}
        ) do
      {dx, dy} = {wx * times, wy * times}
      %{ship | location: {x + dx, y + dy}}
    end
  end

  def rotate({rx, ry}, angle) do
    case angle do
      90 -> {-ry, rx}
      180 -> {-rx, -ry}
      270 -> {ry, -rx}
    end
  end

  def manhattan_distance(%{location: {x, y}}) do
    abs(x) + abs(y)
  end

  defp input_to_directions(input) do
    for line <- String.split(input, "\n", trim: true) do
      {action, units} = String.split_at(line, 1)
      units = String.to_integer(units)

      case action do
        "N" -> {:move, {0, units}}
        "S" -> {:move, {0, -units}}
        "E" -> {:move, {units, 0}}
        "W" -> {:move, {-units, 0}}
        "L" -> {:rotate, units}
        "R" -> {:rotate, 360 - units}
        "F" -> {:forward, units}
      end
    end
  end

  def part_1(input) do
    input_to_directions(input)
    |> Enum.reduce(Ship.new(), &Ship.action(&2, &1))
    |> manhattan_distance()
  end

  def part_2(input) do
    input_to_directions(input)
    |> Enum.reduce(WaypointShip.new(), &WaypointShip.action(&2, &1))
    |> manhattan_distance()
  end
end

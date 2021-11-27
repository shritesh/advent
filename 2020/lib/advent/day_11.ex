defmodule Advent.Day11 do
  @floor "."
  @empty "L"
  @occupied "#"

  @directions [{-1, -1}, {-1, 0}, {-1, +1}, {0, -1}, {0, +1}, {+1, -1}, {+1, 0}, {+1, +1}]

  defp input_to_grid(input) do
    for {line, row} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {char, col} <- Enum.with_index(String.codepoints(line)),
        into: %{},
        do: {{row, col}, char}
  end

  defp count_total_occupied(grid) do
    Enum.count(grid, fn {_coords, seat} -> seat == @occupied end)
  end

  defp count_occupied_adjacent(grid, {row, col}) do
    Enum.count(@directions, fn {d_row, d_col} ->
      grid[{row + d_row, col + d_col}] == @occupied
    end)
  end

  defp visible_seat_in_direction(grid, coords, {d_row, d_col}) do
    next_coords = fn {row, col} -> {row + d_row, col + d_col} end

    Stream.iterate(next_coords.(coords), next_coords)
    |> Stream.map(&grid[&1])
    |> Enum.find(&(&1 != @floor))
  end

  defp count_occupied_around(grid, coords) do
    Enum.count(@directions, &(visible_seat_in_direction(grid, coords, &1) == @occupied))
  end

  def next(grid, count_fn, occupancy_limit) do
    for coords <- Map.keys(grid), into: %{} do
      next_char =
        case grid[coords] do
          @floor -> @floor
          @empty -> if count_fn.(grid, coords) == 0, do: @occupied, else: @empty
          @occupied -> if count_fn.(grid, coords) >= occupancy_limit, do: @empty, else: @occupied
        end

      {coords, next_char}
    end
  end

  defp run(input, count_fn, occupancy_limit) do
    input_to_grid(input)
    |> Stream.iterate(&next(&1, count_fn, occupancy_limit))
    |> Stream.chunk_every(2, 1)
    |> Enum.find_value(fn [prev, current] -> if prev == current, do: current end)
    |> count_total_occupied()
  end

  def part_1(input) do
    run(input, &count_occupied_adjacent/2, 4)
  end

  def part_2(input) do
    run(input, &count_occupied_around/2, 5)
  end
end

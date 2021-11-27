defmodule Advent.Day17 do
  defmodule Conway3D do
    def new(input) do
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} <- Enum.with_index(String.codepoints(line)),
          char == "#",
          into: MapSet.new(),
          do: {x, y, 0}
    end

    defp active?(actives, {x, y, z}) do
      MapSet.member?(actives, {x, y, z})
    end

    def count_actives(actives), do: Enum.count(actives)

    defp count_active_neighbors(actives, {x, y, z}) do
      neighbors =
        for dx <- -1..1,
            dy <- -1..1,
            dz <- -1..1,
            {dx, dy, dz} != {0, 0, 0},
            do: {x + dx, y + dy, z + dz}

      Enum.count(neighbors, &active?(actives, &1))
    end

    defp coordinate_range(actives) do
      Enum.reduce(actives, {{0, 0}, {0, 0}, {0, 0}}, fn {x, y, z},
                                                        {{min_x, max_x}, {min_y, max_y},
                                                         {min_z, max_z}} ->
        {
          Enum.min_max([min_x, x, max_x]),
          Enum.min_max([min_y, y, max_y]),
          Enum.min_max([min_z, z, max_z])
        }
      end)
    end

    def next_cycle(actives) do
      {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}} = coordinate_range(actives)

      for x <- (min_x - 1)..(max_x + 1),
          y <- (min_y - 1)..(max_y + 1),
          z <- (min_z - 1)..(max_z + 1),
          reduce: MapSet.new() do
        acc ->
          coordinate = {x, y, z}

          next_active =
            case {active?(actives, coordinate), count_active_neighbors(actives, coordinate)} do
              {true, neighbors} when neighbors in [2, 3] -> true
              {false, 3} -> true
              _ -> false
            end

          if next_active, do: MapSet.put(acc, coordinate), else: acc
      end
    end
  end

  def part_1(input) do
    Enum.reduce(1..6, Conway3D.new(input), fn _, actives -> Conway3D.next_cycle(actives) end)
    |> Conway3D.count_actives()
  end

  defmodule Conway4D do
    def new(input) do
      for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
          {char, x} <- Enum.with_index(String.codepoints(line)),
          char == "#",
          into: MapSet.new(),
          do: {x, y, 0, 0}
    end

    defp active?(actives, {x, y, z, w}) do
      MapSet.member?(actives, {x, y, z, w})
    end

    def count_actives(actives), do: Enum.count(actives)

    defp count_active_neighbors(actives, {x, y, z, w}) do
      neighbors =
        for dx <- -1..1,
            dy <- -1..1,
            dz <- -1..1,
            dw <- -1..1,
            {dx, dy, dz, dw} != {0, 0, 0, 0},
            do: {x + dx, y + dy, z + dz, w + dw}

      Enum.count(neighbors, &active?(actives, &1))
    end

    defp coordinate_range(actives) do
      Enum.reduce(actives, {{0, 0}, {0, 0}, {0, 0}, {0, 0}}, fn {x, y, z, w},
                                                                {{min_x, max_x}, {min_y, max_y},
                                                                 {min_z, max_z},
                                                                 {min_w, max_w}} ->
        {
          Enum.min_max([min_x, x, max_x]),
          Enum.min_max([min_y, y, max_y]),
          Enum.min_max([min_z, z, max_z]),
          Enum.min_max([min_w, w, max_w])
        }
      end)
    end

    def next_cycle(actives) do
      {{min_x, max_x}, {min_y, max_y}, {min_z, max_z}, {min_w, max_w}} = coordinate_range(actives)

      for x <- (min_x - 1)..(max_x + 1),
          y <- (min_y - 1)..(max_y + 1),
          z <- (min_z - 1)..(max_z + 1),
          w <- (min_w - 1)..(max_w + 1),
          reduce: MapSet.new() do
        acc ->
          coordinate = {x, y, z, w}

          next_active =
            case {active?(actives, coordinate), count_active_neighbors(actives, coordinate)} do
              {true, neighbors} when neighbors in [2, 3] -> true
              {false, 3} -> true
              _ -> false
            end

          if next_active, do: MapSet.put(acc, coordinate), else: acc
      end
    end
  end

  def part_2(input) do
    Enum.reduce(1..6, Conway4D.new(input), fn _, actives -> Conway4D.next_cycle(actives) end)
    |> Conway4D.count_actives()
  end
end

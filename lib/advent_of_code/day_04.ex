defmodule AdventOfCode.Day04 do
  @doc """
  Return 1 if X-M-A-S in a given direction
  """
  def check_pattern(grid, x, y, {dx, dy}) do
    pattern = [{0, "X"}, {1, "M"}, {2, "A"}, {3, "S"}]

    Enum.all?(pattern, fn {offset, expected} ->
      MapSet.member?(grid, {x + offset * dx, y + offset * dy, expected})
    end)
    |> if(do: 1, else: 0)
  end

  def part1(filepath) do
    grid =
      filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {row, x}, acc ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {value, y}, acc ->
          MapSet.put(acc, {x, y, value})
        end)
      end)

    # all 8 directions, up/down/left/right, NE/NW/SE/SW
    directions = [
      {0, -1},
      {0, 1},
      {-1, 0},
      {1, 0},
      {-1, -1},
      {-1, 1},
      {1, -1},
      {1, 1}
    ]

    # Check the pattern in all directions
    results =
      Enum.reduce(grid, 0, fn cell, acc ->
        count_from_cell =
          Enum.map(directions, fn dir ->
            check_pattern(grid, elem(cell, 0), elem(cell, 1), dir)
          end)
          |> Enum.sum()

        acc + count_from_cell
      end)

    results
  end

  def check_pattern_part_two(x, y, grid) do
    # redundant A checks but helps visualize easier...
    patterns = [
      [{-1, -1, "M"}, {0, 0, "A"}, {1, 1, "S"}, {1, -1, "M"}, {0, 0, "A"}, {-1, 1, "S"}],
      [{-1, -1, "M"}, {0, 0, "A"}, {1, 1, "S"}, {1, -1, "S"}, {0, 0, "A"}, {-1, 1, "M"}],
      [{-1, -1, "S"}, {0, 0, "A"}, {1, 1, "M"}, {1, -1, "M"}, {0, 0, "A"}, {-1, 1, "S"}],
      [{-1, -1, "S"}, {0, 0, "A"}, {1, 1, "M"}, {1, -1, "S"}, {0, 0, "A"}, {-1, 1, "M"}]
    ]

    Enum.map(patterns, fn sublist ->
      Enum.all?(sublist, fn {x_del, y_del, expected} ->
        MapSet.member?(grid, {x + x_del, y + y_del, expected})
      end)
    end)
    |> Enum.any?()
    |> if(
      do: 1,
      else: 0
    )
  end

  def part2(filepath) do
    grid =
      filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {row, x}, acc ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {value, y}, acc ->
          MapSet.put(acc, {x, y, value})
        end)
      end)

    Enum.reduce(grid, 0, fn cell, acc ->
      acc + check_pattern_part_two(elem(cell, 0), elem(cell, 1), grid)
    end)
  end
end

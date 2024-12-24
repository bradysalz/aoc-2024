defmodule AdventOfCode.Day08 do
  defmodule Cell do
    defstruct [:x, :y, :antenna]
  end

  def load_grid(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.map(fn {lines, row_index} ->
      lines_idx = Enum.with_index(lines)

      Enum.map(lines_idx, fn {val, col_index} ->
        cond do
          val == "." ->
            %Cell{x: col_index, y: row_index}

          true ->
            %Cell{x: col_index, y: row_index, antenna: val}
        end
      end)
    end)
  end

  def find_antennas(grid) do
    grid
    |> List.flatten()
    |> Enum.filter(fn cell ->
      cell.antenna != nil
    end)
  end

  def group_antennas(antennas) do
    antennas
    |> Enum.group_by(& &1.antenna)
    |> Enum.flat_map(fn {_antenna, structs} ->
      Enum.map(structs, fn struct ->
        # chatgpt way to get all matching elemennts besides yourself
        {struct, Enum.filter(structs, &(&1 != struct))}
      end)
    end)
  end

  def on_grid?(antenna, match, scale, max_x, max_y) do
    new_x = antenna.x + (antenna.x - match.x) * scale
    new_y = antenna.y + (antenna.y - match.y) * scale

    if -1 < new_x and new_x < max_x and -1 < new_y and new_y < max_y do
      {new_x, new_y}
    else
      nil
    end
  end

  def calculate_antinodes(ant_groups, max_x, max_y) do
    Enum.reduce(ant_groups, [], fn {antenna, matches}, acc ->
      hits =
        Enum.reduce(matches, [], fn match, acc ->
          cell = on_grid?(antenna, match, 1, max_x, max_y)

          if cell == nil do
            acc
          else
            [cell] ++ acc
          end
        end)

      hits ++ acc
    end)
  end

  def on_grid_recursive?(antenna, match, scale, max_x, max_y) do
    new_x = antenna.x + (antenna.x - match.x) * scale
    new_y = antenna.y + (antenna.y - match.y) * scale

    if -1 < new_x and new_x < max_x and -1 < new_y and new_y < max_y do
      [{new_x, new_y}] ++ on_grid_recursive?(antenna, match, scale + 1, max_x, max_y)
    else
      []
    end
  end

  def calculate_resonance(ant_groups, max_x, max_y) do
    Enum.reduce(ant_groups, [], fn {antenna, matches}, acc ->
      hits =
        Enum.reduce(matches, [], fn match, acc ->
          cell = on_grid_recursive?(antenna, match, 0, max_x, max_y)
          cell ++ acc
        end)

      hits ++ acc
    end)
  end

  def part1(filepath) do
    grid = load_grid(filepath)
    max_y = length(grid)
    max_x = length(Enum.at(grid, 0))

    antenna_groups =
      find_antennas(grid)
      |> group_antennas()

    calculate_antinodes(antenna_groups, max_x, max_y)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(filepath) do
    grid = load_grid(filepath)
    max_y = length(grid)
    max_x = length(Enum.at(grid, 0))

    antenna_groups =
      find_antennas(grid)
      |> group_antennas()

    calculate_resonance(antenna_groups, max_x, max_y)
    |> Enum.uniq()
    |> Enum.count()
  end
end

defmodule AdventOfCode.Day10 do
  def input_to_grid(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {row, x}, acc ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, y}, acc ->
        MapSet.put(acc, {x, y, String.to_integer(value)})
      end)
    end)
  end

  def solve_trails(step, grid) do
    {x, y, value} = step
    dirs = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

    Enum.reduce(dirs, [], fn dir, acc ->
      {stepx, stepy} = dir
      next_step = {x + stepx, y + stepy, value + 1}

      cond do
        # this is wrong technically, as this will record the 9-peak 4x (one per dir)
        # but i figured that out pretty quickly so /4 >> a real refactor
        value == 9 ->
          [step] ++ acc

        MapSet.member?(grid, next_step) ->
          solve_trails(next_step, grid) ++ acc

        true ->
          acc
      end
    end)
  end

  def count_trails({x, y, value}, grid) do
    solve_trails({x, y, value}, grid)
    |> Enum.uniq()
    |> Enum.count()
  end

  def count_trails_part_two({x, y, value}, grid) do
    solve_trails({x, y, value}, grid)
    |> Enum.count()
  end

  def part1(filepath) do
    grid = input_to_grid(filepath)
    trailheads = Enum.filter(grid, fn {_, _, value} -> value == 0 end)

    Enum.map(trailheads, fn trail -> count_trails(trail, grid) end)
    |> Enum.sum()
  end

  def part2(filepath) do
    grid = input_to_grid(filepath)
    trailheads = Enum.filter(grid, fn {_, _, value} -> value == 0 end)

    val =
      Enum.map(trailheads, fn trail -> count_trails_part_two(trail, grid) end)
      |> Enum.sum()

    # this is a lazy solution to bug above, see solve_trails note
    val / 4
  end
end

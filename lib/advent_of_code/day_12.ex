defmodule AdventOfCode.Day12 do
  defmodule Plant do
    defstruct [:value, visited: false, group: nil]
  end

  def input_to_grid(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, y}, acc ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, x}, acc ->
        Map.put(acc, {x, y}, %Plant{value: value})
      end)
    end)
  end

  def map_region(grid, curr_coord) do
    dirs = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

    Enum.reduce(dirs, grid, fn dir, grid_acc ->
      {stepx, stepy} = dir
      {x, y} = curr_coord
      next_step = {x + stepx, y + stepy}

      curr_plant = Map.get(grid_acc, curr_coord)
      next_plant = Map.get(grid_acc, next_step)

      cond do
        is_nil(next_plant) ->
          grid_acc

        !next_plant.visited and next_plant.value == curr_plant.value ->
          new_plant = %Plant{next_plant | visited: true, group: 1}
          new_map = Map.put(grid_acc, next_step, new_plant)
          map_region(new_map, next_step)

        true ->
          grid_acc
      end
    end)

    # new grid, file_id?
  end

  # def grid_to_regions(grid) do
  #   grid
  #   |> Enum.reduce({grid, 0}, fn {key, value}, {new_grid, file_id} ->
  #     cond do
  #     end
  #   end)
  # end

  def part1(filepath) do
    input_to_grid(filepath)
    |> IO.inspect()
    |> map_region({0, 0})
    |> IO.inspect()

    5
  end

  def part2(_args) do
    5
  end
end

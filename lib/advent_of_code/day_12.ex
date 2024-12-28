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

  @doc """
  Map a single region by finding all continuous cells
  """
  def map_region(grid, curr_coord, group_num) do
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
          new_plant = %Plant{next_plant | visited: true, group: group_num}
          new_map = Map.put(grid_acc, next_step, new_plant)
          map_region(new_map, next_step, group_num)

        true ->
          grid_acc
      end
    end)
  end

  @doc """
  Map all regions in the grid, cell by cell operations
  """
  def grid_to_regions(grid) do
    {solved_grid, _} =
      grid
      |> Enum.reduce({grid, 0}, fn {key, _}, {new_grid, group_num} ->
        curr_plant = Map.get(new_grid, key)

        if curr_plant.visited do
          {new_grid, group_num}
        else
          {_, new_grid} =
            Map.get_and_update(new_grid, key, fn curr ->
              {curr, %Plant{curr | visited: true, group: group_num}}
            end)

          new_grid = map_region(new_grid, key, group_num)
          {new_grid, group_num + 1}
        end
      end)

    solved_grid
  end

  @doc """
  mostly notes for me
  - Area = length of list
  - Perimeter = per cell, 4 - count(neighbors).
  hypothetical input looks like:
  1 => [
    {{0, 1}, %Plant{value: "B", visited: true, group: 1}},
    {{0, 2}, %Plant{value: "B", visited: true, group: 1}}
  ]
  """
  def calculate_area_and_perimeter({_group_num, plant_list}) do
    plant_map = Map.new(plant_list)
    dirs = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

    perimeter =
      plant_map
      |> Enum.map(fn {plant, _} ->
        Enum.reduce(dirs, 4, fn dir, acc ->
          {stepx, stepy} = dir
          {x, y} = plant
          next_step = {x + stepx, y + stepy}

          if Map.get(plant_map, next_step) do
            acc - 1
          else
            acc
          end
        end)
      end)
      |> Enum.sum()

    area = length(plant_list)

    area * perimeter
  end

  @doc """
  should've written this 1000 years ago
  """
  def add_points({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  @doc """
  Figure out sides by counting corners. Had to ask reddit for this one!

  A cell has a corner if either of these conditions are true:
  - two adjacent corner cells are off-grid
  - two adjacent corner cells are on-grid, and diagonal is off-grid
  """
  def calculate_sides_and_perimeter({_group_num, plant_list}) do
    plant_map = Map.new(plant_list)

    eval_slots = [
      # down    left    downleft
      [{0, 1}, {-1, 0}, {-1, 1}],
      # left    up      upleft
      [{-1, 0}, {0, -1}, {-1, -1}],
      # up      right    upright
      [{0, -1}, {1, 0}, {1, -1}],
      # right  down    downright
      [{1, 0}, {0, 1}, {1, 1}]
    ]

    side_count =
      plant_map
      |> Enum.map(fn {plant, _} ->
        Enum.reduce(eval_slots, 0, fn dirs, acc ->
          [first_step, second_step, corner_step] =
            Enum.map(dirs, fn d -> add_points(d, plant) end)

          outer_corner =
            Enum.all?([
              is_nil(Map.get(plant_map, first_step)),
              is_nil(Map.get(plant_map, second_step))
            ])

          inner_corner =
            Enum.all?([
              !is_nil(Map.get(plant_map, first_step)),
              !is_nil(Map.get(plant_map, second_step)),
              is_nil(Map.get(plant_map, corner_step))
            ])

          cond do
            outer_corner or inner_corner ->
              acc + 1

            true ->
              acc
          end
        end)
      end)
      |> Enum.sum()

    area = length(plant_list)

    area * side_count
  end

  def part1(filepath) do
    grid = input_to_grid(filepath)

    grid
    |> grid_to_regions()
    |> Enum.group_by(fn {_, value} -> value.group end)
    |> Enum.map(&calculate_area_and_perimeter/1)
    |> Enum.sum()
  end

  def part2(filepath) do
    grid = input_to_grid(filepath)

    grid
    |> grid_to_regions()
    |> Enum.group_by(fn {_, value} -> value.group end)
    |> Enum.map(&calculate_sides_and_perimeter/1)
    |> Enum.sum()
  end
end

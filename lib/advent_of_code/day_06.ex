defmodule Guard do
  defstruct [:x, :y, :direction]
end

defmodule Cell do
  @enforce_keys [:x, :y]
  defstruct [:x, :y, :is_wall, visited: false]
end

defmodule AdventOfCode.Day06 do
  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  defp parse_grid(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({MapSet.new(), %Guard{}}, fn {row, x}, acc ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, y}, acc ->
        {set, guard} = acc

        case value do
          "." ->
            new_set = MapSet.put(set, %Cell{x: x, y: y, is_wall: false})
            {new_set, guard}

          "#" ->
            new_set = MapSet.put(set, %Cell{x: x, y: y, is_wall: true})
            {new_set, guard}

          "^" ->
            new_guard = %{guard | x: x, y: y, direction: @up}
            new_set = MapSet.put(set, %Cell{x: x, y: y, is_wall: false, visited: true})
            {new_set, new_guard}
        end
      end)
    end)
  end

  def outside_grid?(grid, x, y) do
    Enum.any?(grid, fn %Cell{x: px, y: py} -> px == x and py == y end)
    |> Kernel.not()
  end

  def get_cell(grid, x, y) do
    Enum.filter(grid, fn %Cell{x: px, y: py} -> px == x and py == y end)
    |> Enum.at(0)
  end

  def free_real_estate?(grid, x, y) do
    c = get_cell(grid, x, y)
    !c.is_wall
  end

  defp grid_step(grid, guard) do
    {step_x, step_y} = guard.direction
    next_x = guard.x + step_x
    next_y = guard.y + step_y

    cond do
      outside_grid?(grid, next_x, next_y) ->
        {grid, guard}

      free_real_estate?(grid, next_x, next_y) ->
        new_guard = %Guard{guard | x: next_x, y: next_y}
        old_cell = get_cell(grid, next_x, next_y)
        new_grid = MapSet.delete(grid, old_cell)
        new_grid = MapSet.put(new_grid, %Cell{old_cell | visited: true})
        {new_grid, new_guard}

      guard.direction == @up ->
        new_guard = %Guard{guard | direction: @right}
        {grid, new_guard}

      guard.direction == @right ->
        new_guard = %Guard{guard | direction: @down}
        {grid, new_guard}

      guard.direction == @down ->
        new_guard = %Guard{guard | direction: @left}
        {grid, new_guard}

      guard.direction == @left ->
        new_guard = %Guard{guard | direction: @up}
        {grid, new_guard}
    end
  end

  defp update_grid(grid, guard) do
    {new_grid, new_guard} = grid_step(grid, guard)

    if new_grid == grid and new_guard == guard do
      grid
    else
      update_grid(new_grid, new_guard)
    end
  end

  def part1(filepath) do
    {grid, guard} =
      parse_grid(filepath)

    update_grid(grid, guard)
    |> Enum.count(fn cell ->
      cell.visited
    end)
  end

  def part2(_args) do
  end
end

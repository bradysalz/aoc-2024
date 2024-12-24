defmodule AdventOfCode.Day06 do
  @up {0, 1}
  @down {0, -1}
  @left {1, 0}
  @right {-1, 0}

  defmodule Guard do
    defstruct [:x, :y, :direction]
  end

  defmodule Cell do
    defstruct [:x, :y, :is_wall, is_guard: false, guard_dir: [], visited: false]
  end

  def print_grid(grid) do
    IO.puts("")

    grid
    |> Enum.each(fn row ->
      Enum.each(row, fn cell ->
        cond do
          cell.is_wall ->
            IO.write("#")

          cell.visited ->
            IO.write("X")

          true ->
            IO.write(".")
        end
      end)

      IO.puts("")
    end)
  end

  defp get_guard(grid) do
    {row_index, col_index} =
      grid
      |> Enum.with_index()
      |> Enum.find_value(fn {row, row_index} ->
        case Enum.find_index(row, fn cell -> cell.is_guard end) do
          nil -> nil
          col_index -> {row_index, col_index}
        end
      end)

    %Guard{x: col_index, y: row_index, direction: @down}
  end

  defp parse_grid(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.map(fn {lines, row_index} ->
      lines_idx = Enum.with_index(lines)

      Enum.map(lines_idx, fn {val, col_index} ->
        case val do
          "." ->
            %Cell{x: col_index, y: row_index, is_wall: false}

          "#" ->
            %Cell{x: col_index, y: row_index, is_wall: true}

          "^" ->
            %Cell{x: col_index, y: row_index, is_wall: false, is_guard: true, visited: true}
        end
      end)
    end)
  end

  def outside_grid?(new_guard, max_x, max_y) do
    Enum.any?([new_guard.x >= max_x, new_guard.y >= max_y, new_guard.x < 0, new_guard.y < 0])
  end

  def not_a_wall?(grid, new_guard) do
    cell =
      grid
      |> Enum.at(new_guard.y)
      |> Enum.at(new_guard.x)

    !cell.is_wall
  end

  defp grid_step(grid, guard, max_x, max_y) do
    {step_x, step_y} = guard.direction
    next_x = guard.x + step_x
    next_y = guard.y + step_y
    new_guard = %Guard{guard | x: next_x, y: next_y}

    cond do
      outside_grid?(new_guard, max_x, max_y) ->
        {:outside, grid, guard}

      been_here_already?(grid, new_guard) ->
        {:looped, grid, guard}

      not_a_wall?(grid, new_guard) ->
        new_grid =
          grid
          |> List.update_at(new_guard.y, fn row ->
            List.update_at(
              row,
              new_guard.x,
              fn cell ->
                %Cell{cell | visited: true, guard_dir: [guard.direction] ++ cell.guard_dir}
              end
            )
          end)

        {:continue, new_grid, new_guard}

      guard.direction == @up ->
        new_guard = %Guard{guard | direction: @right}
        {:continue, grid, new_guard}

      guard.direction == @right ->
        new_guard = %Guard{guard | direction: @down}
        {:continue, grid, new_guard}

      guard.direction == @down ->
        new_guard = %Guard{guard | direction: @left}
        {:continue, grid, new_guard}

      guard.direction == @left ->
        new_guard = %Guard{guard | direction: @up}
        {:continue, grid, new_guard}
    end
  end

  defp update_grid(grid, guard, max_x, max_y) do
    {status, new_grid, new_guard} = grid_step(grid, guard, max_x, max_y)

    cond do
      new_grid == grid and new_guard == guard ->
        {status, grid, new_guard}

      true ->
        update_grid(new_grid, new_guard, max_x, max_y)
    end
  end

  def add_one_wall(grid, new_wall) do
    grid
    |> List.update_at(new_wall.y, fn row ->
      List.update_at(
        row,
        new_wall.x,
        fn cell ->
          %Cell{cell | is_wall: true}
        end
      )
    end)
  end

  @doc """
  Get all visited cells in a solved grid
  """
  def get_visits(grid) do
    # could make this a map reduce I think...
    # accumulate a list of valid cells
    Enum.map(grid, fn row ->
      Enum.map(row, fn cell ->
        if cell.visited do
          cell
        else
          nil
        end
      end)
    end)
    |> Enum.map(fn row ->
      filt_row =
        Enum.filter(row, fn cell ->
          cell != nil
        end)

      if length(filt_row) > 0 do
        filt_row
      end
    end)
    |> List.flatten()
    |> Enum.filter(& &1)
  end

  def been_here_already?(grid, guard) do
    row = Enum.at(grid, guard.y)
    cell = Enum.at(row, guard.x)
    cell.visited and Enum.find(cell.guard_dir, fn d -> d == guard.direction end)
  end

  def part1(filepath) do
    grid = parse_grid(filepath)
    guard = get_guard(grid)
    max_y = length(grid)
    max_x = length(Enum.at(grid, 0))
    {_, solved_grid, _} = update_grid(grid, guard, max_x, max_y)

    solved_grid
    |> Enum.reduce(0, fn row, acc ->
      acc + Enum.count(row, fn cell -> cell.visited end)
    end)
  end

  def part2(filepath) do
    # strategy...
    #  1. solve the OG maze
    grid = parse_grid(filepath)
    guard = get_guard(grid)
    max_y = length(grid)
    max_x = length(Enum.at(grid, 0))
    {_, solved_grid, _} = update_grid(grid, guard, max_x, max_y)

    #  2. find all cells that have been visited
    visited_coords =
      get_visits(solved_grid)
      |> Enum.reject(fn cell ->
        cell.x == guard.x and cell.y == guard.y
      end)

    visited_walls =
      Enum.map(visited_coords, fn cell ->
        %Cell{cell | visited: false, is_wall: true, guard_dir: []}
      end)

    #  3. try to solve each grid, making one new cell a wall
    Enum.map(visited_walls, fn new_wall ->
      new_grid = add_one_wall(grid, new_wall)
      {status, _, _} = update_grid(new_grid, guard, max_x, max_y)
      status == :looped
    end)
    |> Enum.count(fn x -> x end)
  end
end

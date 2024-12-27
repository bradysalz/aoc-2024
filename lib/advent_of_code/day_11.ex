defmodule AdventOfCode.Day11 do
  def update_line(starting_line, iterations) do
    Enum.reduce(1..iterations, starting_line, fn _idx, iter_acc ->
      Enum.reduce(iter_acc, [], fn cell, line_acc ->
        cell_as_str = Integer.to_string(cell)

        cond do
          cell == 0 ->
            [1] ++ line_acc

          rem(String.length(cell_as_str), 2) == 0 ->
            {first, second} = String.split_at(cell_as_str, div(String.length(cell_as_str), 2))
            [String.to_integer(second)] ++ [String.to_integer(first)] ++ line_acc

          true ->
            [cell * 2024] ++ line_acc
        end
      end)
    end)
  end

  @doc """
  goddamn you advent of code
  """
  def update_line_with_maps(starting_map, iterations) do
    Enum.reduce(1..iterations, starting_map, fn _idx, iter_acc ->
      Enum.reduce(iter_acc, Map.new(), fn {key, val}, map_acc ->
        key_as_str = Integer.to_string(key)

        cond do
          key == 0 ->
            curr = Map.get(map_acc, 1, 0)
            Map.put(map_acc, 1, curr + val)

          rem(String.length(key_as_str), 2) == 0 ->
            {first, second} = String.split_at(key_as_str, div(String.length(key_as_str), 2))
            {first, second} = {String.to_integer(first), String.to_integer(second)}

            curr_first = Map.get(map_acc, first, 0)
            curr_second = Map.get(map_acc, second, 0)

            if first == second do
              # too lost iterators to fix this
              map_acc
              |> Map.put(first, curr_first + val + val)
            else
              map_acc
              |> Map.put(first, curr_first + val)
              |> Map.put(second, curr_second + val)
            end

          true ->
            curr = Map.get(map_acc, 2024 * key, 0)
            Map.put(map_acc, 2024 * key, curr + val)
        end
      end)
    end)
  end

  def part1(filepath) do
    data =
      filepath
      |> File.read!()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    update_line(data, 25)
    |> Enum.count()
  end

  def part2(filepath) do
    data =
      filepath
      |> File.read!()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    update_line_with_maps(data, 75)
    |> Enum.reduce(0, fn {_key, value}, acc -> value + acc end)
  end
end

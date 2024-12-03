defmodule AdventOfCode.Day02 do
  defp parse_line(line) do
    String.split(line)
    |> Enum.map(&String.to_integer/1)
  end

  defp check_lines_part_two(list) do
    Enum.map(0..length(list), fn index ->
      Enum.take(list, index) ++ Enum.drop(list, index + 1)
    end)
    |> Enum.map(&is_line_safe/1)
    |> Enum.any?(fn x -> x == 1 end)
    |> if(do: 1, else: 0)
  end

  defp is_line_safe(list) do
    staggered_list = Enum.zip(list, Enum.drop(list, 1))

    is_line_increasing =
      staggered_list
      |> Enum.map(fn {first, second} ->
        first < second and Kernel.abs(second - first) <= 3 and Kernel.abs(second - first) >= 1
      end)

    is_line_decreasing =
      staggered_list
      |> Enum.map(fn {first, second} ->
        first > second and Kernel.abs(second - first) <= 3 and Kernel.abs(second - first) >= 1
      end)

    if Enum.all?(is_line_decreasing) or Enum.all?(is_line_increasing) do
      1
    else
      0
    end
  end

  def part1(filepath) do
    numbers =
      filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&is_line_safe/1)
      |> Enum.sum()

    numbers
  end

  def part2(filepath) do
    numbers =
      filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&check_lines_part_two/1)
      |> Enum.sum()

    numbers
  end
end

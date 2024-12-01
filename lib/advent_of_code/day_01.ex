NimbleCSV.define(MyParser, separator: "   ")

defmodule AdventOfCode.Day01 do
  def part1(filepath) do
    {list1, list2} =
      filepath
      |> File.read!()
      |> MyParser.parse_string(skip_headers: false)
      |> Enum.reduce({[], []}, fn row, {list1, list2} ->
        {
          [Enum.at(row, 0) | list1],
          [Enum.at(row, 1) | list2]
        }
      end)

    sorted_l1 = Enum.sort(Enum.map(list1, &String.to_integer/1))
    sorted_l2 = Enum.sort(Enum.map(list2, &String.to_integer/1))

    Enum.zip_with([sorted_l1, sorted_l2], fn [x, y] ->
      Kernel.abs(x - y)
    end)
    |> Enum.sum()
  end

  def part2(filepath) do
    {list1, list2} =
      filepath
      |> File.read!()
      |> MyParser.parse_string(skip_headers: false)
      |> Enum.reduce({[], []}, fn row, {list1, list2} ->
        {
          [Enum.at(row, 0) | list1],
          [Enum.at(row, 1) | list2]
        }
      end)

    list1 = Enum.map(list1, &String.to_integer/1)
    list2 = Enum.map(list2, &String.to_integer/1)
    counts = Enum.frequencies(list2)

    Enum.map(list1, fn x ->
      x * Map.get(counts, x, 0)
    end)
    |> Enum.sum()
  end
end

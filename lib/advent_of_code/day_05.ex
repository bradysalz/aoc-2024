defmodule AdventOfCode.Day05 do
  @doc """
  Split the file up into two lists:
  - First one contains the ordered pages
  - Second one contains the updates
  """
  def parse_file(filepath) do
    file_content = File.read!(filepath)

    [first_half, second_half] =
      file_content
      |> String.split("\n\n", parts: 2)

    first_list =
      first_half
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("|", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    second_list =
      second_half
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn line ->
        line
        |> Enum.map(&String.to_integer/1)
      end)

    {first_list, second_list}
  end

  def build_list(ordering_list) do
    Enum.reduce(ordering_list, [], fn el, acc ->
      {first, second} = List.to_tuple(el)
      # IO.inspect(acc, charlists: :as_list)
      first_found = Enum.find_index(acc, fn el -> el == first end)
      second_found = Enum.find_index(acc, fn el -> el == second end)

      # this is inefficient but meh let's see
      cond do
        first_found == nil and second_found == nil ->
          [first] ++ acc ++ [second]

        first_found == nil ->
          [first] ++ acc

        second_found == nil ->
          acc ++ [second]

        first_found < second_found ->
          acc

        first_found > second_found ->
          # wrong order? pop the wrong element, re-insert right before
          {first, acc_after_first_removal} = List.pop_at(acc, first_found)
          List.insert_at(acc_after_first_removal, second_found, first)

        true ->
          acc
      end
    end)
  end

  def part1(filepath) do
    {ordering_list, pages_list} = parse_file(filepath)

    # returns the sorted list
    sorted_list = build_list(ordering_list)
    # IO.inspect(sorted_list)

    pages_list
    |> Enum.filter(fn sublist ->
      # find index in the sorted list
      sorted_idx =
        Enum.map(sublist, fn x ->
          Enum.find_index(sorted_list, fn el -> el == x end)
        end)

      # |> IO.inspect()

      # return true if all elements are in order
      sorted_idx == Enum.sort(sorted_idx)
    end)
    |> Enum.reduce(0, fn sublist, acc ->
      v = Enum.at(sublist, div(length(sublist), 2))
      acc + v
    end)
  end

  def part2(_args) do
  end
end

defmodule AdventOfCode.Day03 do
  def part1(filepath) do
    data =
      filepath
      |> File.read!()

    Regex.scan(~r/mul\(\d+,\d+\)/, data)
    |> List.flatten()
    |> Enum.map(fn capture ->
      Regex.scan(~r/\d+/, capture)
      |> List.flatten()
      |> Enum.map(&elem(Integer.parse(&1), 0))
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def part2(filepath) do
    data =
      filepath
      |> File.read!()

    Regex.scan(~r/(mul\(\d+,\d+\))|(do\(\))|(don\'t\(\))/, data)
    |> Enum.map(fn [first | _] -> first end)
    |> Enum.reduce({0, true}, fn el, acc ->
      cond do
        # handle the do case
        Regex.match?(~r/do\(\)/, el) ->
          {elem(acc, 0), true}

        # handle the dont case
        Regex.match?(~r/don\'t\(\)/, el) ->
          {elem(acc, 0), false}

        # handle the mul case
        Regex.match?(~r/mul\(\d+,\d+\)/, el) ->
          cond do
            # if do, add the product
            elem(acc, 1) == true ->
              val =
                Regex.scan(~r/\d+/, el)
                |> List.flatten()
                |> Enum.map(&elem(Integer.parse(&1), 0))
                |> Enum.product()

              {elem(acc, 0) + val, elem(acc, 1)}

            # if don't, skip over
            elem(acc, 1) == false ->
              acc
          end

        true ->
          IO.puts("Invalid match found: #{el}")
          acc
      end
    end)
    |> elem(0)
  end
end

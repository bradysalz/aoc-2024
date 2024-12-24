defmodule AdventOfCode.Day07 do
  @doc """
  this is 100% stack overflowed dn't come here looking for help
  """
  def generate_permutations(length, states) do
    Enum.reduce(1..length, [[]], fn _, acc ->
      for current <- states, permutation <- acc do
        [current | permutation]
      end
    end)
  end

  @doc """
  Reads the file and returns a list of tuples
    - First val is the total
    - Second val is the list of inputs
  """
  def read_file(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [total, values] = String.split(row, ":")
      total = String.to_integer(total)

      int_values =
        values
        |> String.split()
        |> Enum.map(&String.to_integer/1)

      {total, int_values}
    end)
  end

  def p1_line_has_solution?(line) do
    line_has_solution?(line, false)
  end

  def p2_line_has_solution?(line) do
    line_has_solution?(line, true)
  end

  @doc """
  Calculate if a line is solvable.
  - For N inputs, there are 2^(N-1)-1 options
  -
  """
  def line_has_solution?(line, is_part_two) do
    {total, inputs} = line
    inputs_len = length(inputs)

    # this worked for part one and I thought it was clever
    # Convert each value to a bitmask
    # max_option_count = 2 ** (length(inputs) - 1) - 1
    # bitmasks =
    #   Enum.to_list(0..max_option_count)
    #   |> Enum.map(fn val ->
    #     Enum.map((inputs_len - 2)..0, fn slot ->
    #       band(val, 1 <<< slot) > 0
    #     end)
    #   end)
    bitmasks =
      if is_part_two do
        generate_permutations(inputs_len - 1, [:add, :mult, :concat])
      else
        generate_permutations(inputs_len - 1, [:add, :mult])
      end

    [start | rest] = inputs

    Enum.reduce_while(bitmasks, {:cont, false}, fn bitmask, _acc ->
      mask_and_val = Enum.zip(bitmask, rest)

      result =
        Enum.reduce(mask_and_val, start, fn {op, val}, acc ->
          case op do
            :add ->
              acc + val

            :mult ->
              acc * val

            :concat ->
              String.to_integer(Integer.to_string(acc) <> Integer.to_string(val))
          end
        end)

      if result == total do
        {:halt, total}
      else
        {:cont, 0}
      end
    end)
  end

  def part1(filepath) do
    read_file(filepath)
    |> Enum.map(&p1_line_has_solution?/1)
    |> Enum.sum()
  end

  def part2(filepath) do
    read_file(filepath)
    |> Enum.map(&p2_line_has_solution?/1)
    |> Enum.sum()
  end
end

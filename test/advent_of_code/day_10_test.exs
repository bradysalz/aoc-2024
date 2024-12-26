defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input = "data/day_10_test.txt"
    result = part1(input)

    assert result == 36
  end

  test "part2" do
    input = "data/day_10_test.txt"
    result = part2(input)

    assert result == 81
  end
end

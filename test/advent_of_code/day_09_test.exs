defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input = "data/day_09_test.txt"
    result = part1(input)

    assert result == 1928
  end

  test "part2" do
    input = "data/day_09_test.txt"
    result = part2(input)

    assert result == 2858
  end
end

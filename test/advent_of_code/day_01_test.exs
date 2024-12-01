defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = "data/day_01_test.txt"
    result = part1(input)

    assert result == 11
  end

  @tag
  test "part2" do
    input = "data/day_01_test.txt"
    result = part2(input)

    assert result == 31
  end
end

defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "part1" do
    input = "data/day_04_test.txt"
    result = part1(input)

    assert result == 18
  end

  test "part2" do
    input = "data/day_04_test.txt"
    result = part2(input)

    assert result == 9
  end
end

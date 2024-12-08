defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    input = "data/day_05_test.txt"
    result = part1(input)

    assert result == 143
  end

  @tag :skip
  test "part2" do
    input = "data/day_05_test.txt"
    result = part2(input)

    assert result
  end
end

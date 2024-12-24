defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  test "part1" do
    input = "data/day_07_test.txt"
    result = part1(input)

    assert result == 3749
  end

  test "part2" do
    input = "data/day_07_test.txt"
    result = part2(input)

    assert result == 11387
  end
end

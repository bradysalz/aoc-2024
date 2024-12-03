defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = "data/day_02_test.txt"
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = "data/day_02_test.txt"
    result = part2(input)

    assert result == 4
  end
end

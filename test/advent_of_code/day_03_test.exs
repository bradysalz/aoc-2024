defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = "data/day_03_test.txt"
    result = part1(input)

    assert result == 161
  end

  test "part2" do
    input = "data/day_03_test.txt"
    result = part2(input)

    assert result == 48
  end
end

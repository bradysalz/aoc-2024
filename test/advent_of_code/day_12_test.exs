defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = "data/day_12_test.txt"
    result = part1(input)

    assert result == 140
  end

  test "part2" do
    input = "data/day_12_test.txt"
    result = part2(input)

    assert result == 80
  end
end

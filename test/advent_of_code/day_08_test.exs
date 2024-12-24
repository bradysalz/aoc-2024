defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  test "part1" do
    input = "data/day_08_test.txt"
    result = part1(input)

    assert result == 14
  end

  test "part2" do
    input = "data/day_08_test.txt"
    result = part2(input)

    assert result == 34
  end
end

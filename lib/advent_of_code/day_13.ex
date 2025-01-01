defmodule AdventOfCode.Day13 do
  defmodule Game do
    defstruct [:a_x, :a_y, :b_x, :b_y, :prize_x, :prize_y]
  end

  def make_games(filepath) do
    filepath
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn game ->
      data =
        Regex.scan(~r/\d+/, game)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)

      [a_x, a_y, b_x, b_y, prize_x, prize_y] = data
      %Game{a_x: a_x, a_y: a_y, b_x: b_x, b_y: b_y, prize_x: prize_x, prize_y: prize_y}
    end)
  end

  def press_button(position, button) do
    {pos_x, pos_y} = position
    {butt_x, butt_y} = button
    {pos_x + butt_x, pos_y + butt_y}
  end

  def is_solution?(game, a_cnt, b_cnt) do
    final_x = a_cnt * game.a_x + b_cnt * game.b_x
    final_y = a_cnt * game.a_y + b_cnt * game.b_y
    game.prize_x == final_x and game.prize_y == final_y
  end

  def solve_game(game) do
    Enum.reduce(0..100, [], fn a_iter, outer_acc ->
      Enum.reduce(0..100, outer_acc, fn b_iter, inner_acc ->
        if is_solution?(game, a_iter, b_iter) do
          [{a_iter, b_iter} | inner_acc]
        else
          inner_acc
        end
      end)
    end)
  end

  def cost_game(solutions) do
    solutions
    |> Enum.map(fn sol ->
      {a, b} = sol
      3 * a + b
    end)
  end

  def part1(filepath) do
    filepath
    |> make_games()
    |> Enum.map(&solve_game/1)
    |> Enum.reject(fn l -> length(l) == 0 end)
    |> Enum.map(&cost_game/1)
    |> Enum.map(&Enum.min/1)
    |> Enum.sum()
  end

  def part2(_args) do
  end
end

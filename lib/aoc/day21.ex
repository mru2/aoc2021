defmodule Aoc.Day21 do
  import Aoc
  import Enum

  @qrolls [
    {3, 1},
    {4, 3},
    {5, 6},
    {6, 7},
    {7, 6},
    {8, 3},
    {9, 1}
  ]

  def roll_once(die), do: {die, rem(die, 100) + 1}

  @doc """
  iex> Aoc.Day21.roll(1)
  {6, 4}
  iex> Aoc.Day21.roll(91)
  {276, 94}
  iex> Aoc.Day21.roll(99)
  {200, 2}
  """
  def roll(die),
    do:
      1..3
      |> reduce({0, die}, fn _, {acc, die} ->
        {roll, die} = roll_once(die)
        {acc + roll, die}
      end)

  def parse(_input), do: {2, 1}

  def play({pos, score}, p2, die, rolls) do
    {roll, die} = roll(die)
    pos = rem(pos + roll, 10)
    score = score + pos + 1
    rolls = rolls + 3

    case score do
      s when s >= 1000 -> {{pos, score}, p2, rolls}
      _ -> play(p2, {pos, score}, die, rolls)
    end
  end

  def play2([], {wins, losses}), do: {wins, losses}

  def play2([{{pos, score}, p2, nb, me} | queue], {wins, losses}) do
    # Setup all 3 rolls
    {won, rest} =
      @qrolls
      |> map(fn {roll, freq} ->
        pos = rem(pos + roll, 10)
        score = score + pos + 1
        {p2, {pos, score}, nb * freq, !me}
      end)
      |> split_with(fn {_, {_, score}, _,  _} -> score >= 21 end)

    won_count = won |> map(fn {_, _, nb, _} -> nb end) |> sum

    # Add wins
    {wins, losses} =
      case me do
        true -> {wins + won_count, losses}
        false -> {wins, losses + won_count}
      end

    queue = rest ++ queue

    play2(queue, {wins, losses})
  end

  def run({p1, p2}) do
    {_, {_, score}, rolls} = play({p1 - 1, 0}, {p2 - 1, 0}, 1, 0)
    score * rolls
  end

  def bonus({p1, p2}) do
    {wins, losses} = play2([{{p1 - 1, 0}, {p2 - 1, 0}, 1, true}], {0, 0})
    "#{wins} vs #{losses}"
  end
end

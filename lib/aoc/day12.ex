defmodule Aoc.Day12 do
  import Aoc
  import Enum

  @doc """
  iex> Aoc.Day12.parse("start-A
  ...>                  start-b
  ...>                  A-c
  ...>                  A-b
  ...>                  b-d
  ...>                  A-end
  ...>                  b-end")
  %{
    "A" => ["end", "b", "c", "start"],
    "b" => ["end", "d", "A", "start"],
    "c" => ["A"],
    "d" => ["b"],
    "end" => ["b", "A"],
    "start" => ["b", "A"]
  }
  """
  def parse(input) do
    input
    |> parse_lines()
    |> reduce(%{}, fn line, graph ->
      [a, b] = String.split(line, "-", trim: true)
      append_paths(graph, a, b)
    end)
  end

  def append_paths(graph, a, b) do
    graph
    |> Map.update(a, [b], &[b | &1])
    |> Map.update(b, [a], &[a | &1])
  end

  def big_cave?(key), do: String.upcase(key) == key

  def explore(_graph, ["end" | _] = trail, _check), do: [:lists.reverse(trail)]

  def explore(graph, [point | _] = trail, can_visit?) do
    case can_visit?.(trail) do
      false ->
        []

      true ->
        graph
        |> Map.get(point)
        |> flat_map(fn dest -> explore(graph, [dest | trail], can_visit?) end)
    end
  end

  def can_visit_1?([point | rest]) do
    cond do
      point == "start" && length(rest) > 0 -> false
      big_cave?(point) -> true
      !member?(rest, point) -> true
      true -> false
    end
  end

  def can_visit_2?([point | rest]) do
    visited_small_caves = reject(rest, &big_cave?/1)
    # Ok to visit if all other small caves have been visited once
    all_visited_once = length(visited_small_caves) == length(uniq(visited_small_caves))

    cond do
      point == "start" && length(rest) > 0 -> false
      big_cave?(point) -> true
      all_visited_once -> true
      !member?(rest, point) -> true
      true -> false
    end
  end

  def run(graph) do
    graph
    |> explore(["start"], &can_visit_1?/1)
    |> length()
  end

  def bonus(graph) do
    graph
    |> explore(["start"], &can_visit_2?/1)
    |> length()
  end
end

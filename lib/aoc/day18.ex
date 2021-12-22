defmodule Aoc.Day18 do
  import Aoc
  import Enum

  @doc """
  iex> Aoc.Day18.parse_line("[9,[8,7]]")
  {9, {8, 7}}
  """
  def parse(input) do
    input |> parse_lines |> map(&parse_line/1)
  end

  def parse_line(line) do
    {data, _} = Code.eval_string(line)
    parse_data(data)
  end

  def parse_data([a, b]), do: {parse_data(a), parse_data(b)}
  def parse_data(n), do: n

  @doc """
  iex> Aoc.Day18.explode({{{{0,9},2},3},4})
  {{{{0,9},2},3},4}

  iex> Aoc.Day18.explode({{{{{9,8},1},2},3},4})
  {{{{0,9},2},3},4}

  iex> Aoc.Day18.explode({7,{6,{5,{4,{3,2}}}}})
  {7,{6,{5,{7,0}}}}

  iex> Aoc.Day18.explode({{6,{5,{4,{3,2}}}},1})
  {{6,{5,{7,0}}},3}

  iex> Aoc.Day18.explode({{6,{5,{4,{3,2}}}},1})
  {{6,{5,{7,0}}},3}

  iex> Aoc.Day18.explode({{3,{2,{1,{7,3}}}},{6,{5,{4,{3,2}}}}})
  {{3,{2,{8,0}}},{9,{5,{4,{3,2}}}}}

  iex> Aoc.Day18.explode({{3,{2,{8,0}}},{9,{5,{4,{3,2}}}}})
  {{3,{2,{8,0}}},{9,{5,{7,0}}}}
  """
  def explode(pair) do
    {tree, _remaining} = explode(pair, 1)
    tree
  end

  def explode(i, _) when is_integer(i), do: i

  def explode({{a, b}, c}, 4) when is_integer(a) and is_integer(b) and is_integer(c),
    do: {{0, b + c}, {a, 0}}

  def explode({a, {b, c}}, 4) when is_integer(a) and is_integer(b) and is_integer(c),
    do: {{a + b, 0}, {0, c}}

  def explode({{a, b}, {c, d}}, 4)
      when is_integer(a) and is_integer(b) and is_integer(c) and is_integer(d),
      do: {{0, {c + b, d}}, {a, 0}}

  def explode({a, b}, _depth) when is_integer(a) and is_integer(b), do: {{a, b}, {0, 0}}

  def explode({a, b}, depth) when is_integer(b) do
    {tree, {l, r}} = explode(a, depth + 1)
    {{tree, b + r}, {l, 0}}
  end

  def explode({a, b}, depth) when is_integer(a) do
    {tree, {l, r}} = explode(b, depth + 1)
    {{a + l, tree}, {0, r}}
  end

  def explode({a, b}, depth) do
    # Try to explode a first, then try b if result is not changed
    case explode(a, depth + 1) do
      {^a, _} ->
        {tree, {l, r}} = explode(b, depth + 1)
        {{feed_right(a, l), tree}, {0, r}}

      {tree, {l, r}} ->
        {{tree, feed_left(b, r)}, {l, 0}}
    end
  end

  def split(n) when is_integer(n) and n > 9 do
    half = div(n, 2)
    {half, n - half}
  end

  def split(n) when is_integer(n), do: n

  def split({a, b}) do
    case split(a) do
      ^a -> {a, split(b)}
      splitted -> {splitted, b}
    end
  end

  def feed_left(x, 0), do: x
  def feed_left({a, b}, l) when is_integer(a), do: {a + l, b}
  def feed_left({a, b}, l), do: {feed_left(a, l), b}

  def feed_right(x, 0), do: x
  def feed_right({a, b}, r) when is_integer(b), do: {a, b + r}
  def feed_right({a, b}, r), do: {a, feed_right(b, r)}

  @doc """
  iex> Aoc.Day18.reduce({{{{{4,3},4},4},{7,{{8,4},9}}},{1,1}})
  {{{{0,7},4},{{7,8},{6,0}}},{8,1}}
  """
  def reduce(number) do
    case explode(number) do
      ^number ->
        case split(number) do
          ^number -> number
          other -> reduce(other)
        end

      other ->
        reduce(other)
    end
  end

  def add(number, acc), do: reduce({acc, number})

  @doc """
  iex> Aoc.Day18.score({{{{3,0},{5,3}},{4,4}},{5,5}})
  791
  """
  def score(a) when is_integer(a), do: a
  def score({a, b}), do: 3 * score(a) + 2 * score(b)

  @doc """
  iex> Aoc.Day18.run([
  ...>   {{{0,{4,5}},{0,0}},{{{4,5},{2,6}},{9,5}}},
  ...>   {7,{{{3,7},{4,3}},{{6,3},{8,8}}}},
  ...>   {{2,{{0,8},{3,4}}},{{{6,7},1},{7,{1,6}}}},
  ...>   {{{{2,4},7},{6,{0,5}}},{{{6,8},{2,8}},{{2,1},{4,5}}}},
  ...>   {7,{5,{{3,8},{1,4}}}},
  ...>   {{2,{2,2}},{8,{8,1}}},
  ...>   {2,9},
  ...>   {1,{{{9,3},9},{{9,0},{0,7}}}},
  ...>   {{{5,{7,4}},7},1},
  ...>   {{{{4,2},2},6},{8,7}}
  ...> ])
  3488
  """
  def run(data) do
    data |> reduce(&add/2) |> score
  end

  def bonus(data) do
    (for a <- data, b <- data, a != b, do: add(a, b) |> score()) |> max()
  end
end

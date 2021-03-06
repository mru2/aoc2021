defmodule Aoc.Day20 do
  import Aoc
  import Enum

  def parse(input) do
    [algo | image] = parse_lines(input)

    {parse_algo(algo), parse_image(image)}
  end

  def parse_algo(algo), do: parse_chars(algo) |> parse_binary()

  def parse_image(image), do: image |> map(&parse_chars/1) |> map(&parse_binary/1) |> Grid.new()

  def parse_binary(charlist),
    do:
      charlist
      |> map(fn
        "." -> 0
        "#" -> 1
      end)

  def to_index([a, b, c, d, e, f, g, h, i]),
    do: 256 * a + 128 * b + 64 * c + 32 * d + 16 * e + 8 * f + 4 * g + 2 * h + i

  @doc """
  iex> Aoc.Day20.enhance(Grid.new([
  ...> [1,0,0,1,0],
  ...> [1,0,0,0,0],
  ...> [1,1,0,0,1],
  ...> [0,0,1,0,0],
  ...> [0,0,1,1,1]]), [0,0,1,0,1,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,1,1,0,1,1,0,0,0,0,0,1,1,1,0,1,1,0,1,0,0,1,1,1,0,1,1,1,1,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,1,1,0,0,1,1,1,0,0,1,1,1,1,1,1,0,1,1,1,0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,1,0,0,1,1,0,0,1,0,1,1,1,1,1,0,0,0,1,1,0,1,0,1,0,0,1,0,1,1,0,0,1,0,1,0,0,0,0,0,0,1,0,1,1,1,0,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,0,0,0,1,0,1,1,0,1,1,0,0,1,0,0,1,0,0,1,1,1,1,1,0,0,0,0,0,1,0,1,0,0,0,0,1,1,1,0,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,1,0,1,0,0,0,1,1,1,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,1,1,0,0,1,0,0,0,1,1,0,1,0,1,1,0,0,1,1,1,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,0,1,1,1,0,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,1,0,0,1,0,1,1,0,1,0,0,0,0,1,1,0,0,1,0,1,1,1,1,0,0,0,0,1,1,0,0,0,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,1,1,1,1,0,0,1,0,0,0,1,0,1,0,1,0,0,0,1,1,0,0,1,0,1,0,0,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,1], 0) |> Grid.to_lists
  [[0,1,1,0,1,1,0],
   [1,0,0,1,0,1,0],
   [1,1,0,1,0,0,1],
   [1,1,1,1,0,0,1],
   [0,1,0,0,1,1,0],
   [0,0,1,1,0,0,1],
   [0,0,0,1,0,1,0]]
  """
  def enhance(image, algo, bg) do
    image = Grid.expand(image, bg)

    Grid.step_self(image, fn coords, grid ->
      index = Grid.square(image, coords, bg) |> to_index
      Grid.set(grid, coords, Enum.at(algo, index))
    end)
  end

  def run({algo, image}) do
    image
    |> enhance(algo, 0)
    |> enhance(algo, 1)
    |> Grid.to_lists()
    |> concat()
    |> sum()
  end

  def bonus({algo, image}) do
    1..25
    |> reduce(image, fn _, image ->
      image
      |> enhance(algo, 0)
      |> enhance(algo, 1)
    end)
    |> Grid.to_lists()
    |> concat()
    |> sum()
  end
end

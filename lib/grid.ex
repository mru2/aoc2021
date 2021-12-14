defimpl Inspect, for: Grid do
  import Inspect.Algebra

  def inspect(grid, opts) do
    Grid.to_lists(grid) |> to_doc(opts)
  end
end

defmodule Grid do
  @behaviour Access

  defstruct [:height, :width, :values]

  def new(list_of_lists) do
    height = length(list_of_lists)
    width = length(List.first(list_of_lists))

    values = list_of_lists |> Enum.concat() |> :array.from_list()

    %Grid{height: height, width: width, values: values}
  end

  def to_lists(grid) do
    for i <- 0..(grid.height - 1) do
      for j <- 0..(grid.width - 1) do
        grid[{i, j}]
      end
    end
  end

  def fetch(grid, coords), do: {:ok, :array.get(index(grid, coords), grid.values)}

  def get_and_update(grid, coords, fun) do
    i = index(grid, coords)
    values = grid.values
    current = :array.get(i, values)

    case fun.(current) do
      {get, update} ->
        {get, %Grid{grid | values: :array.set(i, update, values)}}

      :pop ->
        raise("Pop not handled")

      other ->
        raise "the given function must return a two-element tuple or :pop, got: #{inspect(other)}"
    end
  end

  def pop(_, _), do: raise("Grids do not support pop")

  def index(grid, {i, j}) do
    i * grid.height + j
  end

  def reverse_index(grid, i) do
    {div(i, grid.height), rem(i, grid.height)}
  end

  def coords(grid), do: for(i <- 0..(grid.height - 1), j <- 0..(grid.width - 1), do: {i, j})

  def valid_coords?(grid, {i, j}), do: i >= 0 && j >= 0 && i < grid.height && j < grid.width

  def neighbours(grid, {i, j}) do
    [
      {i - 1, j - 1},
      {i - 1, j},
      {i - 1, j + 1},
      {i, j - 1},
      {i, j + 1},
      {i + 1, j - 1},
      {i + 1, j},
      {i + 1, j + 1}
    ]
    |> Enum.filter(&valid_coords?(grid, &1))
  end

  # Iterates over all grid items with a custom accumulator
  # Callback : fn(grid, coords, acc) -> {grid, acc}
  def walk(grid, acc, fun), do: coords(grid) |> Enum.reduce(acc, fun)

  def map(grid, fun),
    do: %Grid{grid | values: :array.map(fn _i, val -> fun.(val) end, grid.values)}
end

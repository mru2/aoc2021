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

  def set(grid, coords, val) do
    i = index(grid, coords)
    %Grid{grid | values: :array.set(i, val, grid.values)}
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

  def square(grid, {i, j}, default) do
    [
      {i - 1, j - 1},
      {i - 1, j},
      {i - 1, j + 1},
      {i, j - 1},
      {i, j},
      {i, j + 1},
      {i + 1, j - 1},
      {i + 1, j},
      {i + 1, j + 1}
    ]
    |> Enum.map(fn coords ->
      case valid_coords?(grid, coords) do
        true -> grid[coords]
        false -> default
      end
    end)
  end

  def close_neighbours(grid, {i, j}) do
    [
      {i - 1, j},
      {i, j - 1},
      {i, j + 1},
      {i + 1, j}
    ]
    |> Enum.filter(&valid_coords?(grid, &1))
  end

  # Iterates over all grid items with a custom accumulator
  # Callback : fn(grid, coords, acc) -> {grid, acc}
  def reduce_self(grid, acc, fun), do: coords(grid) |> Enum.reduce({grid, acc}, fun)

  def step_self(grid, fun), do: coords(grid) |> Enum.reduce(grid, fun)

  def map(grid, fun),
    do: %Grid{grid | values: :array.map(fn _i, val -> fun.(val) end, grid.values)}

  def expand(grid, value) do
    bounds = 0..(grid.width + 1) |> Enum.map(fn _ -> value end)

    new_vals = [bounds] ++ Enum.map(to_lists(grid), fn row -> [value] ++ row ++ [value] end) ++ [bounds]

    new(new_vals)
  end
end

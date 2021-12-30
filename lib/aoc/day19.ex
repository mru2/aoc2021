defmodule Aoc.Day19 do
  import Aoc
  import Enum

  @moduledoc """
  Stolen from https://github.com/mathsaey/adventofcode/blob/master/lib/2021/19.ex
  """

  # https://www.euclideanspace.com/maths/algebra/matrix/transforms/examples/index.htm
  @orientations [
    # Unmodified
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    # 90
    [[1, 0, 0], [0, 0, -1], [0, 1, 0]],
    # 180
    [[1, 0, 0], [0, -1, 0], [0, 0, -1]],
    # 270
    [[1, 0, 0], [0, 0, 1], [0, -1, 0]]
  ]

  @rotations [
    # Unmodified
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    # z 90
    [[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
    # z 180
    [[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
    # z 270
    [[0, -1, 0], [1, 0, 0], [0, 0, 1]],
    # y 90
    [[0, 0, -1], [0, 1, 0], [1, 0, 0]],
    # y 270
    [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
    # y 180 is the same as z 180
  ]

  # Yes, there probably is a better way to generate this :)
  @translations (for rotation <- @rotations, orientation <- @orientations do
                   # Multiply rotation matrix with orientation matrix
                   transposed = orientation |> zip() |> map(&Tuple.to_list/1)

                   for row <- rotation do
                     for col <- transposed do
                       zip(row, col) |> map(fn {l, r} -> l * r end) |> sum()
                     end
                   end
                 end)

  def parse(input) do
    input
    |> String.split("\n\n")
    |> map(fn sector ->
      sector |> parse_lines() |> tl() |> map(fn line -> parse_numbers(line, ",") end)
    end)
  end

  def merge_scanners([hd | tl]), do: merge_scanners(MapSet.new(hd), [[0, 0, 0]], tl)

  def merge_scanners(merged, beacons, []), do: {merged, beacons}

  def merge_scanners(merged_beacons, beacons, [scanner_beacons | scanners]) do
    distances = distances(merged_beacons)
    translations = all_translations(scanner_beacons)
    all_distances = map(translations, fn {m, t} -> {m, distances(t)} end)

    all_distances
    |> Stream.map(fn {m, d} -> {m, matching_distances(d, distances)} end)
    |> find(fn {_, d} -> map_size(d) >= 12 end)
    |> case do
      {transformation, matching_distances} ->
        {distance, {scanner_beacon, _}} = matching_distances |> take(1) |> hd()
        range_difference = distance(scanner_beacon, elem(distances[distance], 0))

        scanner_beacons
        |> map(&translate(transformation, &1))
        |> map(&distance(&1, range_difference))
        |> MapSet.new()
        |> MapSet.union(merged_beacons)
        |> merge_scanners([range_difference | beacons], scanners)

      nil ->
        merge_scanners(merged_beacons, beacons, scanners ++ [scanner_beacons])
    end
  end

  def all_translations(beacons) do
    map(@translations, fn t -> {t, map(beacons, &translate(t, &1))} end)
  end

  def translate(m, v), do: map(m, &dot(&1, v))

  def dot(v1, v2), do: zip(v1, v2) |> map(fn {l, r} -> l * r end) |> sum()

  def matching_distances(d1, d2), do: Map.take(d1, Map.keys(d2))

  def distances(beacons) do
    beacons
    |> flat_map(fn beacon -> beacons |> map(&{distance(beacon, &1), {beacon, &1}}) end)
    |> reject(fn {_, {b1, b2}} -> b1 == b2 end)
    |> Map.new()
  end

  def distance([lx, ly, lz], [rx, ry, rz]), do: [lx - rx, ly - ry, lz - rz]

  def run(data) do
    data |> merge_scanners() |> elem(0) |> MapSet.size()
  end

  def bonus(data) do
    data
    |> merge_scanners()
    |> elem(1)
    |> distances()
    |> Map.keys()
    |> map(fn d -> d |> map(&abs/1) |> sum() end)
    |> max()
  end
end

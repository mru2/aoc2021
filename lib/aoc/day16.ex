defmodule Aoc.Day16 do
  import Aoc
  import Enum

  @doc """
  iex> Aoc.Day16.parse("D2FE28")
  {:lit, 6, 2021}
  iex> Aoc.Day16.parse("38006F45291200")
  {{:op, 6}, 1, [{:lit, 6, 10}, {:lit, 2, 20}]}
  iex> Aoc.Day16.parse("EE00D40C823060")
  {{:op, 3}, 7, [{:lit, 2, 1}, {:lit, 4, 2}, {:lit, 1, 3}]}
  iex> Aoc.Day16.parse("8A004A801A8002F478")
  {{:op, 2}, 4, [{{:op, 2}, 1, [{{:op, 2}, 5, [{:lit, 6, 15}]}]}]}
  iex> Aoc.Day16.parse("620080001611562C8802118E34")
  {{:op, 0}, 3, [{{:op, 0}, 0, [{:lit, 0, 10}, {:lit, 5, 11}]}, {{:op, 0}, 1, [{:lit, 0, 12}, {:lit, 3, 13}]}]}
  iex> Aoc.Day16.parse("C0015000016115A2E0802F182340")
  {{:op, 0}, 6, [{{:op, 0}, 0, [{:lit, 0, 10}, {:lit, 6, 11}]}, {{:op, 0}, 4, [{:lit, 7, 12}, {:lit, 0, 13}]}]}
  iex> Aoc.Day16.parse("A0016C880162017C3686B18A3D4780")
  {{:op, 0}, 5, [{{:op, 0}, 1, [{{:op, 0}, 3, [{:lit, 7, 6}, {:lit, 6, 6}, {:lit, 5, 12}, {:lit, 2, 15}, {:lit, 2, 15}]}]}]}
  """
  def parse(input) do
    [line] = parse_lines(input)
    {packet, _} = line |> Base.decode16!() |> decode_packet()
    packet
  end

  # Literal
  def decode_packet(<<version::3, 4::3, rest::bitstring>>) do
    {val, rest} = decode_literal(rest)
    {{:lit, version, val}, rest}
  end

  # Length-delimited operator
  def decode_packet(
        <<version::3, code::3, 0::1, len::15, packets::bitstring-size(len), rest::bitstring>>
      ) do
    {{{:op, code}, version, decode_packets(packets)}, rest}
  end

  # Count-delimited operator
  def decode_packet(<<version::3, code::3, 1::1, count::11, rest::bitstring>>) do
    {packets, rest} = extract_packets(rest, count)
    {{{:op, code}, version, packets}, rest}
  end

  def decode_packets(bin, acc \\ [])
  def decode_packets("", acc), do: :lists.reverse(acc)

  def decode_packets(bin, acc) do
    {packet, rest} = decode_packet(bin)
    decode_packets(rest, [packet | acc])
  end

  def extract_packets(bin, count), do: extract_packets(bin, count, [])
  def extract_packets(bin, 0, acc), do: {:lists.reverse(acc), bin}

  def extract_packets(bin, count, acc) do
    {packet, rest} = decode_packet(bin)
    extract_packets(rest, count - 1, [packet | acc])
  end

  def decode_literal(<<more::size(1), val::size(4), rest::bitstring>>, acc \\ 0) do
    acc = acc * 16 + val

    case more do
      1 -> decode_literal(rest, acc)
      0 -> {acc, rest}
    end
  end

  def evaluate({:lit, _version, val}), do: val
  def evaluate({{:op, code}, _version, sub}) do
    vals = sub |> map(&evaluate/1)
    case code do
      0 -> sum(vals)
      1 -> product(vals)
      2 -> min(vals)
      3 -> max(vals)
      5 -> case vals do
        [a, b] when a > b -> 1
        _ -> 0
      end
      6 -> case vals do
        [a, b] when a < b -> 1
        _ -> 0
      end
      7 -> case vals do
        [a, a] -> 1
        _ -> 0
      end
    end
  end

  def sum_versions({:lit, version, _val}), do: version
  def sum_versions({{:op, _code}, version, sub}), do: version + (sub |> map(&sum_versions/1) |> sum())

  def run(data), do: data |> sum_versions()

  def bonus(data), do: data |> evaluate()
end

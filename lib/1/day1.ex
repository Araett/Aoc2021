defmodule Aoc2021.Day1 do
  

  def part1(pathname) do
    Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> Aoc2021.string_list_to_integer_list
    |> count_increase
    |> IO.puts
  end

  def part2(pathname) do
    Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> Aoc2021.string_list_to_integer_list
    |> construct_sums
    |> count_increase
    |> IO.puts
  end

  defp construct_sums([a, b | tail]) do
    d = List.zip([[a | [b | tail]], [b | tail], tail])
    Enum.map(d, fn x -> Enum.sum(Tuple.to_list(x)) end)
  end

  defp count_increase([head | tail]), do: count_incr(0, head, tail)

  defp count_incr(count, _, []), do: count
  defp count_incr(count, val, [head | tail]) when head > val do
    count_incr(count + 1, head, tail) 
  end
  defp count_incr(count, _, [head | tail]) do
    count_incr(count, head, tail) 
  end

end

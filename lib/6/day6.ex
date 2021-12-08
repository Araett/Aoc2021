defmodule Aoc2021.Day6 do

  def part1(pathname, days_to_simulate) do
    # Naive
    Aoc2021.read_file(pathname)
    |> split_integers_by_comma
    |> simulate_propogation(days_to_simulate)
    |> length
  end

  def part2(pathname, days_to_simulate) do
    Aoc2021.read_file(pathname)
    |> split_integers_by_comma
    |> count_to_map(%{})
    |> simulate_propogation_opt(days_to_simulate)
    |> Map.values
    |> Enum.sum
  end

  defp count_to_map([], counter), do: counter
  defp count_to_map([head | tail], counter) do
    case Map.get(counter, head) do
      nil -> count_to_map(tail, Map.put(counter, head, 1))
      x -> count_to_map(tail, Map.put(counter, head, x + 1))
    end
  end

  defp split_integers_by_comma(string) do
    String.trim(string, "\n")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp simulate_propogation(fishes, 0), do: fishes
  defp simulate_propogation(fishes, n) do
    Enum.map(IO.inspect(fishes), &(&1 - 1))
    |> propogate_after_zero([])
    |> simulate_propogation(IO.inspect(n - 1))
  end

  defp propogate_after_zero([], acc), do: acc
  defp propogate_after_zero([-1 | tail], acc), do: propogate_after_zero(tail, [6, 8 | acc])
  defp propogate_after_zero([head | tail], acc), do: propogate_after_zero(tail, [head | acc])

  defp simulate_propogation_opt(fishes, 0), do: fishes
  defp simulate_propogation_opt(fishes, n) do 
    count_down(IO.inspect(fishes), Map.keys(fishes), %{})
    |> propogate_after_zero_map
    |> simulate_propogation_opt(IO.inspect(n - 1))
  end

  defp count_down(_, [], acc), do: acc
  defp count_down(fishes, [-1 | tail], acc), do: count_down(fishes, tail, acc)
  defp count_down(fishes, [head | tail], acc) do
    count_down(fishes, tail, Map.put(acc, head - 1, Map.get(fishes, head)))
  end

  defp propogate_after_zero_map(fishes) do
    Map.put(fishes, 8, Map.get(fishes, -1, 0))
    |> Map.put(6, Map.get(fishes, 6, 0) + Map.get(fishes, -1, 0))
    |> Map.put(-1, 0)
  end

end

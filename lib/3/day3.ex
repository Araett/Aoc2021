defmodule Aoc2021.Day3 do

  def part1(pathname) do
    binaries = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> split_list_of_strings_into_graphemes
    |> convert_list_of_graphemes_to_integers
    l = length(binaries)
    sum = sum_list_of_integers_to_one_list(binaries)
    gamma = convert_binary_list_to_binary_string(find_gamma(sum, l))
    epsilon = convert_binary_list_to_binary_string(find_epsilon(sum, l))
    :erlang.binary_to_integer(gamma, 2) * :erlang.binary_to_integer(epsilon, 2)
  end

  def part2(pathname) do
    binaries = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> split_list_of_strings_into_graphemes
    |> convert_list_of_graphemes_to_integers
    oxygen = convert_binary_list_to_binary_string(find_oxygen(binaries))
    dioxide = convert_binary_list_to_binary_string(find_dioxide(binaries))
    :erlang.binary_to_integer(oxygen, 2) * :erlang.binary_to_integer(dioxide, 2)
  end

  def split_list_of_strings_into_graphemes(list), do: Enum.map(list, &String.graphemes(&1))

  def convert_list_of_graphemes_to_integers(list) do
    Enum.map(list, &Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  defp find_oxygen(list), do: search_oxygen([], list, 0, length(list), sum_list_of_integers_to_one_list(list))

  defp search_oxygen([], [head | []], _, _, _), do: head
  defp search_oxygen([head], [], _, _, _), do: head
  defp search_oxygen(acc, [], n, _, _), do: search_oxygen([], acc, n + 1, length(acc), sum_list_of_integers_to_one_list(acc))
  defp search_oxygen(acc, [head | tail], n, l, sum) do
    # Might be a bad idea.
    case is_most_common_bit?(Enum.at(head, n), Enum.at(sum, n), l) do
      true -> search_oxygen([head | acc], tail, n, l, sum)
      false -> search_oxygen(acc, tail, n, l, sum)
    end
  end

  defp find_dioxide(list), do: search_dioxide([], list, 0, length(list), sum_list_of_integers_to_one_list(list))

  defp search_dioxide([], [head | []], _, _, _), do: head
  defp search_dioxide([head], [], _, _, _), do: head
  defp search_dioxide(acc, [], n, _, _), do: search_dioxide([], acc, n + 1, length(acc), sum_list_of_integers_to_one_list(acc))
  defp search_dioxide(acc, [head | tail], n, l, sum) do
    # Wtf am I doing here.
    case is_least_common_bit?(Enum.at(head, n), Enum.at(sum, n), l) do
      true -> search_dioxide([head | acc], tail, n, l, sum)
      false -> search_dioxide(acc, tail, n, l, sum)
    end
  end

  defp is_most_common_bit?(x1, x2, l), do: x1 == find_most_common_bit(x2, l)
  defp is_least_common_bit?(x1, x2, l), do: x1 == find_least_common_bit(x2, l)

  defp sum_list_of_integers_to_one_list([head | tail]), do: reduce(head, tail)

  defp reduce(r, []), do: r
  defp reduce(r, [head | tail]), do: reduce(sum_two_lists(r, head, []), tail)

  defp sum_two_lists([], [], total) do
    Enum.reverse(total)
  end
  defp sum_two_lists([h1 | t1], [], total) do
    sum_two_lists(t1, [], [h1 | total])
  end
  defp sum_two_lists([], [h2 | t2], total) do
    sum_two_lists([], t2, [h2 | total])
  end
  defp sum_two_lists([h1 | t1], [h2 | t2], total) do
    sum_two_lists(t1, t2, [h1 + h2 | total])
  end

  defp find_most_common_bit(x, l), do: if x >= (l / 2), do: 1, else: 0
  defp find_least_common_bit(x, l), do: if x < (l / 2), do: 1, else: 0

  defp find_gamma(sum, l), do: Enum.map(sum, &find_most_common_bit(&1, l))
  defp find_epsilon(sum, l), do: Enum.map(sum, &find_least_common_bit(&1, l))

  defp convert_binary_list_to_binary_string(list) do
    Enum.join(Enum.map(list, &Integer.to_string/1), "")
  end

end





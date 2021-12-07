defmodule Aoc2021.Day5 do
  
  def part1(pathname) do
    Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> generate_lines([], &crawl_perp/5)
    |> count_covers(%{})
    |> Map.values
    |> count_intersections(0)
  end

  def part2(pathname) do
    Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> generate_lines([], &crawl/5)
    |> count_covers(%{})
    |> Map.values
    |> count_intersections(0)
  end

  def count_intersections([], acc), do: acc
  def count_intersections([x | tail], acc) when x > 1, do: count_intersections(tail, acc + 1)
  def count_intersections([_ | tail], acc), do: count_intersections(tail, acc)

  defp count_covers([], counter), do: counter
  defp count_covers([{:nil} | tail], counter), do: count_covers(tail, counter)
  defp count_covers([head | tail], counter) do
    case Map.get(counter, head, nil) do
      nil -> count_covers(tail, Map.put(counter, head, 1))
      x -> count_covers(tail, Map.put(counter, head, x + 1))
    end
  end

  defp generate_lines([], all_lines, _), do: all_lines
  defp generate_lines([head | directions], all_lines, fun) do
    covered_spaces = parse_coordinates(head)
    |> go_through_coordinates(fun)
    generate_lines(directions, all_lines ++ covered_spaces, fun)
  end

  defp parse_coordinates(coord) do
    String.split(coord, " -> ")
    |> Enum.map(&split_numbers_by_comma(&1))
  end

  defp split_numbers_by_comma(str) do
    String.split(str, ",")
    |> Enum.map(&String.to_integer/1)
  end

  defp go_through_coordinates([[x1, y1], [x2, y2]], crawl_fun) do
    crawl_fun.(x1, y1, x2, y2, [])
  end


  defp crawl_perp(x1, y1, x1, y1, coordinates), do: [{x1, y1} | coordinates]
  defp crawl_perp(x1, y1, x1, y2, coordinates) do
    crawl_perp(x1, y1 + direction(y2 - y1), x1, y2, [{x1, y1} | coordinates])
  end
  defp crawl_perp(x1, y1, x2, y1, coordinates) do
    crawl_perp(x1 + direction(x2 - x1), y1, x2, y1, [{x1, y1} | coordinates])
  end

  defp crawl_perp(x1, x1, x2, x2, []), do: [{:nil}]
  defp crawl_perp(x1, x2, x2, x1, []), do: [{:nil}]
  defp crawl_perp(_, _, _, _, []), do: [{:nil}]


  defp crawl(x1, y1, x1, y1, coordinates), do: [{x1, y1} | coordinates]
  defp crawl(x1, y1, x2, y2, coordinates) do
    crawl(x1 + direction(x2 - x1), y1 + direction(y2 - y1), x2, y2, [{x1, y1} | coordinates])
  end

  defp direction(x) when x > 0, do: 1
  defp direction(x) when x < 0, do: -1
  defp direction(0), do: 0

end
